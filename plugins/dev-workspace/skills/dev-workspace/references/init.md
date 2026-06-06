# Init — Setting Up Dev Workspace

## First-Time Setup

The init process has three steps:

### Step 1: Scaffold config files

```bash
dev-workspace init
```

Copies template `workspace-config.yml` from the skill directory into `dev/workspace/`. Does NOT overwrite existing files — safe to run again.

### Step 2: Edit the config

Open `dev/workspace/workspace-config.yml` and configure for your project:

**Fork repo** (contributing to someone else's project):

```yaml
repo_config:
  main_branch: main
  parent_branch: command
  origin: https://github.com/you/their-project.git
  upstream: https://github.com/them/their-project.git
  workspace: https://github.com/dilberryhoundog/dev-workspace.git
  upstream_latest_to: main
```

**Vanilla repo** (your own project):

```yaml
repo_config:
  main_branch: main
  parent_branch: main
  origin: https://github.com/you/your-project.git
  # upstream: false
  workspace: https://github.com/dilberryhoundog/dev-workspace.git
```

Key difference: fork repos have `upstream` set and `parent_branch` differs from `main_branch` (typically "command"). Vanilla repos comment out `upstream` and set both branches to "main".

### Step 3: Apply settings

```bash
dev-workspace init --write
```

Reads the config and writes settings to the project:

- Configures git merge driver (`merge.protect`) to prevent workspace files overwriting parent on merge
- Adds paths to `.git/info/exclude` (local gitignore — not committed to repo)
- Sets `.gitattributes` merge strategies for protected directories
- Adds `/dev/` to `.dockerignore` if it exists (keeps workspace out of Docker images)
- Adds/updates `workspace` git remote pointing to the dev-workspace repo
- Optionally pulls workspace files on first init (`pull_workspace_on_init: true`)
- Makes scripts in `dev/run/` executable if they exist

All settings are idempotent — running `--write` again applies any new config changes without duplicating existing entries.

## Verification

```bash
dev-workspace init --check
```

Verifies all init settings are applied. Reports any missing configuration with actionable fix instructions.

## Re-Running Init

If you add new directories to protect, ignore, or exclude from Docker:

1. Update the relevant section in `workspace-config.yml`
2. Run `dev-workspace init --write` again
3. Verify with `dev-workspace init --check`

## What Each Init Section Controls

### workspace_protection (not part of init)

Workspace protection is configured in the top-level `workspace_protection` section of `workspace-config.yml` and is enforced at script level during merge and sync. It does not require `init --write` to apply. See `references/merge.md` and `references/sync.md` for details.

### git_ignore

Adds paths to `.git/info/exclude` (local-only gitignore). These files exist on disk but are invisible to git. Used for generated files like tree output that should not be committed.

### exclude_workspace_from_docker

Adds workspace paths to `.dockerignore`. This is why directory stripping during deploy is unnecessary — Docker never copies workspace files into the image.

### setup_workspace_origin

Adds a git remote named `workspace` pointing to the dev-workspace repo. This remote is used by `dev-workspace rebuild` to pull workspace system updates into the project.
