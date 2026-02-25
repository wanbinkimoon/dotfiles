#!/bin/bash
# Unified notification script for Claude Code
# Handles all notification types: macOS notification, audio, tmux status, and terminal bell

set -euo pipefail

# Configuration
NOTIFICATION_MESSAGE="${1:-Claude Code needs your input}"
LOG_FILE="$HOME/.cache/claude-code/notifications.log"
TMUX_HOOK_SCRIPT="$HOME/.config/tmux/plugins/tmux-claude-status/hooks/better-hook.sh"
mkdir -p "$(dirname "$LOG_FILE")"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE" 2>&1
}

log "=== Notification triggered: $NOTIFICATION_MESSAGE ==="

# 1. Update tmux status
if [ -f "$TMUX_HOOK_SCRIPT" ] && [ -x "$TMUX_HOOK_SCRIPT" ]; then
    if echo '{}' | "$TMUX_HOOK_SCRIPT" Notification 2>&1; then
        log "✓ tmux status updated"
    else
        log "✗ tmux status update failed"
    fi
else
    log "✗ tmux hook script not found or not executable"
fi

# 2. Display macOS notification
if command -v osascript >/dev/null 2>&1; then
    if osascript -e "display notification \"$NOTIFICATION_MESSAGE\" with title \"Claude Code\"" 2>&1; then
        log "✓ macOS notification displayed"
    else
        log "✗ macOS notification failed"
    fi
else
    log "✗ osascript not found"
fi

# 3. Play audio alert - DISABLED (using TF2 sounds instead)
# Audio is handled by tf2-hooks.sh
log "✓ Audio alert skipped (handled by tf2-hooks.sh)"

# 4. Send terminal bell
if printf '\a' > /dev/tty 2>&1; then
    log "✓ Terminal bell sent"
else
    log "✗ Terminal bell failed"
fi

log "=== Notification complete ==="
exit 0
