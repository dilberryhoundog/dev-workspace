# Hooks

## Overview

Hooks are project-specific scripts that run at defined moments in the deploy pipeline. They live in the project (not the skill) and handle server/database operations that vary per project.

## Location

Hooks live at `dev/deploy/hooks/` in the project. Scaffold examples with:

```bash
dev-deploy init --hooks
```

## Available Hooks

| Hook | Config key | Called by | Purpose |
|------|-----------|-----------|---------|
| backup-db | `hooks.backup_db` | `deploy production` | Backup database before production deploy |
| refresh-db | `hooks.refresh_db` | `setup --refresh-db`, `deploy staging --refresh-db` | Copy production data to staging |
| pre-deploy | `hooks.pre_deploy` | `deploy staging`, `deploy production` | Run before Kamal deploy |
| post-deploy | `hooks.post_deploy` | `deploy staging`, `deploy production` | Run after Kamal deploy |
| health | `hooks.health` | `health` | Custom server health checks |

## Environment Variables

Every hook receives these environment variables automatically:

| Variable | Description |
|----------|-------------|
| `DEPLOY_ENV` | `staging` or `production` |
| `DEPLOY_SERVER_HOST` | From `server.host` in config |
| `DEPLOY_SERVER_PORT` | From `server.port` in config (default: 22) |
| `DEPLOY_BRANCH` | Branch being deployed |
| `DEPLOY_URL` | Target URL from config |

## Writing Hooks

Hooks are plain bash scripts. They should:

1. Use `set -e` to fail fast
2. Use `$DEPLOY_SERVER_HOST` for SSH connections (not hardcoded IPs)
3. Echo progress with `→` prefix (consistent with dev-deploy output)
4. Exit non-zero on failure (stops the pipeline)

### Example: SQLite Backup

```bash
#!/bin/bash
set -e
PROD_DB="/var/lib/docker/volumes/myapp_storage/_data/production.sqlite3"
BACKUP_FILE="/backups/myapp/production-$(date +%Y%m%d-%H%M%S).sqlite3"

echo "→ Backing up production database..."
ssh "${DEPLOY_SERVER_HOST}" "sqlite3_rsync $PROD_DB $BACKUP_FILE"
echo "✓ Backup: $BACKUP_FILE"
```

### Example: Postgres Backup

```bash
#!/bin/bash
set -e
echo "→ Backing up production database..."
ssh "${DEPLOY_SERVER_HOST}" "pg_dump myapp_production | gzip > /backups/myapp/$(date +%Y%m%d-%H%M%S).sql.gz"
echo "✓ Backup complete"
```

## New Project, New Hooks

When setting up a new project:

1. `dev-deploy init --hooks` — scaffolds SQLite examples
2. Edit hooks for your database (Postgres, MySQL, etc)
3. Edit server paths and volume names
4. Test hooks standalone: `./dev/deploy/hooks/backup-db`
5. Wire into config: uncomment `hooks.backup_db` etc
6. Verify: `dev-deploy init --check`
