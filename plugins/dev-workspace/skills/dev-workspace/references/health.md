# health — check-script contract

`dev-workspace health` runs an advisory, **read-only** install-health report. It
discovers and executes every check script under the plugin's
`hooks/health/` directory, prints each check's findings, and exits non-zero only
when a blocker is found.

This is distinct from the `/health` slash command, which reports *repository*
health (branches, remotes, sync, worktrees, PRs). `health` reports *plugin
install* health (scope, stub location, …).

`dev-workspace` and `dev-deploy` share one normalized runner, so both produce
the same on-screen shape.

## Output format

```
══ dev-workspace health ══

▸ <pretty name>
  <check's glyph lines, indented two spaces>

▸ <pretty name>
  ...

────────────────────────────────
N checks · P ✓ · A ⚠ · B ❌ → <all clear | advisories (exit 0) | blockers (exit 2)>
```

- The per-check header `▸ <pretty name>` is derived from the check filename:
  the leading `NN-` is stripped and `-` becomes a space (e.g. `10-plugin-scope`
  → `plugin scope`).
- Each check's own output is indented two spaces.
- The footer counts checks by severity and states the overall result.

## Where checks live

```
plugins/dev-workspace/hooks/health/
  10-plugin-scope
  20-stub-location
  ...
```

- One file per check, executable (`chmod +x`).
- Named `NN-name` (e.g. `10-plugin-scope`). The numeric prefix sets run order —
  checks run in **sorted** order.
- Dropping a script here is all that's needed to add a check. No core edits.
- `hooks/hooks.json` is untouched; the Claude Code hook loader ignores this
  subfolder.

## Contract

### Input — environment variables

The runner exports these for every check:

- `PLUGIN_ROOT` — absolute path to this plugin (`.../plugins/dev-workspace`).
- `PLUGIN_NAME` — the plugin name, `dev-workspace`.
- `PROJECT_ROOT` — absolute path to the dev-workspace project, or **empty
  string** when not run inside a project.
- `CONFIG` — absolute path to the project config file
  (`dev/workspace/workspace-config.yml`), or empty string when none.

### Output — stdout

- Print human-readable lines, each prefixed with a status glyph:
  - `✓ ` pass
  - `⚠ ` advisory
  - `❌ ` blocker
- A check MAY print an extra **indented** suggested command on its own line
  (four spaces), e.g.:

  ```
  ⚠ dev-workspace enabled at user scope — hooks fire in every project
      claude plugin uninstall dev-workspace --scope user && claude plugin install dev-workspace@<marketplace> --scope project
  ```

### Output — exit code (severity)

- `0` — pass
- `1` — advisory
- `2` — blocker

### Read-only rule

Checks must **never mutate state**: no writes outside stdout, no git changes,
no installs. Inspect and *suggest* only — the suggested command is printed for
the human to run, never executed.

## Runner behaviour

- Discovers every executable regular file in `hooks/health/`, sorted by name.
- Runs each with the contract env exported; a check's non-zero exit never aborts
  the run.
- Tracks the **maximum** severity returned across all checks.
- Prints a summary footer (all clear / advisories / blockers).
- Sets its own exit code to `2` **iff** any check returned `2` (blocker);
  otherwise `0`. Advisories (`1`) never make the runner fail — so it is
  CI-safe (blockers are scriptable, advisories are informational).

## Adding a new check

1. Create an executable script `hooks/health/NN-name` (pick `NN` for ordering).
2. Read the env vars you need (`PLUGIN_ROOT`, `PLUGIN_NAME`, `PROJECT_ROOT`,
   `CONFIG`).
3. Inspect state read-only; print `✓ ` / `⚠ ` / `❌ ` lines (+ optional indented
   suggestion).
4. `exit` with the matching severity (`0` / `1` / `2`).
5. `chmod +x` the file. It is picked up automatically — no core edits.

### Minimal template

```bash
#!/bin/bash
set -u
# Env available: PLUGIN_ROOT PLUGIN_NAME PROJECT_ROOT CONFIG

if some_condition_ok; then
    echo "✓ ${PLUGIN_NAME} <thing> is fine"
    exit 0
fi

echo "⚠ ${PLUGIN_NAME} <thing> needs attention"
echo "    <suggested command to fix>"
exit 1
```

## Shipped checks

- **`10-plugin-scope`** — reads `enabledPlugins` in `~/.claude/settings.json`
  (user) and `$PROJECT_ROOT/.claude/settings.json` (project), matching by
  `${PLUGIN_NAME}@` prefix. Project scope → `✓`; user-only → advisory (hooks
  fire everywhere); not found → advisory.
- **`20-stub-location`** — checks `~/.local/bin/${PLUGIN_NAME}` exists and
  resolves (symlink or stub script) to
  `skills/<name>/scripts/<name>` in the installed plugin. Good → `✓`; missing or
  mispointed → advisory with an `ln -s` suggestion.
