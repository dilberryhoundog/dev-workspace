# Cleanup — Conversation Export Processing

## Purpose

Process conversation exports from agent platforms into workspace history. The script detects exports and lists existing history — you do the thinking: compare, summarize, rename, and file.

## Command

```bash
dev-workspace cleanup claude-code     # Scan for Claude Code exports
dev-workspace cleanup                 # List available platforms
```

## Processing Workflow

### 1. Run the cleanup command

Run `dev-workspace cleanup <platform>` to get a report of exports found and existing history files.

### 2. Check for duplicates

For each export, read the first ~50 lines to understand the conversation topic. Then check the history list for files with similar dates or topics. If a suspect exists, read its first ~50 lines too.

Determine for each export:
- **New** — no matching history file. Process it.
- **Duplicate** — same conversation, already captured at similar length. Delete the export.
- **Update** — same conversation but the export has substantially more content. Replace the history file.

### 3. Process new conversations

For each new export:

1. Read the full export to understand the conversation
2. Generate a 3-5 line summary capturing what was discussed and accomplished
3. Choose a descriptive filename slug (lowercase, hyphens, no dates in slug)
4. Rename to `YYYY-MM-DD-descriptive-slug.txt` (use the date from the export filename)
5. Prepend a header block at the top of the file:

```
[SUMMARY]
>>>
"Your 3-5 line summary here"
<<<
PLATFORM: claude-code
```

6. Move the file to `dev/workspace/history/`

### 4. Process updates

If an export is an update to an existing history file:

1. Replace the history file with the export
2. Re-generate the summary (more content means the summary should be updated)
3. Keep the same filename if the topic hasn't changed
4. Apply the header block as above

### 5. Clean up

Delete any exports that were duplicates (already captured, no new content).

## When to Run

- **End of session** — before closing, offer to capture the conversation
- **Export seen in chat** — when `/export` command output appears, run cleanup
- **Session start** — check for orphaned exports from previous sessions that weren't processed
- **On request** — when the user asks to capture or clean up conversations

## Summary Guidelines

Write summaries with global scope — a reader should understand the conversation without access to the chat transcript. Include:
- What was discussed or decided
- What was built, fixed, or changed
- Key discoveries or decisions made
- What's left to do (if anything)

Avoid session-specific language ("the user asked me to...", "in this chat we...").

## File Naming

- Format: `YYYY-MM-DD-descriptive-slug.txt`
- Use the date the conversation started (from export filename)
- Slug should describe the topic, not the action ("skills-catalog-import" not "importing-skills")
- Keep slugs under 50 characters
- Use hyphens, lowercase only
