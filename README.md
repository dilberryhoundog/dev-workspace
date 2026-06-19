# Dev Workspace

> A Claude Code plugin for shaping, storing, building and revealing the context that Claude generates and consumes while working on a codebase.

## What is it?

Dev Workspace is a developer workspace system delivered as a **Claude Code plugin**. The premise is simple — give Claude (and yourself) a clean, consistent, per-branch home for every piece of context a coding session produces: plans, research, reviews, conversations, scratch files and discoveries. Then make that context easy to store, sync, share and reveal.

It is not a workflow and it won't replace the one you have. It's a toolset that slots underneath whatever you already do. It doesn't touch your `CLAUDE.md`, agents, MCP servers or output styles — those stay yours. What it adds is structure, a fast CLI, and a handful of premium context tricks that make Claude noticeably sharper.

Install the plugin, run one init in your project, and you're working.

## Install

Dev Workspace ships from the **DBHD-dev-workspace** marketplace. Inside Claude Code:

```
/plugin marketplace add dilberryhoundog/dev-workspace
/plugin install dev-workspace@DBHD-dev-workspace
```

> The companion `dev-deploy` plugin (Kamal staging/production pipelines) lives in the same marketplace and installs the same way.

Then, in the root of any project you want a workspace in:

```bash
dev-workspace init          # scaffold dev/workspace/workspace-config.yml
# edit workspace-config.yml for your repo (origin, branches, fork/vanilla)
dev-workspace init --write  # apply git settings, remotes, merge protection (idempotent)
```

That's it. Full setup and command reference lives in the workspace README that `init` drops into your project at `dev/workspace/README.md`.

### Keeping up to date

Updates come in two layers:

- **The plugin itself** (CLI, skills, hooks) updates through Claude Code's plugin manager — manage it from `/plugin`.
- **The workspace templates in your project** (the scaffolded `dev/workspace/`, rules and config) refresh with:

```bash
dev-workspace init --update   # on the parent branch — pulls new template files,
                              # leaves your workspace-config.yml untouched
dev-workspace commit          # propagate the refreshed scaffold
```

## The Pillars

A workspace rests on a few simple foundations — Git, a directory system, a CLI command suite, and hooks. This combination produces an outcome far greater than the sum of its parts.

### Directory System

The foundation is a consistent, per-branch context store. Precious context deserves to be stored well — not just for you, but for Claude.

```txt
└── dev
    └── workspace
        ├── context      # discovery output, tree views — Claude's vision over the codebase
        ├── filebox      # scratch files, a dump location for the random stuff Claude produces
        ├── history      # every conversation with Claude, summarised and named, ready to reuse
        ├── plans        # planning documents, with product & architecture templates
        ├── prompts      # build prompts in files before pasting — more fidelity, less pressure
        ├── research     # output location for the research command, or any ad-hoc research
        ├── reviews      # review artefacts from the workspace commands
        ├── tasks        # referenceable task lists, tracking work across many sessions
        ├── CLAUDE.md    # workspace context + branch-only discoveries, shown to Claude at session start
        └── WORKSPACE.md # branch logistics checklist that guides Claude managing the workspace
```

Each directory gives Claude and you a dedicated home for one kind of context. `CLAUDE.md` and `WORKSPACE.md` are surfaced to Claude when the session starts so it knows the branch's purpose and how to manage the work.

### Git Management

Every fix, feature, bug and refactor becomes a branch — and every branch gets a brand new, clean workspace with empty folders and ready-to-use templates. A new branch is a fresh slate. Switching branches switches context, which keeps Claude's context targeted and focused, and Claude responds to that excellently.

The whole git lifecycle is driven by the CLI — create, push, sync, merge — with branch protections that stop your workspace context from being committed to the parent branch or clobbered by incoming changes. When a branch is done, Claude reads your `WORKSPACE.md` to know exactly how to merge it and what to do with the context, then prepares, safety-checks and merges it back.

And the context isn't lost. **Archives** snapshot a workspace into `dev/branches/{name}`, where it persists and is shared across the whole project. Revisit the conversations, reuse the plans, or cherry-pick a snippet from another branch's filebox. Workspaces are disposable; archives are forever.

### CLI Command Suite

Every workspace needs a control panel — the `dev-workspace` CLI is it. It consolidates and links common `git`, `gh`, file and tree operations into commands designed to "just work", consistently, for both humans and agents.

