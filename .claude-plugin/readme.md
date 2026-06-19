# Dev Workspace — Plugin Marketplace

A focused **Claude Code** marketplace for the Dev Workspace toolset — a deliberate agent-context system for coding sessions, packaged and delivered from one place.

## Purpose

Dev Workspace gives Claude (and you) a clean, consistent, per-branch home for every piece of context a coding session produces — plans, research, reviews, conversations, scratch files and discoveries — then makes that context easy to store, sync, share and reveal. This marketplace packages that system into installable, versioned plugins and keeps them current.

## Quickstart

Register this marketplace in Claude Code, then install whatever you want from it.

1. Run `/plugins`.
2. Open the **Marketplaces** tab and choose **Add marketplace**.
3. Use the green **Code** button above to copy the URL.
4. Paste this repository's URL into the marketplace dialog.

Then open the **Plugins** tab and install any — or all — of the plugins on offer. Plugins update themselves as new versions ship.

## What's on offer

- **dev-workspace** — managing agent context: efficient git commands, conversation capture, context shaping, and a fast per-branch CLI.
- **dev-deploy** — a companion to dev-workspace for efficient deployment with Kamal.

## Plugin packaging

Plugins are packaged using Claude's official plugin format to bundle loose assets into coherent, versioned collections ready for delivery. Assets are symlinked into the plugin rather than copied, so the source of truth stays with the asset itself — lifting the maintenance burden off the plugin.

## Advantages

- **A single source of truth** for the Dev Workspace assets.
- **Easy versioning and updating** of everything installed.
- **Clean working directories**, since each project's `.claude/` stays minimal.
- **Conceptually packaged assets** — pull them in where they're needed, leave them out where they're not.
