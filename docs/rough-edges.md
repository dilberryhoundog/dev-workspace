# Rough Edges

Known issues, limitations, and things that need work.

## Script Assumes Origin Exists
- The script expects an `origin` remote for push/sync operations
- Broke during initial setup of this repo when we tried local-only (no remote)
- Workaround: create a remote repo before running init, even if private

## Archive Warning on Long-Lived Branches
- `merge --check` warns about missing archive when `archive_before_merge: true`
- This is correct for feature branches (archive before deletion) but a false positive for scope branches that are never deleted
- Currently must acknowledge the warning and proceed

## chmod Blocked by Sandbox
- Claude Code sandbox blocks `chmod +x` on skill scripts
- User may need to manually `chmod +x` the script after a plugin install or update
- Affects first-time setup and refreshing the plugin

## Hooks -> Skills Transition
- The system has both a hook-based architecture and a skill-based architecture
- Both coexist but the boundary between them is not clean
- Hook handlers do things that could be skill commands
- Some functionality is duplicated across both systems
- Direction: skill-based is the future, but hooks still provide session lifecycle integration that skills can't fully replace yet

## Workspace Context in Rules Files
- In this Agents repo, `.claude/rules/` files act as always-visible indexes across all branches
- Dev-workspace doesn't have a built-in concept of cross-branch reference files
- The rules approach is a manual layer on top of dev-workspace's isolation model

## No Built-in Cleanup for Old Containers/Images
- Dev-deploy handles deployment but doesn't clean up old Docker images
- Stale images accumulate on the server over time
- Need a separate maintenance solution
