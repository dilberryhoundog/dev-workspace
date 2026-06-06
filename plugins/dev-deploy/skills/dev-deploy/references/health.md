# Health Check

## Overview

`dev-deploy health` checks three things: app status (via Kamal), branch sync state (via git), and server health (via SSH or custom hook).

## What It Checks

### Apps
- Queries Kamal for container status (up/down + uptime)
- Checks both production and staging (if configured)
- Requires Kamal on PATH

### Branches
- Fetches origin to get accurate state
- Shows source branch sync status (local vs origin)
- Shows staging sync status (ahead/behind origin)
- Shows source → staging merge status (commits not yet staged)
- Helps spot: forgot to push, forgot to stage, staging drift

### Server
- If `hooks.health` is configured: runs custom health hook
- Otherwise: basic disk usage check via SSH to `server.host`
- Custom hook can check: disk, backups, cron, memory, Docker, anything

## Custom Health Hook

For detailed server checks, create a health hook at `dev/deploy/hooks/health`:

```bash
#!/bin/bash
set -e

echo ""
echo "Server ($DEPLOY_SERVER_HOST)"
echo ""

echo "→ Disk:"
ssh -o ConnectTimeout=5 "$DEPLOY_SERVER_HOST" \
  "df -h / | tail -1 | awk '{printf \"  %s used of %s (%s free)\n\", \$3, \$2, \$4}'"

echo "→ Backups:"
ssh -o ConnectTimeout=5 "$DEPLOY_SERVER_HOST" "
  BACKUP_DIR=/backups/myapp
  HOURLY=\$(ls -1 \$BACKUP_DIR/production-*.sqlite3 2>/dev/null | wc -l | tr -d ' ')
  DAILY=\$(ls -1 \$BACKUP_DIR/daily-*.sqlite3 2>/dev/null | wc -l | tr -d ' ')
  LATEST=\$(ls -1t \$BACKUP_DIR 2>/dev/null | head -1)
  echo \"  \${HOURLY} hourly, \${DAILY} daily\"
  [ -n \"\$LATEST\" ] && echo \"  latest: \$LATEST\"
"

echo "→ Cron:"
ssh -o ConnectTimeout=5 "$DEPLOY_SERVER_HOST" "
  crontab -l 2>/dev/null | grep -v '^#' | grep -v '^\$' | while read -r line; do
    echo \"  \$line\"
  done
"
```

Wire it in config:
```yaml
hooks:
  health: dev/deploy/hooks/health
```

## Agent Usage

Agents can run `dev-deploy health` during heartbeat checks to monitor deployment status. Parse the output to detect issues and alert the human if something's down.
