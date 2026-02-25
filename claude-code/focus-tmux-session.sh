#!/bin/bash

# Focus script for Claude Code notifications
# This script activates the terminal and switches to the specified tmux session

SESSION="$1"
LOG_FILE="$HOME/.cache/claude-code/focus.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Log the focus attempt
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Focus request for session: $SESSION" >> "$LOG_FILE"

# Activate Ghostty terminal
if osascript -e 'tell application "Ghostty" to activate' 2>/dev/null; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Successfully activated Ghostty" >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed to activate Ghostty" >> "$LOG_FILE"
    exit 1
fi

# Wait a moment for terminal to activate
sleep 0.2

# Switch to tmux session if in tmux and session is known
if [ -n "$TMUX" ] && [ "$SESSION" != "unknown" ] && [ -n "$SESSION" ]; then
    if tmux switch-client -t "$SESSION" 2>/dev/null; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Successfully switched to session: $SESSION" >> "$LOG_FILE"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed to switch to session: $SESSION (session may not exist)" >> "$LOG_FILE"
    fi
else
    if [ -z "$TMUX" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Not running in tmux, only activated terminal" >> "$LOG_FILE"
    elif [ "$SESSION" = "unknown" ] || [ -z "$SESSION" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Session name unknown, only activated terminal" >> "$LOG_FILE"
    fi
fi
