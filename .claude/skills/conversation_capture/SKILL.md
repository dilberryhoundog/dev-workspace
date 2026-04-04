---
name: conversation-capture
description: "Capture current session transcript to workspace history. Use at session end or when preserving conversation context."
allowed-tools: Bash(ruby *conversation-capture *), Bash(mv *), Read, Edit, Update
---

# conversation-capture

Parse the current Claude Code session JSONL into a formatted, readable transcript. Summarize and rename the output file.

## Session Id
SESSION_ID = ${CLAUDE_SESSION_ID}

## Capture

Run the extraction script with the current session ID:

```bash
ruby skills/conversation_capture/scripts/conversation-capture <SESSION_ID>
```

The script outputs one line: the transcript file path.

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

Settings in `skills/conversation_capture/config.yml`:

- `output_dir` — target directory for transcripts (relative to project root)
- `include_thinking` — include assistant thinking blocks (`true`/`false`)
- `include_subagents` — include subagent results (`true`/`false`)
- `sanitize` — list of find/replace patterns applied after extraction. `$ENV_VAR` references expand at runtime. Comment out patterns with `#` to disable

## Resume Behaviour

The script uses the first 8 characters of the session ID as a file prefix. On re-invocation with the same session ID, it detects and overwrites the existing transcript — preserving the renamed filename if already processed.
