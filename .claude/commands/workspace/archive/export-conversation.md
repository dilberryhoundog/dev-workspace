---
name: Export Conversation
description: Save conversation to workspace history with auto-generated name
allowed-tools:
argument-hint: [ optional: custom/path/filename.txt ]
---

Generate a filename and prompt user to export conversation.

**Note:** Claude cannot invoke `/export` directly - user must run it.

## Instructions

### 1. Check for Previous Export

Look through conversation for prior `/export` that saved a `.txt` file:

- Pattern: "Conversation exported to: [path]"
- If found, reuse that exact path (enables overwrite/update)
- Skip to step 3 if found

### 2. Generate Filename (if no previous export)

**Format:** `YY-MM-DD_descriptive-kebab-case-name.txt`

- Date: Today's date
- Name: 3-6 words capturing the main conversation topic
- Example: `26-01-10_export-command-skill-creation.txt`

**Determine full path:**

- If `$ARGUMENTS` is a full path with `.txt` → use as-is
- If `$ARGUMENTS` ends with `/` or no extension → append generated filename
- If `$ARGUMENTS` empty → use `dev/workspace/history/[filename]`

### 3. Prompt User

Display the command:

```
/export [full-path-to-file]
```

## Arguments

$ARGUMENTS
