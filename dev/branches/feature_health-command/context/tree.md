---
name: workspace overview
description: Core workspace and project structure
---

dev/workspace
├── context
│   ├── .keep
│   └── tree.md
├── filebox
│   └── README.txt
├── history
│   └── .keep
├── plans
│   ├── .keep
│   ├── architectural.md
│   ├── health-command-plan.md
│   └── prd.md
├── prompts
│   ├── .keep
│   ├── discover_prompt.md
│   ├── README.md
│   └── research_prompt.md
├── research
│   └── .keep
├── reviews
│   └── .keep
├── tasks
│   ├── .keep
│   └── health-command-tasks.md
├── README.md
├── workspace-config.yml
└── WORKSPACE.md
plugins
├── dev-deploy
│   ├── .claude-plugin
│   │   └── plugin.json
│   ├── agents
│   ├── bin
│   │   └── dev-deploy
│   ├── commands
│   ├── hooks
│   │   └── health
│   │       ├── 10-plugin-scope
│   │       ├── 20-stub-location
│   │       ├── 30-kamal-apps
│   │       ├── 40-branch-sync
│   │       └── 50-server
│   ├── monitors
│   ├── output-styles
│   ├── scripts
│   ├── skills
│   │   └── dev-deploy
│   │       ├── references
│   │       │   ├── health.md
│   │       │   ├── hooks.md
│   │       │   ├── production-flow.md
│   │       │   └── staging-flow.md
│   │       ├── scripts
│   │       │   └── dev-deploy
│   │       ├── stubs
│   │       │   ├── dev-deploy
│   │       │   └── dev-deploy_deprecated
│   │       ├── templates
│   │       │   ├── hooks
│   │       │   │   ├── backup-db
│   │       │   │   └── refresh-db
│   │       │   └── deploy-config.yml
│   │       └── SKILL.md
│   ├── templates
│   │   └── .claude
│   │       └── rules
│   │           └── dev-deploy_guide.md
│   ├── themes
│   └── CHANGELOG.md
└── dev-workspace
    ├── .claude-plugin
    │   └── plugin.json
    ├── agents
    ├── bin
    │   └── dev-workspace
    ├── commands
    │   ├── discover.md
    │   ├── new-workspace.md
    │   ├── overview.md
    │   ├── research-v2.md
    │   ├── research.md
    │   └── workspace-PR.md
    ├── hooks
    │   ├── health
    │   │   ├── 10-plugin-scope
    │   │   └── 20-stub-location
    │   └── hooks.json
    ├── monitors
    ├── output-styles
    ├── scripts
    ├── skills
    │   ├── dev-workspace
    │   │   ├── assets
    │   │   │   └── info.txt
    │   │   ├── references
    │   │   │   ├── archive.md
    │   │   │   ├── cleanup.md
    │   │   │   ├── commit.md
    │   │   │   ├── deploy.md
    │   │   │   ├── health.md
    │   │   │   ├── init.md
    │   │   │   ├── merge.md
    │   │   │   ├── new-workspace.md
    │   │   │   ├── push.md
    │   │   │   ├── sync.md
    │   │   │   └── tree.md
    │   │   ├── scripts
    │   │   │   ├── cleanup-claude-code
    │   │   │   ├── dev-workspace
    │   │   │   └── tree
    │   │   ├── stubs
    │   │   │   ├── dev-workspace
    │   │   │   ├── dev-workspace_deprecated
    │   │   │   ├── dw -> /Users/dylangraham/.local/bin/dev-workspace
    │   │   │   └── readme.txt
    │   │   ├── templates
    │   │   │   └── workspace-config.yml
    │   │   └── SKILL.md
    │   └── new-workspace
    │       ├── scripts
    │       │   ├── create-branch
    │       │   └── preflight
    │       └── SKILL.md
    ├── templates
    │   ├── .claude
    │   │   ├── rules
    │   │   │   ├── context.md
    │   │   │   ├── dev-workspace_commands.md
    │   │   │   └── dev-workspace_guide.md
    │   │   ├── CLAUDE.md
    │   │   └── settings.json
    │   └── dev
    │       ├── project
    │       │   └── .keep
    │       └── workspace
    │           ├── context
    │           │   ├── .keep
    │           │   └── tree.md
    │           ├── filebox
    │           │   └── README.txt
    │           ├── history
    │           │   └── .keep
    │           ├── plans
    │           │   ├── .keep
    │           │   ├── architectural.md
    │           │   └── prd.md
    │           ├── prompts
    │           │   ├── .keep
    │           │   ├── discover_prompt.md
    │           │   ├── README.md
    │           │   └── research_prompt.md
    │           ├── research
    │           │   └── .keep
    │           ├── reviews
    │           │   └── .keep
    │           ├── tasks
    │           │   └── .keep
    │           ├── README.md
    │           └── WORKSPACE.md
    ├── themes
    └── CHANGELOG.md

65 directories, 97 files
