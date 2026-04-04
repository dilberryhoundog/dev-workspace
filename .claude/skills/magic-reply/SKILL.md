---
name: magic-reply
description: When you see a phrase surrounded by `--` in a user response (eg `-- show working --`), STOP and read the magic-reply skill. DO NOT reply until the skill guides you.
---

## How It Works

Find the trigger phrase between the delimiters. In the trigger map, read the matching reference file and follow the instructions for that turn only. Resume normal behaviour on the next turn.  
Example:
`-- show working --`  = Read the .txt template in `###  show working / show your working` section.

## Delimiter

`--` <trigger phrase> `--`
This is the delimiter pattern to match on. handle minor errors like no space between phrase and delimiter.

## Trigger Map

| Trigger phrase                                 | Reference Section                  | Purpose                                                  |
|------------------------------------------------|------------------------------------|----------------------------------------------------------|
| "show strategy" / "show your strategy"         | `references/show-strategy.txt`     | Explain the process you'll follow to complete the task   |
| "show working" / "show your working"           | `references/show-working.txt`      | Show your thinking, ideas, and implementation plan       |
| "show context" / "show your context"           | `references/show-context.txt`      | Reveal what files, docs, and knowledge you need          |
| "show options" / "show your options"           | `references/show-options.txt`      | Present solution variants (basic, advanced, alternative) |
| "show difficulties" / "show your difficulties" | `references/show-difficulties.txt` | Analyse conversation difficulties                        |
| "check working" / "check your working"         | `references/check-working.txt`     | Review and verify your completed work                    |
| "use claude space" / "use your claude space"   | `references/claude-space.txt`      | Free-form thinking space for the agent                   |

## Context Building

If the user's task or message requires some context gathering (like searching for files, web search, agent exploration etc). You are free to conduct these tools calls silently without interacting with the user. You can give a very small indicator (if your system allows progressive replies) that you are building context and you will be providing their magic reply very soon.

Once your context is collected. Reply ONLY with the user's requested reply style. Be thorough in your reply, the user will be very pleased with a high effort reply in the manner they requested.

## Help

Any time a phrase is found between the delimiters, without a matching template. Respond with a list of all the available triggers phrases. This handles...

1. Unsuccessful attempts to match a trigger phrase, like using a word that is not a trigger phrase.
2. As a help prompt, whereby the user might need refreshing their memory of the available triggers.
3. When the skill is prompted but no phrase exists.

examples:
`-- show plan --`  = not a valid phrase, show list of available triggers.
`-- triggers? --`  = help request, show list of available triggers.

## Rules

- **One turn only** — follow the guide for this response, then return to normal
- **Read the file** — don't paraphrase from memory, read the actual reference file each time
- **Trigger matching** — case-insensitive, match anywhere in the user's message
- **Multiple triggers** — if multiple phrases appear, Alert the user to the ambiguity and ask them to try again with only one magic-reply trigger word.

## The Magic

These triggers truly are magic, they progressively shape and reveal context that would never be revealed through standard conversations. When chained together over a few separate replies these responses will leave a trail of magic in the context window, that will give you superpowers. Embrace this.

------
