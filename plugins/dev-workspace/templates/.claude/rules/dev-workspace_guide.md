# Dev-Workspace Guidance

This project uses **dev-workspace**, an integrated toolset for AI agents to operate efficiently and consistently inside this project directory.

# IMPORTANT!!!

**TRUST THE DEV-WORKSPACE SKILL AND COMMANDS.** Use dev-workspace commands to manage your workspace.

## Concept

dev-workspace creates isolated workspaces to keep work and context (plans, docs, etc) scoped to the task at hand. Work can then be shared back to the central project safely and effectively. Many separate workspaces can be active at any time across concurrent sessions (multi-dev compatible) by using intelligent branch setup.
Centralised snapshots (archives) of all workspaces, accessible project wide, allow high level insights. A CLI speeds up and makes all the actions needed to operate the dev-workspace system a pleasure to use.

## State
dev-workspace keeps work and context syncronised, isolated, searchable across the whole project repository. It is important to keep the state of the workspace updated and fresh.
Ask for the user's guidance when these milestones are reached: 

**Starting new feature / fix** --> Create a new workspace, push to remote to initiate branch, setup any workspace configs and context (in workspace.md)
**Starting new work** --> Sync the workspace with parent branch. Check that previous work is recorded and saved. 
**Work finished** --> Merge changes back to parent, Archive if needed, commit workspace files. push work to remote.
**major features completed** --> Work finished protocol, deploy push if needed. 

## Tools

### Workspace Commands

**CLI command suite** enabling great productivity and consistency when dev-workspace is active in a project, this is true for both humans and agents. These commands consolidate and link together common (git, gh, file and tree) commands in a way that is not possible normally. Workspaces rely heavily on the CLI for the system to work effectively.

**Core Commands**

- init: Scaffold and apply workspace configs
- new: Create or list workspace branches
- push: Push current branch to remote server
- sync: Sync changes from parent branch
- merge: Merge current branch back to parent
- commit: Automatically commit workspace files only
- archive: Archive workspace context
- latest: Integrate changes from upstream/origin to main
- transfer-latest: Transfer latest changes to parent branch (fork repos only)
- rebuild: Pull dev-workspace updates
- deploy: Deploy push workflow
- cleanup: Process conversation exports and other tasks
- tree: Generate directory trees for context
- help: Show help info

### Preloaded Context

You have been seeded with context generated from **dev-workspace**.

- **Tree** -> project overview: The default project tree view that gives you visibility over the core areas of the project. Some projects come with named tree views, for specific overviews, find these with `dev-workspace tree --show`
- **workspace/workspace.md**: The requirements and key info to kick off and complete tasks in this workspace. Shows any active issues, testing requirements, planning strategy, workspace purpose, etc.

### Skills

- **dev-workspace** — Core CLI for efficient and consistent workspace management.
- **dev-deploy** — Kamal deployment pipelines (staging/production)
- **magic-reply** — Trigger-based response styles

### Workspace Directories

Workspaces are Claude's primary source of truth. Prioritise searching and revealing workspace knowledge before focusing directly on the codebase.

- **`/context`** — Discoveries, resources, and other contextual information
- **`/filebox`** — Temporary file location, store snippets
- **`/history`** — Conversations with Claude, invaluable for searches
- **`/plans`** — Structured planning documents
- **`/research`** — Research artefacts
- **`/reviews`** — Reviews of completed work
- **`/tasks`** — Tasks to complete, may contain instructions for Claude

### Archives

Archived workspaces live in `dev/branches/`. These are snapshots of completed branch context, visible from any branch. Check archives for prior context before starting work in a scope.

### Chat Histories

Each workspace has all previous conversations with claude recorded in the `/history` directory.
Conversations from other workspaces can be found in the `dev/branches/` directory, in the workspace snapshot

Each history file has a max 5-line summary near the top and a descriptive filename. This enables agents to easily search chat histories by date or topic:

    [SUMMARY]
    >>>
    "The summary of the conversation is here"
    <<<

## Abbreviations & Chat references

The user may use the following abbreviations or terms to refer to the dev-workspace system:
- `dw` --> simple abreviation of "dev-workspace"
- `the workspace`, `our workspace` --> dev-workspace is active. It refers to the "state" of the files and folders in the dev-workspace directory.  
**examples**:
- User sais: "lets get our workspace in order" --> run commands to bring the workspace in its proper state as per the config file. eg local branches pushed, archives updated (if config), workspace synced. work merged back to parent branch). 
- User sais: "dw needs syncing" --> run dev-workspace command that syncs the workspace.
