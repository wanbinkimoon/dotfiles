#!/bin/bash

# Wrapper script to extract context (tmux session, folder) and pass to notify.sh
# Reads JSON from stdin (provided by Claude Code hooks)

# Get tmux session name
SESSION="unknown"
if [ -n "$TMUX" ]; then
  # Primary method: use tmux display-message
  if command -v tmux &> /dev/null; then
    SESSION=$(tmux display-message -p '#{session_name}' 2>/dev/null || echo "unknown")
  fi

  # Fallback: parse $TMUX variable (format: /tmp/tmux-uid/session,pid,window)
  if [ "$SESSION" = "unknown" ] && [ -n "$TMUX" ]; then
    TMUX_SOCKET=$(echo "$TMUX" | cut -d',' -f1)
    SESSION=$(basename "$TMUX_SOCKET" 2>/dev/null || echo "unknown")
  fi
fi

# Read JSON from stdin and extract folder name
JSON_INPUT=$(cat)
CWD="unknown"
FOLDER="unknown"

if command -v jq &> /dev/null && [ -n "$JSON_INPUT" ]; then
  # Extract cwd from JSON, fallback to PWD, then "unknown"
  CWD=$(echo "$JSON_INPUT" | jq -r '.cwd // env.PWD // "unknown"' 2>/dev/null || echo "unknown")
  if [ "$CWD" != "unknown" ]; then
    FOLDER=$(basename "$CWD" 2>/dev/null || echo "unknown")
  fi
fi

# Fallback to PWD if JSON parsing failed
if [ "$FOLDER" = "unknown" ] && [ -n "$PWD" ]; then
  FOLDER=$(basename "$PWD" 2>/dev/null || echo "unknown")
fi

# Call notify.sh with session and folder context
~/.config/claude-code/notify.sh "$SESSION" "$FOLDER"