```
dev-workspace new <name>     Create a workspace branch
dev-workspace push           Push the branch to remote
dev-workspace sync           Pull parent changes into the branch
dev-workspace merge          Merge the branch back to parent (run --check first)
dev-workspace commit         Commit workspace files only
dev-workspace archive        Snapshot and save the workspace
dev-workspace tree           Regenerate directory context
dev-workspace init --update  Refresh workspace templates after a plugin update
```

…and more (`init`, `latest`, `transfer-latest`, `deploy`, `cleanup`). Run `dev-workspace help` for the full cookbook, or `dev-workspace <command> --check` for a dry-run of any command. A small set of slash commands (`/discover`, `/research`, `/new-workspace`, `/health`, `/workspace-PR`) round out the agent-facing workflow.

### Hooks

A light set of plugin hooks keeps context fresh automatically:

- **SessionStart** — shows the workspace info splash and regenerates `tree.md`, giving Claude an up-to-date map of the project before any work begins.
- **SessionEnd** — regenerates the tree so the next session starts current.

The tree, plus your `CLAUDE.md` and `WORKSPACE.md` (pulled in via the project's context rule), are silently surfaced to Claude at session start. `tree.md` is the most token-efficient way to show Claude every relevant file and folder — no more blind searching. File and folder names reveal a surprising amount of logic and flow; this becomes a kind of superpower.

## Companion superpowers — the `chat-tools` plugin

Two of Dev Workspace's most loved features now ship in the companion **`chat-tools`** plugin, so you can use them anywhere — not just inside a workspace.

### Conversation Capture

A premium context-capture tool. Every conversation with Claude can be parsed, summarised and recorded in your workspace `history/`, ready to re-read, inject into another session, or mine for patterns.

- Rich, readable, token-efficient history files built from configurable templates.
- Records the flow of reads, writes, edits, bash, agents and skills — *what* happened, without the bulky file contents.
- A headless pass names each file with a date prefix and writes a short summary, so you can scan history by topic at a glance.

A great workflow: chat with Claude to explore and discover, capture the transcript, then start a fresh session and load that transcript — advanced, token-saving, naturally-built context with none of the bloat.

### Prompt Triggers (magic-reply)

Back when Sonnet 3.5 was the world's best coding model, I built a context-shaping system using styles ([my pinned Reddit guide](https://www.reddit.com/r/ClaudeAI/comments/1i4c6jx/my_guide_to_using_styles_effectively)). Over a year later those styles are still gold — and now they're a trigger away. Drop a phrase between `--` delimiters and Claude's next reply changes shape:

- **show working** — Claude reflects back its understanding, ideas, anticipated issues and where in the project changes will land. The best misunderstanding-catcher and prompt-improver there is.
- **use claude space** — session-level thinking. Claude thinks out loud about the *whole* conversation and surfaces candid thoughts that never normally appear.
- **show options** — surfaces alternative approaches Claude wouldn't otherwise offer, with a recommendation.
- **show strategy** — reveals *how* Claude will implement (its process, not its changes) and any difficulties ahead.
- **show context** — lists exactly where Claude intends to find context for the task.
- **show difficulties** — Claude analyses the thread for communication issues and leaves a record, making it far more likely to stop misbehaving.

Use one trigger per turn — chained across replies they leave a trail of shaped context that gives Claude superpowers.

## What makes it special

### Branch Archive

When a branch is finished, one command archives its entire workspace into an auto-named `dev/branches/{name}` directory — an amazing record of how you built your project. Archiving early lets you work on multiple branches at once with only branch-relevant context in play, and share snippets between branches through the archive. Level up: A/B-build a feature on two branches, merge the winner, cherry-pick between them via the archived filebox.

### Blank Slate

This is a toolset, not a workflow — infinitely able to accommodate whatever Claude Code workflow you bring. Use what you want, leave out what you don't. It deliberately ships no opinionated skills, agents, output-styles or `CLAUDE.md` content, yet doesn't need them to be effective. You get efficient token usage, preserved usage limits, and key context right where Claude needs it.

For teams: complete visibility into the context an individual generates, shared context through archives on the parent branch, reliable templates that stay customisable per workspace, and clean integration with each developer's workflow.

Don't be surprised if velocity climbs, Claude's quality jumps, and reusable context accumulates while staying out of your way. Enjoy — free, and feedback welcome.

## Instructions

Once installed and initialised, your project's `dev/workspace/README.md` is the full logistical reference — setup, the complete command cookbook, the directory system, hooks and lifecycle.
