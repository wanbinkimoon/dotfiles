#!/bin/bash

# Script to check time and apply correct Instagram blocking state
# Blocks between 9:00 and 18:00 on weekdays, unblocks outside those hours

HOSTS_FILE="/etc/hosts"
INSTAGRAM_ENTRY="127.0.0.1 instagram.com www.instagram.com"
MARKER="# Instagram block"

# Note: This redirects Instagram to localhost:8888 where our block page is served

# Get current hour (0-23) and day of week (1=Monday, 7=Sunday)
CURRENT_HOUR=$(date +%H)
CURRENT_DAY=$(date +%u)

# Remove leading zero for comparison
CURRENT_HOUR=$((10#$CURRENT_HOUR))

# Check if it's a weekday (Monday=1 to Friday=5)
if [ "$CURRENT_DAY" -ge 1 ] && [ "$CURRENT_DAY" -le 5 ]; then
    # Weekday: check if we're in blocking hours (9-17, blocks at 9, unblocks at 18)
    if [ "$CURRENT_HOUR" -ge 9 ] && [ "$CURRENT_HOUR" -lt 18 ]; then
        # Should be blocked
        if ! grep -q "$MARKER" "$HOSTS_FILE"; then
            echo "$INSTAGRAM_ENTRY $MARKER" | sudo tee -a "$HOSTS_FILE" > /dev/null
            echo "$(date): Instagram blocked (weekday working hours)"
        else
            echo "$(date): Instagram already blocked"
        fi
    else
        # Should be unblocked (before 9 or after 18)
        if grep -q "$MARKER" "$HOSTS_FILE"; then
            sudo sed -i '' "/$MARKER/d" "$HOSTS_FILE"
            echo "$(date): Instagram unblocked (outside working hours)"
        else
            echo "$(date): Instagram already unblocked"
        fi
    fi
else
    # Weekend: should always be unblocked
    if grep -q "$MARKER" "$HOSTS_FILE"; then
        sudo sed -i '' "/$MARKER/d" "$HOSTS_FILE"
        echo "$(date): Instagram unblocked (weekend)"
    else
        echo "$(date): Instagram already unblocked (weekend)"
    fi
fi
