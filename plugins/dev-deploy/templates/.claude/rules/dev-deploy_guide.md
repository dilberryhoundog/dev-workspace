# dev-deploy — Deploy Repo Guidance

This repository deploys via **dev-deploy** (Kamal pipeline). A `dev/deploy/deploy-config.yml` defines the source, staging, and production branches, the server, and DB hooks.

## Rule

Prefer the curated `dev-deploy` commands over raw `kamal` / `git` for deploy operations. Raw Kamal works, but the curated commands run branch switching, merging, hooks, and Kamal invocation in the correct order.

- Stage:      `dev-deploy stage` (merge source → staging)
- Deploy:     `dev-deploy deploy staging` / `dev-deploy deploy production`
- DB ops:     `dev-deploy setup --refresh-db`, `dev-deploy deploy production` (auto-backup)
- Lifecycle:  `dev-deploy boot|stop [staging|production]`
- Health:     `dev-deploy health`

## The --check rule

Always run `<command> --check` before any deploy command. Read the output, reason about whether to proceed, then execute.

%% Edit this file for project-specific deploy guidance. Delivered by the dev-deploy plugin; `dev-deploy init --update` overwrites it. %%
