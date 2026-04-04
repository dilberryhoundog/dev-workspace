# Push — Pushing Branches

## Workflow

```
dev-workspace push --check               # See push status first
dev-workspace push                       # Push to origin
```

## Check Output Meanings

- **"Already up to date"** — Nothing to push. No action needed.
- **"X commit(s) to push"** — Normal state. Safe to push.
- **"Diverged: X ahead, Y behind"** — Local and remote have different histories. This happens after rebase, amend, or reset. Needs force push.
- **"New branch"** — First push. Will create remote tracking branch automatically.

## Standard Push

`dev-workspace push` runs `git push -u origin <branch>`. The `-u` sets up tracking on first push so subsequent pushes just work.

Any local branch pushes to its matching origin branch: `feature/login` pushes to `origin/feature/login`, `main` pushes to `origin/main`, `command` pushes to `origin/command`.

## Force Push

`dev-workspace push --force-w-l` uses `git push --force-with-lease`. This is a safe force push — it only overwrites the remote if nobody else has pushed since your last fetch.

**When force push is appropriate:**

- After `dev-workspace sync --rebase` (rebasing rewrites history)
- After `git commit --amend` (amending changes the commit hash)
- After `git rebase -i` (interactive rebase)
- After any operation that rewrites commit history

**When force push is NOT appropriate:**

- On shared branches where others are actively pushing
- When you haven't fetched recently (run `push --check` first)

## Safety

No artificial branch protection. Both fork and vanilla repos push to origin safely. Standard git protection applies:

- Push is rejected if remote is ahead (pull first or force)
- `--force-with-lease` fails if remote has changed since last fetch

The agent should always run `push --check` first. If divergence is reported, confirm with the user before using `--force-w-l`.
