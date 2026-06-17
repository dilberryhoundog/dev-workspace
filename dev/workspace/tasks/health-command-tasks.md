# Tasks: `health` command (issue #8)

**Branch:** `feature/health-command` · **Design reference:** `dev/workspace/plans/health-command-plan.md`

Build an advisory, read-only `health` CLI command for both plugins that runs pluggable check scripts from a `hooks/health/` folder and reports `✓/⚠/❌` findings. First two checks: plugin install **scope** and **stub location**.

## Confirmed decisions (this workspace)

1. **Naming** — rename the existing `/health` *slash command* (repo health: branches, remotes, sync, worktrees, PRs) to **`/overview`**. That frees `health` for the new CLI install-health command.
   - `/overview` (slash command) → repository health.
   - `dev-workspace health` / `dev-deploy health` (CLI) → plugin install health.
2. **dev-deploy** — mirror the pluggable `hooks/health/` runner into dev-deploy too (not just dev-workspace). Reconcile with dev-deploy's existing Kamal-container `health` command (see open question below).
3. **Scope (first pass)** — ship two checks (`10-plugin-scope`, `20-stub-location`) + the `references/health.md` contract. Defer `--fix`, project-local `health.d/`, and auto-run.
4. **Severity protocol** — exit `0` pass / `1` advisory / `2` blocker; runner overall exit is non-zero iff any check returns `2`.
5. **Scope-check matching** — match enabled plugins by `<plugin-name>@` prefix in `~/.claude/settings.json`, never a hardcoded marketplace name.

## Task checklist

- [ ] **Rename slash command** `commands/health.md` → `commands/overview.md` (update `name:`/`description:` frontmatter; update skill listing + any references). Confirm `/overview` loads.
- [ ] **Contract doc** — write `skills/dev-workspace/references/health.md`: check-script contract (env in: `PLUGIN_ROOT`, `PLUGIN_NAME`, `PROJECT_ROOT`, `CONFIG`; status lines `✓/⚠/❌`; exit-code severity) + how to add a check.
- [ ] **Runner** — implement `cmd_health` in `skills/dev-workspace/scripts/dev-workspace`: discover `$PLUGIN_ROOT/hooks/health/*` (sorted), run each, aggregate output, set exit code per severity. Add dispatch `case` + `help` entry.
- [ ] **Checks (dev-workspace)** — author `hooks/health/10-plugin-scope` (user vs project scope advice) and `hooks/health/20-stub-location` (`~/.local/bin/<plugin>` resolves to installed plugin script).
- [ ] **dev-deploy mirror** — replicate runner + `references/health.md` + `hooks/health/` checks in dev-deploy; reconcile with existing Kamal `health`.
- [ ] **Docs** — update `dev-workspace_commands.md` (repo + template) with `health`, and reflect the `/health`→`/overview` rename wherever referenced.
- [ ] **Test** — run in dw-project (project scope), dw-project (user scope), and non-dw dir; verify statuses, exit codes, pluggable discovery (drop a throwaway check). Confirm `/overview` works.

## Open question to resolve before touching dev-deploy

dev-deploy's existing `health` runs **Kamal container health**. Pick one:
- (a) Bare `dev-deploy health` becomes the install-health runner; Kamal health moves to a subcommand/flag.
- (b) Install-health gets a separate command name on dev-deploy.
- (c) The Kamal check becomes one of the pluggable `hooks/health/` scripts.

(Other deferred questions — structured stdout tokens, project-local `health.d/`, auto-run hook, `--fix` — captured in the plan.)
