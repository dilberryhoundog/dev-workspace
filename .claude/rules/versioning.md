# Versioning Config

Read by the versioning skill. Defines this repository's versioned units.

## Units

### dev-workspace
- paths: plugins/dev-workspace
- manifest: plugins/dev-workspace/.claude-plugin/plugin.json (field: version)
- changelog: plugins/dev-workspace/CHANGELOG.md
- tag: dev-workspace/v{version}
- github-release: yes

### dev-deploy
- paths: plugins/dev-deploy
- manifest: plugins/dev-deploy/.claude-plugin/plugin.json (field: version)
- changelog: plugins/dev-deploy/CHANGELOG.md
- tag: dev-deploy/v{version}
- github-release: yes
