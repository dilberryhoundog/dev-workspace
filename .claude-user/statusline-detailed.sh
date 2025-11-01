#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
style=$(echo "$input" | jq -r '.output_style.name')

# Get git branch (skip locks for safety)
cd "$dir" 2>/dev/null
git_branch=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git_branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$git_branch" ]; then
        # Check for uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            git_branch="$git_branch*"
        fi
        git_branch="[$git_branch]"
    fi
fi

# Format the status line with colors (dimmed in terminal)
dir_name=$(basename "$dir")
printf "\033[36m%s\033[0m %s\033[32m%s\033[0m | \033[35m%s\033[0m | \033[33m%s\033[0m" \
    "$dir_name" "$git_branch" "" "$model" "$style"