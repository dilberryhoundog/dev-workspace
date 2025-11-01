# Pull Operations

Fetch and integrate changes from remote repository.

## pull

Pull changes from the remote repository and integrate them into the current branch.

### Workflow

1. **Check current status**
   ```bash
   # Check current branch
   git branch --show-current
   
   # Check for uncommitted changes
   git status
   
   # View remote status
   git fetch --dry-run
   ```

2. **Handle uncommitted changes**
    - If uncommitted changes exist, offer options:
        - Commit them first
        - Stash them: `git stash`
        - Abort the pull
        - Pull anyway (may cause conflicts)

3. **Check what will be pulled**
   ```bash
   # Fetch latest info from remote
   git fetch
   
   # Show incoming changes
   git log HEAD..origin/<branch> --oneline
   
   # Show diff of incoming changes
   git diff HEAD..origin/<branch>
   ```

4. **Execute pull**

### Pull Strategies

#### Regular Pull (Merge)

```bash
# Pull and merge
git pull

# Pull specific branch
git pull origin <branch-name>
```

#### Pull with Rebase

Keeps history cleaner by applying your commits on top of remote changes.

```bash
# Pull and rebase
git pull --rebase

# Pull and rebase from specific branch
git pull --rebase origin <branch-name>
```

#### Pull with Fast-Forward Only

Only pull if it can fast-forward (no merge needed).

```bash
# Safe pull - fails if merge required
git pull --ff-only
```

### Common Patterns

**Update current branch:**
```bash
git pull
```

**Update with rebase (cleaner history):**
```bash
git pull --rebase
```

**Update main/master branch:**
```bash
# Switch to main
git checkout main

# Pull latest
git pull
```

**Fetch first, then pull:**
```bash
# See what's coming
git fetch
git log HEAD..origin/main --oneline

# Then pull
git pull
```

### Pre-Pull Checks

Before pulling, verify:

1. **Uncommitted changes**
    - Warn if working directory has changes
    - Suggest commit or stash

2. **Current branch**
    - Confirm user wants to pull into current branch
    - Show branch name clearly

3. **Remote tracking**
    - Verify upstream branch is set
    - Show which remote branch will be pulled from

4. **Diverged history**
    - Check if local and remote have diverged
    - Recommend rebase vs merge strategy

### Handling Conflicts

**If pull creates merge conflicts:**

1. **Show conflict status**
   ```bash
   git status
   ```

2. **List conflicted files**
   ```bash
   git diff --name-only --diff-filter=U
   ```

3. **Inform user about resolution process**
    - Need to manually resolve conflicts in each file
    - Look for conflict markers: `<<<<<<<`, `=======`, `>>>>>>>`
    - After resolving, stage files: `git add <file>`
    - Complete merge: `git commit`

4. **Offer abort option**
   ```bash
   # Abort the merge/pull
   git merge --abort
   
   # Or if rebasing
   git rebase --abort
   ```

### Stashing Changes

**If user wants to stash before pulling:**

```bash
# Stash changes
git stash

# Pull
git pull

# Reapply stashed changes
git stash pop
```

### Pull with Autostash

```bash
# Automatically stash, pull, then unstash
git pull --rebase --autostash
```

### Error Handling

**If upstream not set:**
```bash
# Set upstream and pull
git branch --set-upstream-to=origin/<branch> <branch>
git pull
```

**If diverged with conflicts:**
- Show user both local and remote commits
- Recommend strategy:
    - `git pull --rebase` for cleaner history
    - `git pull` for merge commit
    - Manual resolution for complex conflicts

**If network/authentication issues:**
- Check remote URL: `git remote -v`
- Verify access credentials
- Suggest checking network connection

### Advanced Options

**Pull all branches:**
```bash
# Fetch all
git fetch --all

# Pull current branch
git pull
```

**Pull specific remote:**
```bash
git pull upstream main
```

**Pull and prune deleted remote branches:**
```bash
git pull --prune
```

### Best Practices

- **Check status first**: Always run `git status` before pulling
- **Commit or stash**: Clean working directory before pulling
- **Fetch first**: Use `git fetch` to see what's coming before pulling
- **Prefer rebase**: Use `--rebase` for cleaner history on feature branches
- **Regular pulls**: Pull frequently to minimize conflicts
- **Communicate**: If working on shared branch, coordinate with team

### Important Notes

- Pull = Fetch + Merge (or Rebase)
- Always show what will be pulled before executing
- Warn if uncommitted changes might conflict
- Explain difference between merge and rebase strategies
- Offer to abort if conflicts seem complex
- Inform user about fast-forward vs merge commits
