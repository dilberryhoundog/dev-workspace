---
name: new-workspace
description: Create new branch with workspace folder and CLAUDE.md
allowed-tools: Bash(git status), Bash(git branch:*), Bash(git checkout:*), Bash(git fetch:*), Bash(git add:*), Bash(git commit:*), Write, Read, Edit
argument-hint: <branch purpose>
---

Create a new branch with a workspace environment for isolated work.

## Description

$ARGUMENTS

## Pre-loaded Context

!`git status`

!`git branch`

check `dev/run/new-workspace` exists

## Workflow

### Step 1: Validate Arguments

If no description, prompt: "What are you working on?"

### Step 2: Determine Branch Type

Analyze description and select prefix:

- `feature/` - New features, enhancements (default)
- `fix/` - Bug fixes, patches
- `docs/` - Documentation changes
- `chore/` - Maintenance, tooling, dependencies
- `refactor/` - Code restructuring
- `workflow/` - CI/CD, process improvements

### Step 3: Create Branch Name

Format: `{type}/{sanitized-description}`

Sanitization:

- Lowercase
- Spaces → hyphens
- Remove special chars except hyphens
- Max ~40 chars

### Step 4: Detect Path

Check current branch and script availability:

**Path 1 - Script available + on parent branch:**
If `dev/run/new-workspace` exists AND on `main` or `command` branch, go to Step 5a.

**Path 2 - Already on similar feature branch:**
If current branch name closely matches the intended purpose (e.g., user wants "add login feature" and already on `feature/add-login`), go to Step 5b.

**Path 3 - Fallback:**
Otherwise, go to Step 5c.

### Step 5a: User Runs Script

Provide the command for user to run:

```
✓ Branch name: {branch-name}

Please run:
  dev/run/new-branch {branch-name}

Let me know when complete.
```

Wait for user confirmation, then proceed to Step 6.

### Step 5b: Existing Branch

Ask user:

```
You're already on '{current-branch}' which matches your description.

Is this the branch you want to work from?
```

If yes, proceed to Step 6.
If no, ask if they want Path 1 (run script) or Path 3 (Claude creates branch).

### Step 5c: Claude Creates Branch

Ask user:

```
Script not available or not on parent branch.

Would you like me to create the branch with git commands?
```

If yes:

**Uncommitted changes:** Stop. "Commit or stash before creating new branch."

**IF** on `main` branch:

```bash
git checkout -b {branch-name} --no-track main
```

**IF** on `command` branch:

```bash
git checkout -b {branch-name} --no-track command
```

**IF** on other branch, confirm switch to `main` or `command` first.

Proceed to Step 6 after branch created.

### Step 6: Update CLAUDE.md

Edit `dev/workspace/CLAUDE.md`:

1. Edit only these placeholders:
    - `**/**` → actual branch name
    - `yyyy-mm-dd` → current date
    - `## Purpose` → expanded user description
    - `# Workspace` → `# [Type] Title Case Description`
2. Preserve all checkboxes and configuration

### Step 7: Pause for Configuration

```
✓ Branch: {branch-name}
✓ Workspace: dev/workspace/CLAUDE.md

Paused for you to make changes. Can I commit the workspace now?
```

Wait for user confirmation, then proceed to Step 8.

### Step 8: Commit Workspace

```bash
git add dev/workspace/
git commit -m "Initialize workspace"
```

## Safety

- ⚠️ Stop on uncommitted changes
- ⚠️ Confirm before switching branches
- ✓ Prefer user-run script for check gates
- ✓ Always create with --no-track
- ✓ Confirm before committing
