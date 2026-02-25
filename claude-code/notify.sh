#!/bin/bash
# Claude Code notification script for macOS
# Displays native macOS notifications when Claude needs input

set -euo pipefail

# Configuration
SESSION="${1:-unknown}"
FOLDER="${2:-unknown}"
LOG_FILE="$HOME/.cache/claude-code/notifications.log"
ICON_PATH="$HOME/.cache/claude-code/icon.png"

mkdir -p "$(dirname "$LOG_FILE")"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE" 2>&1
}

# Build context-aware message
if [ "$SESSION" != "unknown" ] && [ "$FOLDER" != "unknown" ]; then
    NOTIFICATION_MESSAGE="Input needed in [$SESSION] - $FOLDER"
elif [ "$SESSION" != "unknown" ]; then
    NOTIFICATION_MESSAGE="Input needed in [$SESSION]"
elif [ "$FOLDER" != "unknown" ]; then
    NOTIFICATION_MESSAGE="Input needed in $FOLDER"
else
    NOTIFICATION_MESSAGE="Claude Code needs your input"
fi

# Main notification logic
# Use terminal-notifier (installed via Homebrew)
if command -v terminal-notifier >/dev/null 2>&1; then
    FOCUS_SCRIPT="$HOME/.config/claude-code/focus-tmux-session.sh"

    if terminal-notifier -title "Claude Code" \
        -message "$NOTIFICATION_MESSAGE" \
        -execute "$FOCUS_SCRIPT '$SESSION'" >/dev/null 2>&1; then
        log "SUCCESS: Notification with click action - $NOTIFICATION_MESSAGE (Session: $SESSION, Folder: $FOLDER)"
        exit 0
    else
        log "WARNING: terminal-notifier failed, falling back to osascript"
    fi
fi

# Fallback to osascript
if command -v osascript >/dev/null 2>&1; then
    if osascript -e "display notification \"$NOTIFICATION_MESSAGE\" with title \"Claude Code\" sound name \"\"" 2>&1; then
        log "SUCCESS: Notification displayed with osascript - $NOTIFICATION_MESSAGE (Session: $SESSION, Folder: $FOLDER)"
        exit 0
    else
        log "ERROR: osascript failed to display notification"
        exit 1
    fi
else
    log "ERROR: No notification method available (terminal-notifier or osascript)"
    exit 1
fi
