# WORKSPACE.md

Branch workspace context for Claude and humans. Not read by the dev-workspace script.

*Load into Claude's context with: `@dev/workspace/WORKSPACE.md`*

## Branch

**Name:** fix/dev-workspace-permissions
**Started:** 2026-06-19
**Status:**

- [x] In Progress
- [ ] Discard (workspace and branch abandoned)
- [ ] Complete (ready to merge)

## Purpose

Ship a `permissions` block in the dev-workspace plugin's template `settings.json` (issue #9). Auto-allow the safe/routine commands (base/info, health, tree, cleanup, and full push/archive/commit/new) and the `--check` variants of the rest; route every mutating variant of sync/merge/latest/transfer-latest/deploy/init to `ask`. Removes the constant permission prompts for dev-workspace commands. Patterns rely on precise matching because Claude Code evaluates deny > ask > allow with no specificity override.

## Workflow

- [x] Quick (direct implementation)
- [ ] Single plan (plan once, execute)
- [ ] Multi-stage plan (iterative planning)

## Track Issues

- [x] Track GitHub issues
    - #9

## Testing

- [ ] Requires testing
  > Update relevant tests as per testing strategy. All tests must pass before PR.

## Plans

If selected please read the file at the start of the session before starting work

- [ ] `dev/workspace/plans/prd.md`
- [ ] `dev/workspace/plans/architecture.md`
- [ ] `dev/workspace/context/discover.md`

## Discoveries

- %% Claude: record discoveries here as you work %%
