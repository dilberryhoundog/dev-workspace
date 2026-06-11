# Commit — Workspace-Only Commits

## Workflow

```
dev-workspace commit --check             # Preview what would be committed
dev-workspace commit                     # Commit workspace files only
```

## What It Does

1. **Unstages everything** (`git reset HEAD -- .`) — this prevents accidentally committing code changes
2. **Stages only configured directories** — reads `commit_workspace.directories` from config
3. **Commits with configured message** — reads `commit_workspace.message` from config

Default directories staged:

- `dev/workspace`
- `.claude/config/`
- `.gitattributes`

Default message: `📝 Workspace files updated!`

Both are configurable in `workspace-config.yml`.

## When to Use

- After updating workspace context, plans, tasks, or discoveries
- Before switching branches (checkpoint workspace state)
- Periodically during long sessions
- Before running `dev-workspace archive` (archive mirrors the committed workspace)

## Important: Unstage Behaviour

The unstage-everything-first pattern is deliberate. It means:

- If you have staged code changes, they will be unstaged
- Workspace commit is isolated — only workspace files go in
- Stage and commit code separately with normal git, then use `dev-workspace commit` for workspace files

This prevents the common mistake of accidentally including code changes in a workspace commit (or vice versa).

## No Changes

If there are no workspace changes to commit, the command reports "No workspace changes to commit" and exits cleanly. This is not an error.
