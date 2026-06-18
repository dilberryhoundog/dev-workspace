# New Workspace — Kicking Off a Branch

The full kickoff procedure: name the branch, verify readiness, create it, and
initialise the workspace. Work through the steps in order. The `dev-workspace
new` CLI is the engine — it is config-aware (reads `workspace-config.yml` for
`parent_branch`, `main_branch`, and remotes), so prefer it over raw `git`.

## Step 1 — Determine the purpose

Parse the conversation for what the user is working on. If the purpose is not
clear, ask: "What are you working on?" Use the purpose to choose the branch
type and name.

## Step 2 — Build the branch name

Pick a type prefix:

- `feature/` — new features, enhancements (default)
- `fix/` — bug fixes, patches
- `docs/` — documentation changes
- `chore/` — maintenance, tooling, dependencies
- `refactor/` — code restructuring
- `workflow/` — CI/CD, process improvements

Format: `{type}/{sanitized-description}` — lowercase, spaces → hyphens, strip
special characters except hyphens, ~40 characters max. Example:
`fix/login-redirect`.

When the name or type is genuinely ambiguous, confirm it with the user
(AskUserQuestion) before creating — a branch name is awkward to change later.

## Step 3 — Check for existing / similar branches

Run `dev-workspace new` with no name to list branches that originate from the
parent:

```bash
dev-workspace new
```

- If an exact match exists, ask whether to switch to it
  (`git switch <name>`) instead of creating a duplicate.
- If a similarly-named or similar-purpose branch exists, surface it and confirm
  the user really wants a new one.

## Step 4 — Preflight

Verify readiness before creating:

```bash
dev-workspace new <name> --check
```

This reports three gates (config-aware — parent is read from config, not
assumed):

1. **On parent branch** — must be on the configured `parent_branch`. If not,
   switch first.
2. **Working tree clean** — no uncommitted changes. Commit or stash first.
3. **In sync with origin** — local parent not behind origin. If behind, run
   `dev-workspace latest --origin` (or `--upstream` for forks) first.

`--check` exits non-zero and prints a warning for any failed gate. Resolve
failures before continuing. Do not create a branch with a dirty working tree.

## Step 5 — Create the branch

```bash
dev-workspace new <name>
```

This runs `git checkout -b <name> --no-track <parent>`.

The `--no-track` is intentional — it stops the new branch from tracking the
parent, so `git push` won't accidentally push to it. Do not "fix" this.

If `--check` reported the local parent is behind origin and the user still wants
to branch from local state, confirm with them first, then use
`dev-workspace new <name> --force` (skips the sync gate).

## Step 6 — Initialise WORKSPACE.md

New branches inherit the parent's `dev/workspace/` state by design — shared
context (style guides, architectural notes) propagates automatically. This is
not a bug.

Edit `dev/workspace/WORKSPACE.md` for the new branch:

- Set the branch **Name** and **Started** date.
- Mark **Status** as In Progress.
- Expand **Purpose** into a brief statement of the work.
- Set the workflow type and, if tracking GitHub issues, record the issue
  numbers.

Preserve all checkboxes and other structure — only fill in the placeholders.

## Step 7 — Pause, then commit the workspace

Summarise and wait for the user before committing:

```
Branch: <name>
Workspace: dev/workspace/WORKSPACE.md initialised

Pausing for you to review or adjust. Ready to commit the workspace?
```

After they confirm, commit the workspace files:

```bash
dev-workspace commit
```

## After kickoff

- Commit code changes normally with `git`.
- Use `dev-workspace commit` for workspace-only commits.
- Use `dev-workspace push` when ready to share the branch.
