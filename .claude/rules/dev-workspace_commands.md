# Dev Workspace Commands

This is a complete cookbook of all available commands for the Dev Workspace. Use these in preference to standard `git` and `gh` commands.

## Base

| command                    | description                                |
|----------------------------|--------------------------------------------|
| `dev-workspace`            | Shows a splash screen of the Dev Workspace |
| `dev-workspace info`       | Show workspace info                        |
| `dev-workspace help`       | Show help for all commands                 |
| `dev-workspace help <cmd>` | Show help for a specific command           |
| `dev-workspace version`    | Show version number                        |

## Init

| command                      | description                                   |
|------------------------------|-----------------------------------------------|
| `dev-workspace init`          | Scaffold config files from skill template      |
| `dev-workspace init --write`  | Apply config settings to project (idempotent)  |
| `dev-workspace init --check`  | Verify settings are applied                    |
| `dev-workspace init --update` | Refresh scaffold from plugin templates (parent branch only) |

## New

| command                            | description                           |
|------------------------------------|---------------------------------------|
| `dev-workspace new`                | List branches from parent             |
| `dev-workspace new <name>`         | Create new workspace branch           |
| `dev-workspace new <name> --check` | Validate readiness without creating   |
| `dev-workspace new <name> --force` | Create even if local is behind remote |

## Push

| command                             | description                              |
|-------------------------------------|------------------------------------------|
| `dev-workspace push`                | Push current branch to origin            |
| `dev-workspace push --check`        | Show push status (ahead/behind/diverged) |
| `dev-workspace push --check --json` | Machine-readable push status             |
| `dev-workspace push --force-w-l`    | Force push with lease (post-rebase)      |

## Sync

| command                             | description                                   |
|-------------------------------------|-----------------------------------------------|
| `dev-workspace sync`                | Merge parent into current feature branch      |
| `dev-workspace sync --check`        | Show how far behind parent                    |
| `dev-workspace sync --check --json` | Machine-readable sync status                  |
| `dev-workspace sync --full`         | Bare merge — no workspace file protection     |
| `dev-workspace sync --rebase`       | Rebase onto parent instead of merge           |
| `dev-workspace sync --continue`     | Complete sync after resolving merge conflicts |

## Merge

| command                              | description                              |
|--------------------------------------|------------------------------------------|
| `dev-workspace merge`                | Merge current branch to parent           |
| `dev-workspace merge --check`        | Full preflight report (ALWAYS run first) |
| `dev-workspace merge --check --json` | Machine-readable merge preflight         |
| `dev-workspace merge --local`        | Force local merge (skip PR detection)    |
| `dev-workspace merge --github`       | Force GitHub PR merge                    |
| `dev-workspace merge --continue`     | Complete merge after resolving conflicts |

## Commit

| command                        | description                  |
|--------------------------------|------------------------------|
| `dev-workspace commit`         | Commit workspace files only  |
| `dev-workspace commit --check` | Show what would be committed |

## Archive

| command                             | description                             |
|-------------------------------------|-----------------------------------------|
| `dev-workspace archive`             | Archive workspace to dev/branches/      |
| `dev-workspace archive --check`     | Show archive status + sync divergences  |
| `dev-workspace archive --sync`      | Bidirectional sync archives with parent |
| `dev-workspace archive --path`      | Output archive path (for scripting)     |
| `dev-workspace archive --no-commit` | Archive files but skip git commit       |

## Latest

| command                               | description                              |
|---------------------------------------|------------------------------------------|
| `dev-workspace latest --check`        | Show sync status of main with remotes    |
| `dev-workspace latest --check --json` | Machine-readable main and remote status  |
| `dev-workspace latest --upstream`     | Reset local main to upstream (fork only) |
| `dev-workspace latest --origin`       | Reset local main to origin               |

## Transfer Latest

| command                                        | description                              |
|------------------------------------------------|------------------------------------------|
| `dev-workspace transfer-latest`                | Merge main_branch into parent_branch     |
| `dev-workspace transfer-latest --check`        | Show status, verify main is current      |
| `dev-workspace transfer-latest --check --json` | Machine-readable status                  |
| `dev-workspace transfer-latest --ff`           | Allow fast-forward merge                 |
| `dev-workspace transfer-latest --continue`     | Complete merge after resolving conflicts |

## Deploy

| command                             | description                  |
|-------------------------------------|------------------------------|
| `dev-workspace deploy push`         | Push source to deploy target |
| `dev-workspace deploy push --check` | Show deploy status           |

## Cleanup

| command                             | description                               |
|-------------------------------------|-------------------------------------------|
| `dev-workspace cleanup`             | List available cleanup platforms          |
| `dev-workspace cleanup <platform>`  | Scan for exports from platform            |
| `dev-workspace cleanup claude-code` | Scan for Claude Code conversation exports |

## Tree

| command                     | description                                     |
|-----------------------------|-------------------------------------------------|
| `dev-workspace tree`        | Generate all configured trees (default + named) |
| `dev-workspace tree --show` | List available trees (name + description)       |
