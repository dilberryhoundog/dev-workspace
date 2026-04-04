# Deploy — Push to Deploy Repo

## Commands

```
dev-workspace deploy push --check        # Verify deploy config and source branch
dev-workspace deploy push                # Push to deploy target
```

## How It Works

Push a source branch to a receiving branch on a separate deploy repository. This is for dual-repo setups where development happens in one repo and deployment runs from another.

```yaml
# workspace-config.yml
deploy:
  source: command

  remote:
    repo_url: https://github.com/org/project.git
    receiving_branch: deploy-receive
```

The script adds a `deploy` git remote (or updates it) and pushes the source branch to the receiving branch.

## Single Repo Setup

For vanilla repos where development and deployment share the same repository, comment out the entire `deploy` section. Staging and production are handled directly by `dev-deploy` — no deploy push needed.

## Docker and Workspace Files

`.dockerignore` excludes `/dev/` from Docker builds (configured during `init`). This means workspace files never reach the server image. **No directory stripping or worktree tricks needed.**

## Deploy Check

`deploy push --check` reports:

- Source branch and whether it exists
- Remote repo URL
- Receiving branch name

Always run `--check` before pushing. If config is missing or source branch doesn't exist, the check catches it.

## After Deploy Push

The deploy push only gets code to the deploy repo. Actual staging, promotion, and deployment is handled by `dev-deploy` in the deploy repo.

## No Deploy Config

If the `deploy` section is commented out or missing from config, the deploy command reports "Deploy not configured" and exits. This is expected for single-repo projects.
