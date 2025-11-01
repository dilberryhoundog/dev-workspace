# Commit Operations

Two commit commands with different workflows:

## Choosing Criteria:
1. If the User speaks in singular terms or explicitly ( eg "commit my staged changes" "can we commit this {change/component/fix}"), then choose commit-staged. 
2. If the user speaks in broad terms or is referring to a large body of work (eg "let's commit all my work", "we need to commit this feature"), then choose commit-atomic.
3. If the choice seems ambiguous or unclear, then present the commit options to the user in a numbered list. proceed with their choice.

## commit-staged

Create a single commit with all currently staged files.

### Workflow

1. Check if files are staged: `git diff --cached --name-only`
2. If no staged files, inform the user and exit
3. If user provided commit context, use that to guide the commit message.
4. Review staged diff: `git diff --cached`
5. Craft the conventional commit message with emoji
6. Create the commit: `git commit -m "<emoji> <type>: <description>"`

### Example Usage

```bash
# Check staged files
git diff --cached --name-only

# Review changes
git diff --cached

# Commit
git commit -m "✨ feat: add user authentication system"
```

## commit-atomic

Intelligent multi-commit workflow that analyzes all changes and proposes atomic commits.

### Workflow

1. **Check repository status**
   ```bash
   git status
   ```

2. **Identify changes to commit**
    - Staged files
    - Unstaged modified files
    - Untracked files

3. **Review all diffs**
   ```bash
   # Staged changes
   git diff --cached
   
   # Unstaged changes
   git diff
   
   # Show untracked files
   git ls-files --others --exclude-standard
   ```

4. **Analyze and propose commits**
    - Group changes by concern (features, fixes, docs, config, etc.)
    - Consider atomic commit principles
    - Propose 1-4 logical commits
    - **Show the user:**
        - What files will be in each commit
        - The proposed commit message for each
        - Rationale for the grouping

5. **Prompt user for confirmation**
    - Present the proposed commits clearly
    - Ask: "Shall I proceed with these commits?"
    - Wait for user approval

6. **Execute commits sequentially**
    - For each approved commit:
      ```bash
      # Stage specific files
      git add <file1> <file2> ...
      
      # Create commit
      git commit -m "<emoji> <type>: <description>"
      
      # Show confirmation
      git log -1 --oneline
      ```

### Commit Splitting Guidelines

**When to split commits:**
- Different concerns (unrelated parts of codebase)
- Different types (features vs fixes vs docs)
- Different file patterns (source code vs documentation)
- Different audiences (developer tooling vs user-facing)
- Clear boundaries (backend vs frontend when independent)

**When to keep together:**
- Changes directly support one feature
- Functional dependencies (don't work independently)
- Same review context needed

**Prefer fewer, cohesive commits over many tiny ones.** Aim for 1-4 commits per feature.

## commit-review
the user wants you to review the current changed files and recent commits and make some recommendations.
## commit-amend
A mistake has been made and the user wants to amend a recent commit. 

## Conventional Commit Format

All commits use: `<emoji> <type>: <description>`

### Commit Types and Emojis

**Core Types:**
- ✨ `feat`: New feature
- 🐛 `fix`: Bug fix
- 📝 `docs`: Documentation
- 💄 `style`: Formatting/style
- ♻️ `refactor`: Code refactoring
- ⚡️ `perf`: Performance improvements
- ✅ `test`: Tests
- 🔧 `chore`: Tooling, configuration
- 🚀 `ci`: CI/CD improvements
- 🗑️ `revert`: Reverting changes

**Specialized Emojis:**
- 🚨 `fix`: Fix compiler/linter warnings
- 🔒️ `fix`: Fix security issues
- 🚑️ `fix`: Critical hotfix
- 🩹 `fix`: Simple fix for non-critical issue
- 🥅 `fix`: Catch errors
- 🔥 `fix`: Remove code or files
- ✏️ `fix`: Fix typos
- 💚 `fix`: Fix CI build
- 🎨 `style`: Improve structure/format
- 🚚 `refactor`: Move or rename resources
- 🏗️ `refactor`: Make architectural changes
- ⚰️ `refactor`: Remove dead code
- 🧑‍💻 `chore`: Improve developer experience
- 🔀 `chore`: Merge branches
- 📦️ `chore`: Add/update compiled files or packages
- ➕ `chore`: Add a dependency
- ➖ `chore`: Remove a dependency
- 🙈 `chore`: Add/update .gitignore
- 🎉 `chore`: Begin a project
- 🔖 `chore`: Release/Version tags
- 📌 `chore`: Pin dependencies
- 👷 `ci`: Add or update CI build system
- 🧵 `feat`: Multithreading or concurrency
- 🏷️ `feat`: Add or update types
- 💬 `feat`: Add or update text and literals
- 🌐 `feat`: Internationalization and localization
- 💼 `feat`: Add or update business logic
- 📱 `feat`: Responsive design
- 🚸 `feat`: Improve UX/usability
- 🔐️ `feat`: Improve SEO
- 🦺 `feat`: Add or update validation
- ♿️ `feat`: Improve accessibility
- 📊 `feat`: Add or update logs
- 📈 `feat`: Add or update analytics/tracking
- 🚩 `feat`: Add, update, or remove feature flags
- 💫 `ui`: Add or update animations/transitions
- 💡 `docs`: Add or update comments in source code
- 🗃️ `db`: Perform database related changes
- 🧪 `test`: Add a failing test
- 🤡 `test`: Mock things
- 📸 `test`: Add or update snapshots
- ⚗️ `experiment`: Perform experiments
- 🚧 `wip`: Work in progress

### Message Guidelines

- **Present tense, imperative mood**: "add feature" not "added feature"
- **Concise first line**: Under 72 characters
- **Lowercase after type**: "feat: add feature" not "feat: Add feature"
- **No period at end**: "feat: add feature" not "feat: add feature."

### Examples

```
✨ feat: add user authentication system
🐛 fix: resolve memory leak in rendering process
📝 docs: update API documentation with new endpoints
♻️ refactor: simplify error handling logic in parser
🚨 fix: resolve linter warnings in component files
🧑‍💻 chore: improve developer tooling setup process
💼 feat: implement business logic for transaction validation
🩹 fix: address minor styling inconsistency in header
🚑️ fix: patch critical security vulnerability in auth flow
🎨 style: reorganize component structure for better readability
🔥 fix: remove deprecated legacy code
🦺 feat: add input validation for user registration form
💚 fix: resolve failing CI pipeline tests
📈 feat: implement analytics tracking for user engagement
🔒️ fix: strengthen authentication password requirements
♿️ feat: improve form accessibility for screen readers
```
