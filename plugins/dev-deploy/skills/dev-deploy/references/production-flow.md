# Production Flow

## Overview

Promote code from staging (or source branch) to production and deploy via Kamal.

## Sequence

1. **Verify staging**: Ensure staging is deployed and tested
2. **Check**: `dev-deploy deploy production --check` — shows commits to promote, backup hook status
3. **Deploy**: `dev-deploy deploy production` — full pipeline:
   - Pulls latest promote_from branch (usually staging)
   - Switches to production branch, pulls latest
   - Merges promote_from into production branch
   - Pushes production branch
   - Runs backup_db hook (database backup)
   - Runs pre_deploy hook
   - Deploys via Kamal
   - Runs post_deploy hook
   - Switches back to promote_from branch

## Hook Order

```
merge staging → production
  ↓
push production
  ↓
backup_db hook     ← backup BEFORE deploy (rollback safety)
  ↓
pre_deploy hook    ← any pre-deploy tasks
  ↓
kamal deploy       ← actual deployment
  ↓
post_deploy hook   ← notifications, cache clear, etc
```

## Direct Deploy (No Staging)

If `production.promote_from` points to the source branch instead of staging, the production deploy skips the staging step entirely. Useful for simple projects.

## Rollback

If production deploy fails:
1. Kamal has built-in rollback: `kamal rollback`
2. Database was backed up by the backup_db hook before deploy
3. The merge commit is already pushed — revert with `git revert` if needed

## Safety

- **Always `--check` first** — shows exactly what will be promoted
- Backup hook runs BEFORE Kamal deploy — database is safe even if deploy fails
- Script switches back to promote_from branch after deploy — you don't get stranded on main
- Production Kamal destination is optional — if not set, Kamal uses its default (production)
