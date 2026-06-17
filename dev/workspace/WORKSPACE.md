# WORKSPACE.md

Branch workspace context for Claude and humans. Not read by the dev-workspace script.

*Load into Claude's context with: `@dev/workspace/WORKSPACE.md`*

## Branch

**Name:** feature/health-command
**Started:** 2026-06-18
**Status:**

- [x] In Progress
- [ ] Discard (workspace and branch abandoned)
- [ ] Complete (ready to merge)

## Purpose

Build an advisory, read-only `health` CLI command for both the dev-workspace and dev-deploy plugins. It runs pluggable check scripts from a `hooks/health/` folder and reports findings (`✓/⚠/❌`). First two checks: plugin install **scope** (project vs user) and **stub location**. The existing `/health` slash command (repo health) is renamed to `/overview` to free the name.

## Workflow

- [ ] Quick (direct implementation)
- [x] Single plan (plan once, execute)
- [ ] Multi-stage plan (iterative planning)

## Track Issues

- [x] Track GitHub issues
    - #8

## Testing

- [x] Requires testing
  > Manual: run `dev-workspace health` / `dev-deploy health` in project-scope, user-scope, and non-dw dirs; verify statuses, exit codes, and pluggable discovery. Confirm `/overview` works after the rename.

## Plans

If selected please read the file at the start of the session before starting work

- [x] `dev/workspace/plans/health-command.md`

## Discoveries

- %% Claude: record discoveries here as you work %%
