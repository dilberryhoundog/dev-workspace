# What Dev Workspace Is

Dev-workspace incorporates agent collaboration into codebases. It solves the problem of context pollution — when an AI agent works on multiple features in the same repo, plans, conversations, discoveries, and working notes from one feature leak into the context of another.

## The Core Problem

You're building an auth system. Claude has accumulated plans, architectural decisions, debugging notes, and conversation history about auth. Now you need to switch to the admin panel. All that auth context is still there — polluting Claude's focus, wasting context window, and confusing priorities.

## The Solution

Dev-workspace isolates working context per branch while letting code flow freely.

Every project gets a `dev/workspace/` directory that holds everything the agent needs for the current task: plans, context files, conversation history, research, reviews, and task tracking. When you create a new branch with `dev-workspace new auth-system`, that workspace inherits from the parent and becomes the agent's dedicated working space for auth.

When you switch to `dev-workspace new admin-panel`, the agent gets a clean workspace for admin work. Auth's plans, history, and context stay on the auth branch. Invisible.

## Two Layers

There are two layers to every dev-workspace project:

**Code (shared)** — Source code, configs, tests. These merge normally between branches. Work done on the auth branch reaches the admin branch through standard push -> merge -> sync. The agent on the admin branch can see and use auth's completed code.

**Workspace context (isolated)** — Everything in `dev/workspace/`. Plans, conversations, history, discoveries, research, reviews, tasks. This is protected by a git merge driver that always keeps the current branch's version during merges. Auth's workspace context never overwrites admin's, and vice versa.

The work is common. The context is not.

## Archives

Context is isolated while working — but not lost forever. The archive system (`dev-workspace archive`) snapshots a branch's workspace into `dev/branches/`, which is committed to git and visible from every branch. When auth is complete and the branch is deleted, the full working context is preserved and searchable from any branch.

This matters when work crosses boundaries. Auth decisions might affect admin. A debugging discovery on one branch might solve a problem on another. Archives make this accessible without breaking isolation during active work.

## What It Replaces

Without dev-workspace, teams either:
- Work on one thing at a time (slow)
- Let context accumulate across branches (polluted)
- Manually manage context files (error-prone)
- Start fresh conversations every session (losing valuable context)

Dev-workspace makes parallel agent work practical by automating the context boundary.
