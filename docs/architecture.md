# Architecture

## Skill Structure

Dev-workspace is a Claude Code skill. The skill lives at `.claude/skills/dev-workspace/` in any project that uses it:

```
.claude/skills/dev-workspace/
  SKILL.md              # skill definition, command reference, usage rules
  scripts/
    dev-workspace       # bash script — all commands
  references/
    init.md             # project setup guide
    new-workspace.md    # branch creation
    push.md             # pushing branches
    sync.md             # syncing (3 commands, critical reading)
    merge.md            # merging branches
    commit.md           # workspace commits
    archive.md          # context preservation
    deploy.md           # deploy push
  templates/
    workspace-config.yml  # config template copied during init
    workspace.yml         # workspace context template
```

### SKILL.md
The skill definition tells Claude when and how to use dev-workspace. Key rule: NEVER use raw git for branch creation, pushing, syncing, merging, or workspace commits in dev-workspace projects. Always use the `dev-workspace` command.

### The Script
A single bash script handles all commands. It auto-detects the project root by walking up from the current directory looking for `dev/workspace/workspace-config.yml`. All config is read from that file.

### References
The references contain procedural knowledge that the commands alone don't convey — safety constraints, required sequences, what to check before acting, how to interpret output, recovery procedures. The SKILL.md explicitly warns: "You do not know how this tool works from the commands alone."

Always read the relevant reference before executing multi-step operations.

## Hook System

Dev-workspace includes a hook system powered by the `claude_hooks` Ruby gem. Hooks fire at key moments in the Claude Code session:

```
.claude/hooks/
  entrypoints/           # entry scripts per hook event
    session_start.rb
    session_end.rb
    user_prompt_submit.rb
  handlers/              # modular handlers per event
    session_start/
      context_loader.rb
      tree_generator.rb
    session_end/
      extract_transcript.rb
    user_prompt_submit/
      check_working.rb
      claude_space.rb
      show_context.rb
      show_difficulties.rb
      show_options.rb
      show_strategy.rb
      show_working.rb
```

Entrypoints are the hooks Claude Code calls. Each entrypoint dispatches to handlers. Handlers are modular — add or remove handlers without touching the entrypoint.

The `user_prompt_submit` handlers inject context and guidance into the agent's workflow based on trigger patterns in user messages.

The `session_end` handler extracts conversation transcripts for the history system.

### claude_hooks Gem
The Ruby gem provides the framework for hook entrypoints, handler dispatch, and output formatting. Installed at the system gem level. Contains its own docs and examples.

## Dev-Deploy (Companion Skill)

Dev-deploy is a separate skill that handles infrastructure (Kamal deployments, staging/production, DB operations). It works alongside dev-workspace:

- Dev-workspace handles the **git workflow** (branches, merging, archiving)
- Dev-deploy handles the **infrastructure** (Kamal, staging, production, DB ops)
- The handoff: `dev-workspace deploy push` sends code to the deploy target, then `dev-deploy stage` and `dev-deploy deploy` handle the actual deployment

## Distribution

Dev-workspace is distributed as a Claude Code plugin from the `DBHD-Plugins` marketplace. The plugin bundles the CLI, skill, hooks, and the workspace templates (its `templates/` scaffold). The plugin itself — code and bundled templates — updates through Claude Code's plugin manager.

To get refreshed template files into a project after a plugin update, run `dev-workspace init --update` on the parent branch. It rsyncs the latest scaffold from the installed plugin's `templates/` directory into the project (overwriting changed template files, preserving your content and `workspace-config.yml`); `dev-workspace commit` then propagates them. No git remote is involved — `init`/`init --update` copy directly from the installed plugin.

## Evolution

Dev-workspace started as a hook-based system and is transitioning toward a skill-based architecture. The hook system still works and is actively used, but the skill structure (SKILL.md, scripts, references) is the primary interface. Both coexist in the current version.
