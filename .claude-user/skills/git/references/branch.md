# Branch Operations

Manage git branches: create, switch, list, and delete.

## branch

Create new branches or switch between existing branches.

### Workflow

1. **Understand the request**
    - Creating a new branch?
    - Switching to existing branch?
    - Listing branches?
    - Deleting a branch?

2. **Check current branch and status**
   ```bash
   git branch --show-current
   git status
   ```

3. **Execute the appropriate operation**

#### Create New Branch
~ See branch naming conventions below ~

```bash
# Create and switch to new branch
git switch -c <branch-name>

# Confirm
git branch --show-current
```

#### Switch to Existing Branch

```bash
# Check available branches
git branch -a

# Switch to branch
git switch <branch-name>

# Confirm
git branch --show-current
```

#### List Branches

```bash
# List local branches
git branch

# List all branches (including remote)
git branch -a

# List with last commit info
git branch -v
```

#### Delete Branch
~ follow protected branches rules ~

```bash
# Delete merged branch
git branch -d <branch-name>
```

### Branch Naming Conventions

Suggest conventional branch naming patterns:

- `feature/<description>` - New features
- `fix/<description>` - Bug fixes
- `hotfix/<description>` - Critical fixes
- `refactor/<description>` - Code refactoring
- `docs/<description>` - Documentation changes
- `test/<description>` - Test additions/changes
- `chore/<description>` - Maintenance tasks

### Important Notes

- Always check for uncommitted changes before switching branches
- If uncommitted changes exist, offer to:
    - Commit them first
    - Stash them: `git stash`
    - Abort the branch switch
- Inform user if creating a branch from a non-main branch
- Warn before deleting branches with unmerged changes
