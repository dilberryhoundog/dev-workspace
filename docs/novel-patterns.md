# Novel Patterns

Dev-workspace was built for codebase feature branches. These patterns extend it to other use cases.

## Scope Branches (this Agents repo)

Instead of short-lived feature branches, this repo uses dev-workspace branches as long-lived parallel contexts — one per major working area (hetzner-server, skills, dev-workspace, openclaw, conversations).

### How it works
- Each scope has a top-level directory for shared work artifacts and a long-lived branch for isolated workspace context
- Switch branch to switch context. The workspace has full history for that scope
- Work done on any branch gets pushed to main and synced to other branches normally
- The workspace context (plans, conversations, discoveries) stays on the branch permanently

### Key differences from standard use
- Branches are never deleted — they're persistent contexts, not feature branches
- The archive-before-merge check is a false positive (no branch deletion means no context loss)
- Use `merge --local` since there are no PRs for scope merges
- `workspace.yml` describes the scope's ongoing purpose rather than a specific feature

### Why it works
Dev-workspace's merge protection is the enabler. When syncing the hetzner-server branch with main, the hetzner workspace context is protected while skills code flows in. The isolation mechanism designed for feature branches works identically for scope branches.

## General-Purpose Workspace

This pattern makes dev-workspace useful beyond codebases — any situation where parallel contexts need isolation with shared artifacts:
- Managing multiple servers or services
- Working across multiple projects simultaneously
- Separating research threads
- Maintaining topic-specific conversation histories

The only requirement: the context separation must align with git branches.
