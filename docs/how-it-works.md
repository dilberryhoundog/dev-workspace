# How Dev Workspace Works

## Detection

A project uses dev-workspace if `dev/workspace/workspace-config.yml` exists in its directory tree. The script auto-detects the project root by walking up from the current directory.

## Init — Setting Up a Project

Init is a three-step process:

1. **Scaffold** — `dev-workspace init` copies template config files (`workspace-config.yml` and `workspace.yml`) into `dev/workspace/`. Safe to re-run, never overwrites existing files.

2. **Configure** — Edit `dev/workspace/workspace-config.yml` for the project. Two repo types:
   - **Vanilla** (your own project): `parent_branch: main`, `upstream: false`
   - **Fork** (contributing to someone else's): `parent_branch: command`, `upstream: <their-repo-url>`. Main stays pristine as a mirror of upstream. Work happens on the `command` branch.

3. **Apply** — `dev-workspace init --write` reads the config and applies settings: configures the git merge driver for workspace protection, sets `.gitattributes` merge strategies, adds paths to `.git/info/exclude`, sets up the workspace remote, and optionally pulls workspace files.

All init settings are idempotent. Verify with `dev-workspace init --check`.

## Branch Lifecycle

### Create
`dev-workspace new <name>` creates a branch from the parent. The workspace inherits from the parent branch — templates, config, and any shared workspace structure transfer automatically. The branch is created with `--no-track` intentionally (don't "fix" this).

### Work
Code and workspace context accumulate on the branch. Use `dev-workspace commit` to commit workspace files separately from code — this command unstages everything first, then stages only the configured workspace directories. Workspace commits are isolated from code commits.

### Push
`dev-workspace push` pushes the current branch to origin. Use `--check` first to see the push status. If the branch has diverged (e.g. after a rebase), use `--force-w-l` (force with lease, not force push — the difference matters).

### Sync
`dev-workspace sync` merges the parent branch into the current feature branch, bringing in work from other branches that has been merged to parent. The merge driver protects `dev/workspace/` — the feature branch's context is never overwritten.

For fork repos, there are THREE separate sync-related commands that do completely different things:
- `sync` — merges parent into feature branch
- `latest` — resets local main to upstream (uses `git reset --hard`, destructive)
- `transfer-latest` — transfers main into command branch

Using the wrong one causes real damage. Read the sync reference before fork operations.

### Merge
`dev-workspace merge` merges the feature branch back to parent. Always run `--check` first — it's a mandatory preflight. The preflight checks for clean working tree, pushed commits, conflicts, PR status, and archive status.

Merge protection ensures workspace files from the feature branch don't overwrite the parent's workspace. The parent keeps its own workspace templates clean.

Three merge strategies available: `--merge`, `--squash`, `--rebase`. The config determines which is used. Auto-detection chooses between local and GitHub PR merge — override with `--local` or `--github`.

### Archive
`dev-workspace archive` snapshots the current branch's workspace into `dev/branches/<branch-name>/`. The archive is committed to git and visible from every branch. Use before merging if `archive_before_merge` is configured.

`dev-workspace archive --sync` does bidirectional sync between the workspace and its archive on the parent branch. Useful for keeping archives current across long-lived branches.

## The --check Pattern

Every command supports `--check` to inspect state without making changes. For destructive commands (merge, latest, deploy), the workflow is mandatory:

1. Run `command --check` — inspect the output
2. If issues → stop and discuss with the human
3. If clear → run the command

## Config Files

Two YAML files in `dev/workspace/`:

- **`workspace-config.yml`** — Machine-read by the script. Repo setup, remotes, merge strategy, deploy, init settings, archive config. This drives all automation.

- **`workspace.yml`** — Human and agent-readable. Branch purpose, status, workflow type, plan references. Not read by the script — purely for context.

## Workspace Directory Structure

```
dev/workspace/
  workspace-config.yml   # machine config
  workspace.yml          # human/agent context
  CLAUDE.md              # loaded into Claude's context
  context/               # discoveries, resources
  filebox/               # temporary file storage
  history/               # conversation transcripts
  plans/                 # structured planning docs
  prompts/               # reusable prompts
  research/              # research artifacts
  reviews/               # completed work reviews
  tasks/                 # task files
```

## Merge Protection Mechanics

The init process configures a custom git merge driver called `protect` that always keeps the current branch's version of protected files. This is set via:

1. `.git/config` — defines the `merge.protect` driver (uses `true` as the merge command, meaning "keep ours")
2. `.gitattributes` — maps paths like `dev/workspace/**` to use the `protect` driver

This means during any merge TO the parent branch, the parent's workspace files are preserved. The feature branch's workspace context never overwrites the parent's clean templates.
