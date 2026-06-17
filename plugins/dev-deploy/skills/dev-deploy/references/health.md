# Health

`dev-deploy health` is a single, unified, **pluggable** health command. It
discovers and runs every executable in the plugin's `hooks/health/` folder
(sorted by name), prints each check's findings under a per-check header, and
prints a summary footer. It exits non-zero (2) only if a check reports a
blocker — advisories never fail it. Everything is **read-only**: checks inspect
and suggest, never mutate state. This shares one normalized runner with
`dev-workspace health`.

Checks fall into two groups:

- **Install checks** (`10`, `20`) — how this plugin is installed (scope, stub).
  Useful even outside a configured deploy project.
- **Deploy checks** (`30`, `40`, `50`) — operational deploy state (Kamal app
  status, branch sync, server health). These self-skip cleanly when not in a
  deploy project.

---

## Output format

```
══ dev-deploy health ══

▸ <pretty name>
  <check's glyph lines, indented two spaces>

▸ <pretty name>
  ...

────────────────────────────────
N checks · P ✓ · A ⚠ · B ❌ → <all clear | advisories (exit 0) | blockers (exit 2)>
```

- The per-check header `▸ <pretty name>` is derived from the check filename:
  the leading `NN-` is stripped and `-` becomes a space (e.g. `30-kamal-apps`
  → `kamal apps`).
- Each check's own output is indented two spaces.
- The footer counts checks by severity and states the overall result.

---

## Check-script contract

A check is an executable file in `"$PLUGIN_ROOT/hooks/health/"`, named `NN-name`
(e.g. `10-plugin-scope`) so checks run in a stable, sorted order. Identical
contract to `dev-workspace`.

**Environment exported to each check:**

Common (both plugins):
- `PLUGIN_ROOT` — this plugin's install root.
- `PLUGIN_NAME` — `dev-deploy`.
- `PROJECT_ROOT` — the project root, or empty string if not in a project.
- `CONFIG` — path to the project's `dev/deploy/deploy-config.yml`, or empty.

Deploy vars (populated by `load_config` when a config exists; empty otherwise):
- `SOURCE_BRANCH`, `STAGING_BRANCH`, `PROD_BRANCH`
- `PROD_KAMAL_DEST`, `STAGING_KAMAL_DEST`
- `SERVER_HOST`, `SERVER_PORT`
- `HOOK_HEALTH` — path (relative to `PROJECT_ROOT`) of the custom server-health
  hook, if configured.

**Output:** each check prints one or more lines, each prefixed with a status
glyph and a space, then a message. It may print an extra indented line with a
suggested command.

- `✓ ` — pass
- `⚠ ` — advisory
- `❌ ` — blocker

**Exit code = severity:**

- `0` — pass
- `1` — advisory
- `2` — blocker

The runner's overall exit is `2` iff any check returned `2`; otherwise `0`.

### Adding a check

Drop an executable script in `hooks/health/`, name it `NN-name`, follow the
contract above. No core script edits — the runner discovers it automatically.

```bash
#!/bin/bash
# Example: passes, advises, or blocks based on some inspection.
set -u
if some_condition; then
    echo "✓ all good"
    exit 0
fi
echo "⚠ something to look at"
echo "    suggested-fix-command"
exit 1
```

---

## Shipped checks

### Install checks

- **`10-plugin-scope`** — inspects `enabledPlugins` in `~/.claude/settings.json`
  (user) and `<project>/.claude/settings.json` (project), matching by
  `dev-deploy@` prefix (never a hardcoded marketplace name).
  - Project scope → `✓` (pass).
  - User scope only → `⚠` advisory + suggested
    `claude plugin uninstall dev-deploy --scope user && claude plugin install dev-deploy@<marketplace> --scope project`.
  - Not found → `⚠` advisory.
- **`20-stub-location`** — checks `~/.local/bin/dev-deploy` exists and resolves
  (as a symlink or wrapper stub) to the installed plugin's
  `skills/dev-deploy/scripts/dev-deploy`. `✓` if good; `⚠` advisory with an
  `ln -s` suggestion if missing or mispointed.

### Deploy checks

All deploy checks print `✓ skipped — not a deploy project` and exit 0 when
`CONFIG` is empty (i.e. no `deploy-config.yml`).

- **`30-kamal-apps`** — queries Kamal for app status.
  - `kamal` not on PATH → `⚠ kamal not found — skipping app status` (advisory).
  - Production (`PROD_KAMAL_DEST`): up → `✓ Production: up (...)`; down →
    `⚠ Production: down` (advisory — never a blocker).
  - Staging (`STAGING_KAMAL_DEST`, only if set): up → `✓ Staging: up (...)`;
    down → `⚠ Staging: down` (advisory).
- **`40-branch-sync`** — reports git sync state (fetches origin first).
  - Source branch vs origin: in sync → `✓`; otherwise → `⚠` (advisory).
  - Staging ahead/behind origin: in sync → `✓`; otherwise → `⚠` (advisory).
  - Source → staging merge: up to date → `✓`; N commits not yet staged → `⚠`
    (advisory).
- **`50-server`** — server health.
  - If `HOOK_HEALTH` is set: runs `"$PROJECT_ROOT/$HOOK_HEALTH"` and reflects
    its result (`✓` on exit 0, `⚠` otherwise).
  - Else if `SERVER_HOST` set: basic SSH disk check → `✓ Disk: ...` on success,
    `⚠ server unreachable` on failure (advisory).
  - Else → `✓ skipped — no server configured`.

> Note: `hooks.health` (a deploy-config server-health hook) is distinct from
> the plugin's `hooks/health/` install-health checks. The former is a single
> user-supplied server probe invoked by the `50-server` check; the latter is
> the pluggable check folder run by the `health` runner.

---

## Custom health hook

For detailed server checks, create a health hook at `dev/deploy/hooks/health`
and wire it via `hooks.health` in config. The `50-server` check execs it and
reflects its exit status.

```bash
#!/bin/bash
set -e

echo "→ Disk:"
ssh -o ConnectTimeout=5 "$DEPLOY_SERVER_HOST" \
  "df -h / | tail -1 | awk '{printf \"  %s used of %s (%s free)\n\", \$3, \$2, \$4}'"

echo "→ Backups:"
ssh -o ConnectTimeout=5 "$DEPLOY_SERVER_HOST" "
  BACKUP_DIR=/backups/myapp
  HOURLY=\$(ls -1 \$BACKUP_DIR/production-*.sqlite3 2>/dev/null | wc -l | tr -d ' ')
  DAILY=\$(ls -1 \$BACKUP_DIR/daily-*.sqlite3 2>/dev/null | wc -l | tr -d ' ')
  LATEST=\$(ls -1t \$BACKUP_DIR 2>/dev/null | head -1)
  echo \"  \${HOURLY} hourly, \${DAILY} daily\"
  [ -n \"\$LATEST\" ] && echo \"  latest: \$LATEST\"
"
```

Wire it in config:
```yaml
hooks:
  health: dev/deploy/hooks/health
```

---

## Agent usage

Agents can run `dev-deploy health` during heartbeat checks to monitor install
and deployment state. Parse the summary footer / per-check glyphs to detect
issues and alert the human if something's down.
