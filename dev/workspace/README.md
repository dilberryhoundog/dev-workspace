# Dev Workspace — Reference

The logistical reference for this workspace: setup, commands, directories, hooks and lifecycle. For the project pitch and feature tour, see the repository root `README.md`.

A workspace is a clean, per-branch home for the context a coding session produces — plans, research, reviews, conversations, scratch files and discoveries — stored consistently and synced safely back to the project.

## Setup

### 1. Install the plugin

Inside Claude Code:

```
/plugin marketplace add dilberryhoundog/agent-library
/plugin install dev-workspace@DBHD-Plugins
```

### 2. Initialise the project

From the project root:

```bash
dev-workspace init          # scaffold dev/workspace/workspace-config.yml (never overwrites)
```

### 3. Configure

Edit `dev/workspace/workspace-config.yml`. The key block is `repo_config`:

**Vanilla repo** (your own project):

```yaml
repo_config:
  main_branch: main
  parent_branch: main
  origin: https://github.com/you/your-project.git
  # upstream:           # commented out
```

**Fork repo** (contributing upstream, keeping `main` pristine):

```yaml
repo_config:
  main_branch: main
  parent_branch: command
  upstream_latest_to: main
  origin: https://github.com/you/their-project.git
  upstream: https://github.com/them/their-project.git
```

`workspace_protection.directories` lists the paths isolated per branch (default: `dev/workspace`, `.claude/rules`). These must be identical across all branches — main owns the structure, feature branches inherit it via sync.

### 4. Apply settings

```bash
dev-workspace init --write  # idempotent
dev-workspace init --check  # verify settings are applied
```

`--write` configures the `merge.protect` driver, `.gitattributes` merge strategies, `.git/info/exclude` paths, the `workspace` git remote, `.dockerignore`, and makes `dev/run/` scripts executable.

### Keeping up to date

Two layers update independently:

- **Plugin code** (CLI, skills, hooks) — managed through Claude Code's plugin manager (`/plugin`).
- **Project templates** (the scaffolded `dev/workspace/`, rules, config) — refreshed with `init --update`:

```bash
git checkout <parent_branch>    # init --update only runs on the parent branch
dev-workspace init --update     # rsync new template files in (workspace-config.yml untouched)
dev-workspace commit            # propagate the refreshed scaffold
```

## Command Suite

The `dev-workspace` CLI is the control panel. Prefer it over raw `git`/`gh` for any workspace operation. Every command supports `--check` for a dry run, and `dev-workspace help <command>` for detail.

| Command | Purpose |
|---|---|
| `dev-workspace` | Show the info splash |
| `init` | Scaffold (`init`), apply (`--write`), verify (`--check`), refresh templates (`--update`) |
| `new <name>` | Create a workspace branch (`new` alone lists branches) |
| `push` | Push the current branch to origin (`--force-w-l` after rebase) |
| `sync` | Merge parent into the current branch (`--rebase`, `--continue`, `--full`) |
| `merge` | Merge the branch back to parent (run `--check` first; `--local`/`--github`) |
| `commit` | Commit workspace files only |
| `archive` | Snapshot the workspace to `dev/branches/` (`--sync`, `--no-commit`) |
| `latest` | Integrate upstream/origin into main (`--upstream`, `--origin`) |
| `transfer-latest` | Merge `main_branch` into `parent_branch` (fork repos) |
| `deploy push` | Deploy-push workflow (with `dev-deploy`) |
| `cleanup <platform>` | Process conversation exports (e.g. `claude-code`) |
| `tree` | Generate directory trees (`--show` lists configured trees) |
| `help` | Full command help |

A few agent-facing slash commands complement the CLI: `/new-workspace`, `/discover`, `/research`, `/research-v2`, `/health`, `/workspace-PR`.

## Directory System

```txt
dev/workspace/
├── context/      # discovery output, tree views — Claude's map of the codebase
├── filebox/      # scratch files / dump location
├── history/      # captured conversations, summarised and named
├── plans/        # planning docs (architectural.md, prd.md templates)
├── prompts/      # prompt drafts (discover & research templates)
├── research/     # research command output
├── reviews/      # review artefacts
├── tasks/        # referenceable task lists
├── CLAUDE.md     # workspace + branch-only context, surfaced at session start
└── WORKSPACE.md  # branch logistics checklist for managing the workspace
```

Archived workspaces from finished branches live in `dev/branches/{name}` and are visible from any branch — check there for prior context before starting work in a scope.

## Hooks

The plugin ships light SessionStart/SessionEnd hooks (`hooks/hooks.json`):

- **SessionStart** — show the info splash and regenerate `context/tree.md`.
- **SessionEnd** — regenerate `context/tree.md` so the next session starts current.

`tree.md`, `CLAUDE.md` and `WORKSPACE.md` are surfaced to Claude at session start via the project's context rule, giving Claude a token-efficient map and the branch's purpose before any work begins.

## Companion skills (`chat-tools` plugin)

Two features that pair with workspaces ship in the `chat-tools` plugin:

- **conversation-capture** — extract the session transcript into `history/`, summarised and named for reuse.
- **magic-reply** — prompt triggers between `--` delimiters that reshape Claude's next reply: `-- show working --`, `-- use claude space --`, `-- show options --`, `-- show strategy --`, `-- show context --`, `-- show difficulties --`. Use one per turn.

## Workspace Lifecycle

1. **Start work** — from a clean parent branch, `dev-workspace new <name>` (or `/new-workspace` with a natural-language description). Push to initiate the remote branch. Set the branch purpose in `WORKSPACE.md`.
2. **Before new work** — `dev-workspace sync` to pull parent changes; confirm prior work is recorded.
3. **Build** — work the task; commit code normally; use the magic-reply triggers to shape context.
4. **Capture** — end the session with `/clear` or `/exit` to capture the conversation into `history/`.
5. **Finish** — `dev-workspace commit` (workspace files), `dev-workspace archive` if sharing context, then `dev-workspace merge --check` followed by `dev-workspace merge`.
6. **Push** — `dev-workspace push` to publish.

Generated context and conversations are preserved permanently in archives, ready to reference or reuse.

### Tip

Load a previous conversation into context with `@` to keep sessions singular and focused while reusing earlier context — preventing context bloat.
