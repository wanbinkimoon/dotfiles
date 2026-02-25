#!/bin/bash

# Script to block Instagram by adding entry to /etc/hosts
HOSTS_FILE="/etc/hosts"
INSTAGRAM_ENTRY="127.0.0.1 instagram.com www.instagram.com"
MARKER="# Instagram block"

# Check if entry already exists
if ! grep -q "$MARKER" "$HOSTS_FILE"; then
    echo "$INSTAGRAM_ENTRY $MARKER" | sudo tee -a "$HOSTS_FILE" > /dev/null
    echo "Instagram blocked at $(date)"
else
    echo "Instagram already blocked"
fi
