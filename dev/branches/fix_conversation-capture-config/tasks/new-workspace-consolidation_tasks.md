# Consolidate workspace kickoff onto the dev-workspace CLI

Retire the standalone `new-workspace` skill and merge its agent-facing kickoff
instructions into the dev-workspace skill's progressive-disclosure reference
(`references/new-workspace.md`). One config-aware engine (`dev-workspace new`),
one place for the how-to, nothing redundant in always-on rules.

## Principles

- **Rules engage, they don't instruct.** The always-on guide only triggers
  "starting a fix → create a workspace". Step-by-step lives in the reference
  (read on demand) to avoid token bloat.
- **CLI is the single engine.** `dev-workspace new` is config-aware
  (reads workspace-config.yml); the retired skill's scripts were config-blind
  (hardcoded main/command/origin/fork).
- **Progressive disclosure:** rules → SKILL.md routes → reference instructs.

## Tasks

### 1. CLI — no change (text preflight)
- [x] DECISION: `--check --json` is unimplemented across the whole CLI
      (advertised in help/cookbook but vaporware). Do NOT build it here —
      out of scope for this consolidation.
- [x] Kickoff uses the existing text commands: `dev-workspace new` (list
      branches for similar-name detection) and `new <name> --check`
      (readiness report, human-readable, parseable by the agent).

### 2. Reference — rewrite as the merged kickoff guide
- [x] Rewrite `plugins/dev-workspace/skills/dev-workspace/references/new-workspace.md`
      as a Claude-audience kickoff doc, folding in the skill's value:
  - [x] branch-type prefixes + naming/sanitisation convention,
  - [x] AskUserQuestion-driven naming when purpose is unclear,
  - [x] preflight evaluation order (run `new <name> --check`, read output),
  - [x] similar-branch detection from `dev-workspace new` branch listing,
  - [x] WORKSPACE.md initialisation (name, date, purpose, issue tracking),
  - [x] confirm-before-`--force`,
  - [x] keep the "do not 'fix' `--no-track`" and "workspace files transfer by
        design" warnings.
- [x] Fix staleness: `dev/workspace/CLAUDE.md` → `WORKSPACE.md`.
- [x] De-cookbook the prose so it reads as agent guidance, not a command echo.

### 3. SKILL.md — route to the reference
- [x] Update the `references/new-workspace.md` entry in
      `plugins/dev-workspace/skills/dev-workspace/SKILL.md` with a clear
      "Read before kicking off a new workspace" trigger line.

### 4. Retire the standalone skill
- [x] Delete `plugins/dev-workspace/skills/new-workspace/` (SKILL.md +
      scripts/preflight + scripts/create-branch).
- [x] Confirm no remaining references to the skill or its scripts
      (grep `new-workspace/scripts`, `skills/new-workspace`).

### 5. Cookbook — no change
- [x] No `--json` row added (flag is unimplemented; not introducing it).
      The existing `new` rows already cover the kickoff commands.

### 6. Parity + verify
- [x] Confirm nothing the skill did is lost (naming, preflight, WORKSPACE.md
      init, similar-branch, force confirmation all present in the reference).
- [x] Confirm the always-on guide still engages kickoff without carrying the
      how-to.
- [x] Dry-run the kickoff path mentally/again to ensure the reference is
      self-sufficient for an agent with no prior context.
