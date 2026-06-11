# Archive — Workspace Context Preservation

## Commands

```
dev-workspace archive                    # Archive current workspace
dev-workspace archive --check            # Status + sync divergences with parent
dev-workspace archive --sync             # Bidirectional sync archives with parent
dev-workspace archive --path             # Output archive path (for scripting)
dev-workspace archive --no-commit        # Archive files but skip git commit
```

## How Archives Work

Each branch gets an archive directory in `dev/branches/` (configurable), named after the branch:

| Branch              | Archive path                      |
|---------------------|-----------------------------------|
| `feature/add-login` | `dev/branches/feature_add-login/` |
| `fix/redirect-bug`  | `dev/branches/fix_redirect-bug/`  |
| `docs-update`       | `dev/branches/docs-update/`       |

Archives are a **mirror** of `dev/workspace/` using `rsync --delete`. This means:

- New files are added
- Changed files are updated
- Deleted files are removed from the archive
- The archive always exactly matches the current workspace state

After mirroring, the archive is committed to git automatically (unless `--no-commit`).

## Why Archives Matter

1. **Context persistence** — When a branch is merged and deleted, its workspace context (plans, discoveries, task lists, conversation history) lives on in the archive.
2. **Cross-branch access** — Other branches can read archived context. Useful for referencing past work or sharing discoveries.
3. **Shared history** — Archives committed to the parent branch are available project-wide.

## Archive Check

`dev-workspace archive --check` reports:

- Whether an archive exists and when it was last updated
- **Sync divergences** with the parent branch:
    - Archives in parent but not in your branch (can be pulled)
    - Archives in your branch but not in parent (can be pushed)

## Bidirectional Sync (--sync)

`dev-workspace archive --sync` synchronises archives between the current branch and the parent branch.

### How it works:

1. **Pull first** — Archives that exist in parent but not in your branch are checked out from parent
2. **Commit pulled archives** — Committed on your branch
3. **Push second** — Archives in your branch but not in parent are checked out onto the parent branch
4. **Commit pushed archives** — Committed on parent branch
5. **Return** — Switches back to your original branch

### Why pull-first matters

Pulling first ensures your branch has everything the parent has before pushing new archives. This prevents divergence and keeps archives consistent.

### Requirements

- **Clean working tree** — The push step temporarily switches branches, so no uncommitted changes allowed
- Must be on a feature branch (not on parent or main)

### When to sync

- Before starting work on a branch (pull archives from parent to access context from other branches)
- After archiving your workspace (push your archive to parent so others can access it)
- Before merging (ensure all archives are on parent before the branch goes away)

## Archive Path

`dev-workspace archive --path` outputs just the path with no other text. Useful for scripting:

```bash
# Check if archive exists
[[ -d $(dev-workspace archive --path) ]] && echo "archived"

# List archive contents
ls $(dev-workspace archive --path)
```
