# WORKSPACE.md

Branch workspace context for Claude and humans. Not read by the dev-workspace script.

*Load into Claude's context with: `@dev/workspace/WORKSPACE.md`*

## Branch

**Name:** fix/conversation-capture-config
**Started:** 2026-06-18
**Status:**

- [x] In Progress
- [ ] Discard (workspace and branch abandoned)
- [ ] Complete (ready to merge)

## Purpose

Complete the conversion of the `conversation-capture` skill into a dev-workspace-native skill. Move its configuration out of the bundled (update-volatile) `config.yml` and into the per-workspace `dev/workspace/workspace-config.yml` under a `conversation_capture:` section. Add a graceful non-workspace guard, a `bin/fix-conversation-capture` migration helper for existing workspaces, and wire the currently-dead `include_subagents` toggle.

## Workflow

- [x] Quick (direct implementation)
- [ ] Single plan (plan once, execute)
- [ ] Multi-stage plan (iterative planning)

## Track Issues

- [x] Track GitHub issues
    - #10

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
