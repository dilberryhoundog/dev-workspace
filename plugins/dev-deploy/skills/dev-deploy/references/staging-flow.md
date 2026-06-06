# Staging Flow

## Overview

Merge deployable code into the staging branch and deploy via Kamal.

## Sequence

1. **Preflight**: `dev-deploy stage --check` — verifies source is in sync with origin, shows commits to merge
2. **Stage**: `dev-deploy stage` — merges source into staging branch, pushes to origin
3. **Optional DB refresh**: `dev-deploy deploy staging --refresh-db` — refreshes staging DB from production before deploying
4. **Deploy**: `dev-deploy deploy staging` — pulls latest staging, runs pre_deploy hook, deploys via Kamal, runs post_deploy hook

## Source Branch

`source.branch` in config points to a local branch with deployable code (typically `main`). Before staging, this branch must be in sync with its origin counterpart. The `stage` command checks this and fails if there's a mismatch — push or pull your source branch first.

For dual-repo setups (fork → deploy repo), `dev-workspace deploy push` sends code to the deploy repo. Pull the receiving branch locally so it matches origin, then stage as normal.

```
source branch (in sync with origin) → dev-deploy stage → staging branch
                                    → dev-deploy deploy staging → kamal deploy
```

## Preflight (--check)

`stage --check` reports:

- Is source branch in sync with origin? (required for staging to proceed)
- How many commits will be merged into staging?
- Recent commits to be merged

Always run `--check` before staging. If source is out of sync, the check tells you whether to push or pull.

## Merge Conflicts

If `dev-deploy stage` hits a merge conflict, it stops on the staging branch with the merge in progress (rather than leaving you stranded mid-pipeline). To finish:

1. Fix the conflicted files (`git status` lists them)
2. `git add` the resolved files
3. `dev-deploy stage --continue` — completes the merge commit and pushes

You stay on the staging branch afterwards (where the conflict left you), so `--continue` does **not** return you to the branch you started on. Switch back yourself if needed, then proceed with `dev-deploy deploy staging`.

> `--continue` only supports the default merge strategy. A `--squash` strategy is not supported by `dev-deploy stage` at all — squash needs a hand-authored commit, so stage it manually with git.

## Safety

- Always `--check` before staging to see what's coming in
- The staging merge uses the strategy configured in `staging.merge_strategy` (default: `--no-edit`)
- Staging deploy is isolated from production — safe to test migrations, new features
- DB refresh is opt-in (`--refresh-db`), never automatic
