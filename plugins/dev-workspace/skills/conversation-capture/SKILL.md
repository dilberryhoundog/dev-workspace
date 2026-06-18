---
name: conversation-capture
description: "Capture current session transcript to workspace history. Use at session end or when preserving conversation context."
allowed-tools: Bash(ruby *conversation-capture *), Bash(mv *), Read, Edit
---

# conversation-capture

Parse the current Claude Code session JSONL into a formatted, readable transcript. Summarize and rename the output file.

## Agent invariants

- Do not `cd` into any directory, all commands can be run from `pwd`

## Session Id

SESSION_ID = ${CLAUDE_SESSION_ID}

## Capture

Run the extraction script with the current session ID:

```bash
ruby ${CLAUDE_PLUGIN_ROOT}/skills/conversation-capture/scripts/conversation-capture <SESSION_ID>
```

On success the script outputs one line: the transcript file path. Continue to
**Summarize and Rename**.

If the script exits non-zero, handle it per **Config not ready** below — do not
proceed.

## Config not ready

The skill reads its settings from the workspace config and only runs inside a
dev-workspace. Two non-zero exits signal a config problem:

- **Exit 3 — no workspace config.** There is no `dev/workspace/workspace-config.yml`.
  This skill is for dev-workspace projects only. Stop and tell the user.
- **Exit 4 — missing section.** The config exists but has no `conversation_capture:`
  section (an older workspace). Recover it:
  1. Read the `conversation_capture:` block — its comment banner and values —
     from `${CLAUDE_PLUGIN_ROOT}/skills/dev-workspace/templates/workspace-config.yml`.
  2. Append that block to the project's `dev/workspace/workspace-config.yml`.
  3. Re-run the capture script.

## Summarize and Rename

Using the full conversation context.

**Summary:** Write a 3-5 line summary of the conversation. The summary must be:

- **Global scope** — readable without access to the conversation
- **Factual** — what was discussed, what was built/fixed, key decisions, what remains
- **No session-specific language** — avoid "the user asked me to", "I was told to"

Read the first 20 lines of the transcript file to locate the `[SUMMARY]` block. Insert the summary between the `>>>` and `<<<` markers using the Edit tool. If the block already has content, replace it.

**Rename:** Check the transcript filename.

- If it contains a raw UUID (e.g. `f5d11e2f_f5d11e2f-89c8-...txt`), rename it with a descriptive slug
- If it already has a descriptive name, keep it if still accurate, rename if the conversation has shifted focus

Rename format: `<first-8>_slug.txt` where slug is 3-6 word kebab-case topic description.

```bash
mv "<transcript-file>" "<output-dir>/<first-8>_slug.txt"
```

Report the final transcript file path.

## Config

Settings live in the workspace config — `dev/workspace/workspace-config.yml`,
under the `conversation_capture:` section. The user edits this file directly; no
re-enable step. Keys:

- `output_dir` — target directory for transcripts (relative to project root)
- `include_thinking` — include assistant thinking blocks (`true`/`false`)
- `include_subagents` — include subagent results (`true`/`false`)
- `sanitize` — list of find/replace patterns applied after extraction. `$ENV_VAR` references expand at runtime. Comment out patterns with `#` to disable

A `--config <path>` flag overrides the config file location (the section scope is
unchanged).

## Resume Behaviour

The script uses the first 8 characters of the session ID as a file prefix. On re-invocation with the same session ID, it detects and overwrites the existing transcript — preserving the renamed filename if already processed.
