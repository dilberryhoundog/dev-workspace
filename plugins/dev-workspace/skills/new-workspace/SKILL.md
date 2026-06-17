---
name: new-workspace
description: This skill should be used when the user wants to create a new workspace branch for isolated work. It scaffolds a git branch with the correct naming convention (feature/, fix/, docs/, chore/, refactor/, workflow/), runs preflight checks on repo state, creates the branch, and initialises the dev/workspace/CLAUDE.md with branch metadata. Triggers on requests like "start a new workspace", "create a branch for X", or "new feature branch".
allowed-tools: Bash(.claude/skills/new-workspace/scripts/*), Bash(git status), Bash(git switch:*), Bash(git add:*), Bash(git commit:*), Write, Read, Edit, AskUserQuestion
---

# New Workspace

Create a new git branch with a workspace environment for isolated work.

## Workflow

### Step 1: Validate Purpose

Parse the conversation for the user's intended purpose. If no clear purpose can be determined, ask: "What are you working on?"

Use the description to determine branch type and name.

### Step 2: Determine Branch Name

Analyse the description and select a prefix:

- `feature/` - New features, enhancements (default)
- `fix/` - Bug fixes, patches
- `docs/` - Documentation changes
- `chore/` - Maintenance, tooling, dependencies
- `refactor/` - Code restructuring
- `workflow/` - CI/CD, process improvements

Format: `{type}/{sanitized-description}`

Sanitisation rules:

- Lowercase
- Spaces to hyphens
- Remove special characters except hyphens
- Maximum ~40 characters

### Step 3: Run Preflight

Execute the preflight script to gather repo state:

```bash
.claude/skills/new-workspace/scripts/preflight {branch-name}
```

The script outputs JSON with these fields:

- `current_branch` - Which branch is checked out
- `parent_valid` - Whether on `main` or `command` (valid parent branches)
- `remote` / `remote_status` - Remote tracking state (`ok`, `no_upstream`, `unexpected_remote`)
- `working_tree_clean` - Whether there are uncommitted changes
- `fetch_ok` / `ahead` / `behind` - Sync status with remote
- `local_branches` - Array of all local branch names, for checking exact matches and similar existing branches

### Step 4: Evaluate Preflight Results

Handle each condition in order:

**Working tree not clean:** Stop immediately. Inform the user to commit or stash changes before proceeding.

**Branch already exists:** Check `local_branches` for an exact match. Ask the user whether to switch to the existing branch. If yes, run `git switch {branch-name}` and skip to Step 5. If no, ask for a different branch name and re-run preflight.

**Similar branch found:** Check `local_branches` for branches with similar names or purpose. If any look related, ask the user whether they meant an existing branch before creating a new one.

**Not on a valid parent branch:** Inform the user they need to be on `main` or `command`. Ask whether to switch first.

**Remote warnings** (`no_upstream` or `unexpected_remote`): Inform the user of the discrepancy and ask whether to proceed. These are soft warnings, not blockers.

**Behind remote:** Inform the user that local is behind by N commits. Recommend pulling first but allow proceeding if they choose to.

**All clear:** Proceed to branch creation.

### Step 5: Create Branch

Execute the create-branch script:

```bash
.claude/skills/new-workspace/scripts/create-branch {branch-name} {current_branch}
```

Where `{current_branch}` is the parent branch from preflight results.

### Step 6: Update Workspace CLAUDE.md

Edit `dev/workspace/CLAUDE.md` with the following changes only:

1. Replace `**/**` with the actual branch name
2. Replace `yyyy-mm-dd` with the current date
3. Replace the `## Purpose` section content with an expanded description of what the user is working on
4. Replace `# Workspace` with `# [Type] Title Case Description`

Preserve all checkboxes, configuration options, and other content.

### Step 7: Pause for Configuration

Present a summary and wait for user confirmation:

```
Branch: {branch-name}
Workspace: dev/workspace/CLAUDE.md

Pausing for you to review or make changes. Ready to commit?
```

### Step 8: Commit Workspace

After user confirms:

```bash
git add dev/workspace/
git commit -m "Initialize workspace"
```

## Safety

- Stop on uncommitted changes — never create a branch with a dirty working tree
- Confirm before switching branches
- Always create branches with `--no-track` (handled by create-branch script)
- Confirm before committing
