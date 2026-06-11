# New Workspace — Creating Branches

## Workflow

```
dev-workspace new                        # List existing branches (check names first)
dev-workspace new <name> --check         # Verify parent branch readiness
dev-workspace new <name>                 # Create the branch
```

## Pre-Creation Checks

Before creating a branch, the agent MUST verify:

1. **On parent branch** — must be on the branch configured as `parent_branch` in config. If not, switch to it first.
2. **Working tree clean** — no uncommitted changes. Commit or stash first.
3. **In sync with origin** — local parent should not be behind origin. If behind, run `dev-workspace latest --origin` (or `--upstream` for forks) first.

`new --check` verifies all three. If any fail, it reports the issue and exits non-zero.

## Listing Branches

`dev-workspace new` with no name lists all branches that originate from the parent branch. Use this to:
- Check if a branch name already exists before creating
- See what work is in progress

## Creating

`dev-workspace new <name>` creates the branch with `git checkout -b <name> --no-track <parent>`.

The `--no-track` is intentional — it prevents the new branch from tracking the parent, so `git push` won't accidentally push to the parent branch.

## Branch Naming

Use descriptive type/name prefixes:
- `feature/add-user-auth`
- `fix/login-redirect`
- `refactor/extract-service`
- `docs/api-reference`

## What Transfers to New Branches

New branches inherit the parent's workspace state. This is by design — custom context in the parent's `dev/workspace/` transfers to every new branch. Common shared context (style guides, architectural notes) lives on the parent and propagates automatically.

## Post-Creation

1. Update `dev/workspace/WORKSPACE.md` — set branch name, start date, purpose
2. Start working, commit code normally with git
3. Use `dev-workspace commit` for workspace-only commits
4. Use `dev-workspace push` when ready to share

## Force Creation

`dev-workspace new <name> --force` skips the sync check. Use when you intentionally want to branch from local state even though origin has newer commits. The agent should confirm with the user before using `--force`.
