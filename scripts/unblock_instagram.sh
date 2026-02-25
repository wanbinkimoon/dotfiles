#!/bin/bash

# Script to unblock Instagram by removing entry from /etc/hosts
HOSTS_FILE="/etc/hosts"
MARKER="# Instagram block"

# Remove the Instagram block entry
sudo sed -i '' "/$MARKER/d" "$HOSTS_FILE"
echo "Instagram unblocked at $(date)"
