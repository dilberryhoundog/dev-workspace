# Push Operations

Push local commits to a remote repository.

## push

Push commits to the remote repository.

### Workflow

1. **Check current status**
   ```bash
   # Check current branch
   git branch --show-current
   
   # Check remote status
   git status
   
   # View unpushed commits
   git log origin/<branch>..HEAD --oneline
   ```

2. **Verify remote configuration**
   ```bash
   # Check remote
   git remote -v
   
   # Check upstream branch
   git branch -vv
   ```

3. **Determine push strategy**
    - First push to new branch?
    - Regular push to existing branch?
    - Force push needed? (ask user first)

4. **Execute push**

### Push Scenarios

#### Regular Push

```bash
# Push to tracked upstream branch
git push

# Push specific branch
git push origin <branch-name>
```

#### First Push (New Branch)

```bash
# Push and set upstream
git push -u origin <branch-name>

# Or
git push --set-upstream origin <branch-name>
```

#### Push with Verification

```bash
# Dry run first to see what would be pushed
git push --dry-run

# Then actual push
git push
```

### Pre-Push Checks

Before pushing, verify:

1. **Correct branch**
    - Confirm user wants to push current branch
    - Show branch name clearly

2. **Unpushed commits**
    - Show what commits will be pushed
    - Confirm commit messages look correct

3. **Remote state**
    - Check if remote has new commits
    - Offer to pull if behind remote

### Error Handling

**If push rejected (remote has new commits):**
```bash
# Pull with rebase
git pull --rebase

# Then push
git push
```

**If upstream not set:**
```bash
# Set upstream and push
git push -u origin <branch-name>
```

**If remote branch doesn't exist:**
- Inform user a new remote branch will be created
- Use `-u` flag to set upstream tracking

### Important Notes

- Always show what will be pushed before pushing
- This is not the place for force pushes.
- Check for uncommitted changes that won't be pushed
- Inform user if pushing to non-standard remote (not origin)
- If working on shared branch, warn about potential conflicts
