---
name: Repo Health
description: Health check of the repository — branches, remotes, sync status, and workspace state.
allowed-tools: Bash(git *), Bash(gh *), Read, Grep, Write
---

# Preloaded Context

!`git fetch --all --quiet 2>/dev/null; echo "fetch done"`
!`git branch --show-current`
!`git status --short`
!`git remote -v`
!`git branch -a --format='%(refname:short) %(upstream:short) %(upstream:track)' | grep -v '^\s*$'`
!`git worktree list`
!`git log --format='%cr' -1 FETCH_HEAD 2>/dev/null || echo "never fetched"`
!`git rev-list --left-right --count origin/main...main 2>/dev/null || echo "no origin/main"`
!`git log --all --no-walk --format='%D %cr' --decorate=short 2>/dev/null | head -30`

# Instructions

You are performing a repository health check. Use the preloaded data above and run additional git/gh commands as needed to build a complete picture.

## Sections to Report

Work through these in order. **Skip any section that does not apply** (e.g. skip Command if no `command` branch exists, skip Deploy if no `deploy` remote exists).

### 1. Working Tree
- Current branch name
- Clean or dirty (list changed files if dirty)

### 2. Main
- Ahead/behind `origin/main`
- Last fetch time (from FETCH_HEAD stat)

### 3. Command (conditional — only if local `command` branch exists)
- Behind main: `git rev-list command..main --count`
- Ahead/behind its remote tracking branch
- Deploy freshness: if a `deploy` remote exists, compare `command` against `deploy/command-mirror` using `git rev-list deploy/command-mirror..command --count` to show commits since last deploy-push

### 4. Worktrees (conditional — only if more than 1 worktree exists)
- List each worktree path, branch, and whether the working tree is clean
- Flag any worktree in a conflicted or detached state

### 5. Branches
List all local branches **excluding**: main, command, deploy-push.

For each branch, gather and display:
- **Last commit age**: `git log -1 --format='%cr' <branch>`
- **Remote tracking**: does it have an upstream? (from preloaded branch data)
- **PR status**: `gh pr list --head <branch> --json number,state,title --jq '.[0]' 2>/dev/null`
- **Pruning candidate**: flag if the branch has a remote but no recent commits (30+ days idle)

### 6. Attention Items
At the end, highlight anything that needs action:
- Unpushed commits on any branch
- Branches with no remote (forgotten pushes)
- Stale branches (30+ days idle)
- Main behind origin (needs pull)
- Command behind main (needs sync)
- Dirty working tree
- Worktree issues

## Output Format

Print results directly to chat using this format:

```
── Repo Health ──

Working Tree
→ on: <branch>
→ status: clean | dirty (N files)

Main
→ origin/main: in sync | N ahead, N behind
→ last fetch: <time>

Command
→ behind main: N commits
→ fork/command: in sync | N ahead, N behind
→ deploy: N commits since last push

Worktrees
→ /path/to/worktree [branch] clean | dirty

Branches (N)
→ feature/foo       3 days idle  · fork/feature/foo  · PR #12 open
→ fix/bar           45 days idle · no remote          · pruning candidate
→ refactor/baz      1 day idle   · fork/refactor/baz  · PR #8 merged

⚠ Attention
→ main is 2 commits behind origin — needs pull
→ fix/bar has no remote tracking branch
```

## Rules

- Do NOT use markdown tables — use the arrow list format shown above
- Do NOT write to any file unless the user asks for a filebox report
- If the user asks for a report, write it to `dev/workspace/filebox/health-report.md`
- Keep chat output concise — one line per item, no paragraphs
- Use the `→` prefix for list items to match the bizzy health script style
