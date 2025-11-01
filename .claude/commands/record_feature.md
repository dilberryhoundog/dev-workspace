---
name: Record Feature
description: Create a feature record for a completed feature by analyzing git history and documenting implementation details.
---

Create a feature record for the feature: $ARGUMENTS

1. Use `git log --oneline main` to identify commits related to this feature
2. Use `git show --stat` and `git show` on relevant commits to understand the feature's purpose and scope
3. Analyze the changed files to understand the feature's purpose and how the feature integrates with the existing system
4. Create a new feature record in `docs/features/completed/` using the template structure:
    - Use a descriptive filename based on the feature name
    - Fill in Overview section with a concise description of what the feature does and its purpose
    - Fill in Integration section explaining how it connects with existing code
    - List all new files created in Files Created section, organized by type (**controllers** **models** **views** etc.)
    - List significant changes to existing files in Files Changed section, also organized by type
5. Keep the record concise and focused on the essential information
