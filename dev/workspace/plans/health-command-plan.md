# Plan: `health` command for dev-workspace / dev-deploy plugins

> **Branch:** `feature/health-command` · **Tracking:** GitHub issue #8
> This is the design reference. Confirmed decisions + the actionable checklist live in
> `dev/workspace/tasks/health-command-tasks.md` — start there.

## Goal

Add an advisory, read-only `health` command to the dev-workspace plugin (and reconcile dev-deploy's existing `health`) that runs a set of pluggable **checks** and reports status + suggested actions. First concrete use: detect plugin install **scope** and suggest moving to project scope when appropriate.

## Why (background / decisions already made)

- These plugins are moving to **project scope**, not user scope. Reason: the plugin's `SessionStart`/`SessionEnd` hooks (`dev-workspace` splash + `dev-workspace tree`) fire in *every* session when installed at user scope, producing banner noise + a "Not in a dev-workspace project" error from `tree` in non-dw projects. Project scope means the plugin (and its hooks) only load where it's enabled.
- We rejected baking hook-gating logic into the CLI `case` dispatch (e.g. `cmd_session_start`/`in_workspace`). Hooks are a manifest concern; gating them in-script means untangling core code to add a hook. Project scope avoids the problem entirely.
- We rejected having `init --write` mutate `~/.claude/settings.json` to change scope. That's global/environment state outside the project — a surprising, hard-to-reverse action. **Advisory `health` is the right layer**: detect + suggest, never auto-apply.

## Design

### Command
- `dev-workspace health` — run all checks, print a `✓ / ⚠ / ❌` report.
- Read-only. Suggests commands; never runs them. (Optional future: explicit opt-in `health --fix`.)
- Exit code: **0** when only passes/advisories (`✓`/`⚠`); **non-zero** only when a real blocker (`❌`) is present — so advisories never fail a pipeline but blockers are scriptable/CI-friendly.
- Mirror into dev-deploy (it already has a `health` command — fold it into this pluggable model rather than two designs).

### Pluggable checks
- Checks live under the plugin's existing hooks folder: **`hooks/health/`** (avoids adding a new top-level dir; `hooks/hooks.json` is untouched — the loader ignores the subfolder).
  ```
  plugins/dev-workspace/hooks/health/
    10-plugin-scope
    20-tree-cli
    ...
  ```
- The runner discovers and executes every file in `hooks/health/` (sorted by name for stable order), aggregates output.
- Optional extension (decide later): also run project-local custom checks from `dev/workspace/health.d/`.
- Adding a check = drop a script in `hooks/health/`. No core edits.

### Check-script contract (define precisely in implementation)
- Resolved via `PLUGIN_ROOT` (already computed in the script: `hooks/health/`).
- Runner passes context as env: `PROJECT_ROOT` (empty if none), `CONFIG` path, etc.
- Each check prints human-readable lines (prefix `✓`/`⚠`/`❌` + message + optional suggested command).
- Exit code convey severity: `0` pass, `1` advisory, `2` blocker. Runner's overall exit = non-zero iff any check returned `2`.

### First checks to ship
1. **`10-plugin-scope`** — read `~/.claude/settings.json` `enabledPlugins` for `dev-workspace@*`.
   - User scope → `⚠ enabled at user scope — hooks fire in every project. For isolation: claude plugin uninstall dev-workspace --scope user && claude plugin install dev-workspace@<marketplace> --scope project`.
   - Project scope (this repo's `.claude/settings.json`) → `✓`.
   - Phrase as advice, not alarm (user may legitimately want user scope).
2. **`20-tree-cli`** — `tree` CLI present (migrate the check currently in `init_check`).
3. (Candidates) workspace-config present/valid; git remotes resolve; `.gitattributes` merge driver registered.

## Work breakdown

1. Define the check-script contract (env in, status/exit-code out) — write it into `references/health.md`.
2. Implement `cmd_health` runner in `skills/dev-workspace/scripts/dev-workspace`: discover `hooks/health/*`, run each, aggregate, set exit code. Add dispatch `case` + `help` entry.
3. Author `hooks/health/10-plugin-scope` and `20-tree-cli`.
4. Add `references/health.md` (contract + how to add a check).
5. dev-deploy: reconcile its existing `health` with the pluggable model (shared contract; its checks under `plugins/dev-deploy/hooks/health/`).
6. Project-scope rollout docs: `claude plugin install …@<mp> --scope project`, optional `extraKnownMarketplaces` in repo `.claude/settings.json` so clones are prompted on trust. (The scope check surfaces this at runtime.)

## Open questions to resolve in the new workspace
- Exact severity protocol (exit codes vs structured stdout tokens like `STATUS|msg|fix`).
- Do we support project-local `dev/workspace/health.d/` custom checks now or later?
- Should `health` run automatically (e.g. as a SessionStart hook in dw projects), or stay manual-only? (Lean manual; auto-run reintroduces session noise.)
- Marketplace name is still in flux (DBHD-Plugins vs DBHG-Plugin-Marketplace) — the scope check should match by `dev-workspace@` prefix, not a hardcoded marketplace.
- Whether to add `health --fix` opt-in remediation later.

## Files likely touched
- `plugins/dev-workspace/skills/dev-workspace/scripts/dev-workspace` (cmd_health, dispatch, help)
- `plugins/dev-workspace/hooks/health/*` (new checks)
- `plugins/dev-workspace/skills/dev-workspace/references/health.md` (new)
- `plugins/dev-deploy/...` (reconcile existing health + its own `hooks/health/`)

## Testing
- Run `dev-workspace health` in: a dw project (project scope), a dw project (user scope), and a non-dw dir. Confirm correct `✓/⚠`, exit codes, and that suggestions are accurate.
- Verify checks are discovered purely by presence in `hooks/health/` (drop a throwaway check, confirm it runs).
</content>
