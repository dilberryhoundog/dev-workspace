---
name: workspace-PR
description: Create a Pull Request for the current workspace branch
allowed-tools: Bash(git status), Bash(git log:*), Bash(git diff:*), Bash(git branch:*), Bash(gh pr:*), Read, Grep
argument-hint: <optional PR focus or notes>
---

Create a Pull Request for merging the current workspace branch.

## Description

$ARGUMENTS

## Pre-loaded Context

!`git branch --show-current`
!`git status --short`
!`gh pr view --json number,state,title 2>/dev/null || echo "No PR exists"`

## Workflow

### Step 1: Validate Branch

Check current branch is not main, master, or command.

If on protected branch:
STOP
Output: "❌ Cannot create PR from main/master/command branch"
Exit

Check if PR already exists:
`gh pr view --json number,url 2>/dev/null`

If PR exists:
Output: "ℹ️ PR already exists: {url}"
Ask: "Update the PR description, or exit?"
If exit: End workflow

### Step 2: Gather Commit Context

Get parent branch and remote from WORKSPACE.md front matter:

```
PARENT_BRANCH=$(sed -n '/^---$/,/^---$/p' dev/workspace/WORKSPACE.md | grep "^parent_branch:" | cut -d: -f2 | tr -d ' ')
REMOTE=$(sed -n '/^---$/,/^---$/p' dev/workspace/WORKSPACE.md | grep "^remote:" | cut -d: -f2 | tr -d ' ')
```

- `parent_branch` defaults to `main` if not set
- `remote` can be `fork` or `upstream` (defaults to `upstream` if not set)

Get commits since diverging from parent:
`git log {parent}..HEAD --oneline`

Get summary of changes:
`git diff {parent}..HEAD --stat`

Note the scope:

- Number of commits
- Files changed
- General areas affected (e.g., "config changes", "new feature", "bug fixes")

### Step 3: Gather Workspace Context

Read `dev/workspace/CLAUDE.md`:

- Extract the **Purpose** section
- Note the branch name and start date

Read `dev/workspace/WORKSPACE.md`:

- Check for linked GitHub issues in "Track Issues" section
- Note merge strategy configured

If Purpose is empty or unclear AND $ARGUMENTS is empty:
Search `dev/workspace/history/` for context:
`grep -l "SUMMARY" dev/workspace/history/*.md | head -3`
Read summaries from recent history files to understand work done.

### Step 4: Synthesise PR Content

Based on gathered context, create:

**Title**: Concise, descriptive (50 chars max)

- Use conventional format if appropriate: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`
- Derive from Purpose or commit messages

**Body**: Dynamic based on what's relevant:

```markdown
## Summary

[1-3 sentences from Purpose or synthesised from commits]

## Changes

[Bullet list of key changes - grouped logically]

## Notes

[Optional: anything noteworthy - breaking changes, dependencies, follow-ups]
```

Adapt the template:

- Skip "Notes" section if nothing noteworthy
- Add "Closes #123" if issues are tracked in WORKSPACE.md
- Keep it concise - prefer brevity over completeness

### Step 5: Determine Target Repository

Get the user's GitHub username:
`gh api user --jq '.login'`

Determine target repo based on `remote` setting:

- If `remote: fork` → target is `{username}/{repo-name}`
- If `remote: upstream` or not set → target is the upstream repo

Get current repo name:
`basename $(git remote get-url origin) .git`

### Step 6: Confirm with User

Present the draft with EXPLICIT target information:

```
📝 PR Draft

Target: {target-repo} ({parent_branch} ← {current-branch})
Title: {title}

Body:
{body}

Create this PR?
```

⚠️ **CRITICAL**: Always show the full target repo path. User MUST confirm before creation.

Wait for user confirmation or edits.

### Step 7: Create PR

Build the gh pr create command based on remote setting:

If `remote: fork`:
`gh pr create --repo {username}/{repo-name} --base {parent_branch} --title "{title}" --body "{body}"`

If `remote: upstream` or not set:
`gh pr create --base {parent_branch} --title "{title}" --body "{body}"`

If draft requested, add `--draft` flag.

Output PR URL.

### Step 8: Summary

Output:

```
✓ PR created: {url}
  Target: {target-repo}

Next steps:
- Review: gh pr view --web
- Preflight: dev/run/merge-preflight
- Merge: dev/run/merge-branch
```

## Safety

- ✓ Non-destructive (only creates PR, no commits or merges)
- ✓ Confirms before creating with EXPLICIT target repo shown
- ✓ Respects `remote: fork` setting to target user's fork
- ✓ Reuses existing PR if one exists
- ✓ Reads workspace context for accurate PR content

⚠️ **IMPORTANT**: Never create a PR without explicitly showing the target repository to the user first. The `remote:` setting in WORKSPACE.md front matter MUST be respected.
