---
name: dev-deploy
description: Manage deployment pipelines for projects using Kamal. Use instead of raw kamal/git commands when a project contains dev/deploy/deploy-config.yml. Handles staging merges, production promotion, DB operations via hooks, health checks, and Kamal orchestration. Every command supports --check for safe inspection before execution.
tools:
  - exec
---

# dev-deploy — Deployment Pipeline Skill

Orchestrates Kamal deployments with staging/production environments, hook-based DB operations, and health checks.

## When To Use

Use `dev-deploy` when a project has `dev/deploy/deploy-config.yml`. This replaces raw `kamal deploy`, `git merge` for staging/production, and manual SSH for DB operations.

**Never run raw Kamal deploy commands** in a dev-deploy project — the script handles branch switching, merging, hooks, and Kamal invocation in the correct order.

## Quick Reference

```bash
dev-deploy init                      # Scaffold config
dev-deploy init --hooks              # Scaffold config + example hook scripts
dev-deploy init --check              # Verify config is valid

dev-deploy stage --check             # Show what would be merged to staging
dev-deploy stage                     # Merge source → staging and push

dev-deploy deploy staging --check    # Show staging deploy plan
dev-deploy deploy staging            # Deploy staging via Kamal
dev-deploy deploy staging --refresh-db  # Refresh DB then deploy

dev-deploy deploy production --check # Show production deploy plan
dev-deploy deploy production         # Promote + backup + deploy production

dev-deploy boot staging              # Start staging app
dev-deploy stop staging              # Stop staging app
dev-deploy boot                      # Start production app (default)
dev-deploy stop                      # Stop production app (default)

dev-deploy setup --refresh-db        # Refresh staging DB from production

dev-deploy health                    # Full health check (apps, branches, server)
```

## The --check Rule

**Always run `--check` before any deploy command.** Read the output. Reason about whether to proceed. Never blindly execute.

## How Staging Works

`source.branch` in config points to a local branch containing deployable code. Before staging, this branch must be in sync with origin. `stage --check` verifies readiness, `stage` fails if not in sync.

For dual-repo setups (fork → deploy repo), `dev-workspace deploy push` sends code to the deploy repo's receiving branch. Pull that branch locally, then stage as normal — dev-deploy doesn't need to know where the commits came from.

## Hooks

Project-specific scripts called at key moments. Hooks receive config as environment variables (`DEPLOY_ENV`, `DEPLOY_SERVER_HOST`, etc). They live in the project at `dev/deploy/hooks/`, not in the skill.

| Hook | Called by | Purpose |
|------|-----------|---------|
| `backup_db` | `deploy production` | Backup database before production deploy |
| `refresh_db` | `setup --refresh-db` or `deploy staging --refresh-db` | Copy production data to staging |
| `pre_deploy` | `deploy staging` / `deploy production` | Run before Kamal deploy |
| `post_deploy` | `deploy staging` / `deploy production` | Run after Kamal deploy |
| `health` | `health` | Custom server health checks |

Scaffold example hooks with `dev-deploy init --hooks`.

## Config

Lives at `dev/deploy/deploy-config.yml`. Comment out sections to disable features.

## Relationship with dev-workspace

`dev-workspace` handles the **git workflow** (branches, merging, archiving).
`dev-deploy` handles the **infrastructure** (Kamal, staging, production, DB ops).

For dual-repo setups: `dev-workspace deploy push` → receiving branch → pull locally → `dev-deploy stage` → `dev-deploy deploy`.
For single-repo setups: `dev-deploy stage` → `dev-deploy deploy` (no deploy push needed).

## References

Read the relevant reference doc before multi-step operations:

- `references/staging-flow.md` — Full staging workflow (stage → deploy → verify)
- `references/production-flow.md` — Production promotion (backup → promote → deploy)
- `references/hooks.md` — Writing and configuring hooks
- `references/health.md` — Health check details and custom hooks
