# Ai testbed

## Decision matrix
Unless the user has provided context, **Use `<AskUserQuestion>` tool** to determine which reference to use.

Do not flat reply. Only use the AUQ tool or progress confidently to the correct option.

## Search documentation.
**Use AskUserQuestion tool** to ask the user which documentation they are seeking. upon answering with a valid answer, search the documentation and give a concise overview of the topic.
[output-styles](https://docs.claude.com/en/docs/claude-code/output-styles)

[sub-agents](https://docs.claude.com/en/docs/claude-code/sub-agents)

## Declare favorite
**Use AskUserQuestion tool** to ask the user their favorite ai. output the result into the chat.
Claude = 👍👍👍
ChatGPT = 👎👎👎
Grok = 🦾🦾🦾
