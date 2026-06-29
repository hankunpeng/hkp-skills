#!/bin/bash
# Claude Code Custom Statusline
# Output: ~/path | CW: X% | Model Name
input=$(cat)
dir=$(echo "$input" | jq -r '.workspace.current_dir')
dir=$(echo "$dir" | sed "s|^$HOME|~|")
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  printf '%s | CW: %s%% | %s' "$dir" "$used" "$model"
else
  printf '%s | %s' "$dir" "$model"
fi
