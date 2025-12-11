# Workspace

## Guidance

Workspaces are Claude's primary source of truth. Prioritise searching and revealing workspace knowledge before focusing directly on the codebase. Some important places:

- **`/context`** - Discoveries, resources, and other contextual information
- **`/history`** - Conversations with Claude, very useful to run searches in.
- **`/filebox`** - Temporary file location, store snippets,
- **`/plans`** - structured planning documents
- **`/research`** - May contain useful research artifacts
- **`/reviews`** - May contain reviews of completed work
- **`/tasks`** - Tasks to complete, may contain instructions for Claude

## Search Chat History

Each Chat History file has a max 5 line summary near the top of the file, and a descriptive file name. These names and summaries can be easily searched using grep, the files are named with a date and the descriptive name, the summary format is:

    [SUMMARY]
    >>>
    "The summary of the conversation is here"
    <<<
