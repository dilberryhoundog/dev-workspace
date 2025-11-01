---
description: edit a markdown file, using embedded comments.
---

Edit a markdown file based on inline comments.

Look for comment blocks in @$ARGUMENTS that follow this format:
> ⚠️ [comment describing what needs to be changed]

Your task:
1. Read the file referenced by @$ARGUMENTS
2. Find all comment blocks starting with `> ⚠️`
3. Make the requested changes described in each comment
4. Remove the comment blocks after implementing the changes
5. Keep all other content unchanged

Make precise, surgical edits based exactly on what each comment requests. Do not add explanations or summaries - just make the changes and remove the comments.
