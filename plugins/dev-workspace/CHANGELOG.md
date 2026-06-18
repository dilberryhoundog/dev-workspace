# Changelog — dev-workspace

## [1.1.0] — 2026-06-18

### Added
- `dev-workspace health` — advisory, read-only plugin install-health check that runs pluggable checks from `hooks/health/` and reports ✓/⚠/❌ findings. Ships two checks: plugin install scope and stub location.
- `new-workspace` skill — scaffolds a new workspace branch with preflight validation.
- Plugin dependency declarations so required support skills are bundled on install.

### Changed
- Documentation updated for plugin-based delivery; removed stale rebuild references.

## [1.0.0] — 2026-06-12

### Added
- Full CLI command suite: push, sync, merge, commit, archive, new, init, tree, cleanup, deploy, rebuild
- `new-workspace` command for branch setup with CLAUDE.md initialisation
- Plugin-native init scaffold with `.claude` rule delivery
- CLI stubs, templates, and command references for workspace management

### Fixed
- Plugin hooks correctly wrapped in `hooks` group array
