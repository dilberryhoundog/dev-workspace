# conversation-capture → workspace-config (issue #10)

Convert the `conversation-capture` skill to read its config from the per-workspace
`dev/workspace/workspace-config.yml` instead of the bundled (update-volatile)
`config.yml`. Add a graceful guard, wire the dead `include_subagents` toggle, and
move all recovery guidance into SKILL.md (the script stays dumb).

## Principles

- **Script owns detection + exit codes.** No recovery instructions, template
  paths, or agent coaching baked into the script — just terse, standard messages.
- **SKILL.md owns interpretation + recovery.** Agent-facing guidance lives here.
- **Template is the canonical config source.** Live configs and recovery copy
  from it.

## Tasks

### 1. Template — add `conversation_capture:` section
- [x] Append a documented `conversation_capture:` section to
      `plugins/dev-workspace/skills/dev-workspace/templates/workspace-config.yml`.
- [x] Place it last (cosmetic; agent reads the block directly).
- [x] Keys + defaults: `output_dir: dev/workspace/history`,
      `include_thinking: false`, `include_subagents: false`,
      `sanitize: [{find: "$HOME", replace: "~"}]`.
- [x] Document each key in the section's comment banner.

### 2. Live config — mirror into this repo
- [x] Add the same section to `dev/workspace/workspace-config.yml`.

### 3. Script — config source
- [x] Default config path → `<pwd>/dev/workspace/workspace-config.yml`
      (consistent with existing `Dir.pwd` JSONL discovery).
- [x] Scope into the `conversation_capture` section before use.
- [x] Keep the `--config <path>` override.
- [x] Downstream `config.fetch(key, default)` consumers untouched.

### 4. Script — guard (two standard, non-zero exits)
- [x] Config file absent → exit code A, terse message (no `/export`, no
      recovery text).
- [x] `conversation_capture:` section absent → exit code B, terse "missing
      section" message.

### 5. Script — wire `include_subagents`
- [x] Gate `user_agent_result.txt` and `user_agent_background_result.txt` on
      `config.fetch('include_subagents', false)`, mirroring the existing
      `include_thinking` gate. Default `false`.

### 6. Remove bundled config
- [x] Delete `plugins/dev-workspace/skills/conversation-capture/config.yml`.

### 7. SKILL.md
- [x] Fix invocation path to
      `${CLAUDE_PLUGIN_ROOT}/scripts/conversation-capture`.
- [x] Rewrite Config section to describe `workspace-config.yml`.
- [x] Recovery for exit B: read the `conversation_capture:` block (banner +
      comments + values) from the plugin template and append it to
      `dev/workspace/workspace-config.yml`, then re-run.
- [x] Recovery for exit A: one line — skill is dev-workspace-only.
- [x] Update `allowed-tools` frontmatter if needed.

### 8. Verify
- [x] Happy path: run against the current session → transcript written.
- [x] Exit A: run outside a workspace config → correct code + message.
- [x] Exit B: temporarily remove the section → correct code + message.
- [x] Clean up any stray test transcript artifacts.
