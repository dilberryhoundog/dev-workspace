# Tree — Directory Tree Views for Agent Context

## Purpose

Generate directory tree files that give agents structural awareness of the codebase. The default tree auto-loads at session start, providing an immediate overview. Named trees offer focused views of specific areas, discoverable on demand.

## Command

```bash
dev-workspace tree              # Generate all configured trees (default + named)
dev-workspace tree --show       # List available trees (name + description)
dev-workspace tree help         # Show usage
```

## How It Works

The command reads tree configuration from `workspace-config.yml` and runs the `tree` CLI to generate markdown files with YAML frontmatter. Each tree file contains a name, description, and the directory structure output.

### Default tree → `tree.md`

Always generated. Auto-loaded into agent context via a rules file reference (e.g. `@../../dev/workspace/context/tree.md`). This is the agent's first impression of the codebase — keep it broad but not overwhelming.

### Named trees → `<name>-tree.md`

Optional focused views. Not auto-loaded — agents discover them via `--show` and read specific ones on demand. Use these for deep dives into areas like models, routes, or config that would bloat the default tree.

## Configuration

All tree config lives under the `tree:` section in `workspace-config.yml`.

### Global settings

- **`output_dir`** — Where tree files are written. Default: `dev/workspace/context`
- **`ignores`** — Patterns always excluded from all trees (node_modules, .git, etc.)

### Default tree

```yaml
default_tree:
  name: workspace overview
  description: Core workspace and project structure
  paths:
    - dev/workspace
    - .claude
  # depth: 3          # Comment out for unlimited traversal
  # ignores:          # Appended to global ignores
  #   - "*.log"
```

### Named trees

```yaml
named_trees:
  models:
    name: models
    description: Database models and schema
    paths:
      - app/models
      - db
    depth: 4
```

### Ignore behaviour

Global ignores always apply. Per-tree ignores are additive — they extend the global list, never replace it.

## Frontmatter Format

Every generated tree file includes YAML frontmatter:

```
---
name: workspace overview
description: Core workspace and project structure
---

dev/workspace
├── context
│   └── tree.md
...
```

The `--show` flag reads this frontmatter to list available trees without showing full output.

## When to Run

- **Session start** — via hook to auto-generate fresh trees
- **Mid-session** — after creating/moving files, run `dev-workspace tree` to refresh
- **New project setup** — configure the tree section in workspace-config.yml, then run

## Git Ignore

Tree output files should be git-ignored (they're ephemeral, regenerated each session). The init template includes `*tree.md` in the git_ignore section for the output directory.

## Dependencies

Requires the `tree` CLI tool. The `init --check` command verifies it's installed. If missing:

```
brew install tree     # macOS
apt install tree      # Ubuntu/Debian
```
