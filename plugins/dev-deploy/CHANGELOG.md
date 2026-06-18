# Changelog — dev-deploy

## [1.1.0] — 2026-06-18

### Added
- `dev-deploy version` — reports the version, resolved from plugin.json (single source of truth).
- `dev-deploy health` install checks — plugin scope and stub location, via the pluggable `hooks/health/` runner shared with dev-workspace.
- Plugin dependency declarations so required support skills are bundled on install.

### Changed
- `dev-deploy health` is now a unified, read-only pluggable runner: it discovers every check in `hooks/health/` and reports ✓/⚠/❌ with severity-based exit codes (0 pass / 1 advisory / 2 blocker). The previous app/branch/server checks now run as pluggable checks (`30-kamal-apps`, `40-branch-sync`, `50-server`) alongside the new install checks.
- Documentation updated for plugin-based delivery; removed stale rebuild references.

## [1.0.0] — 2026-06-12

### Added
- Plugin-native init scaffold with `.claude` rule delivery
- CLI stubs, templates, and command references for deployment workflows
