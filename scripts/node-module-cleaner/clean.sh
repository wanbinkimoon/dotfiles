#!/bin/bash

SEARCH_ROOT="$HOME/Developer"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WHITELIST_FILE="$SCRIPT_DIR/whitelist.csv"
LOG_FILE="$SCRIPT_DIR/clean.log"

INTERACTIVE=false
[[ -t 1 ]] && INTERACTIVE=true

DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    $INTERACTIVE && echo "$1"
}

load_whitelist() {
    local -a list=()
    if [[ -f "$WHITELIST_FILE" ]]; then
        while IFS= read -r line; do
            line="${line%%#*}"
            line="$(echo "$line" | xargs)"
            [[ -n "$line" ]] && list+=("$line")
        done < "$WHITELIST_FILE"
    fi
    echo "${list[@]}"
}

is_whitelisted() {
    local target="$1"
    shift
    for entry in "$@"; do
        # Skip if target is inside or directly under a whitelisted path
        [[ "$target" == "$entry"/* || "$target" == "$entry" ]] && return 0
    done
    return 1
}

$DRY_RUN && log "--- DRY RUN (no files will be deleted) ---"
log "--- Starting node_modules cleanup ---"

whitelist=($(load_whitelist))
deleted=0
skipped=0
freed_bytes=0

# Find all node_modules at any depth, but skip searching inside node_modules/
while IFS= read -r -d '' nm_path; do
    if is_whitelisted "$nm_path" "${whitelist[@]}"; then
        log "SKIP (whitelisted): $nm_path"
        ((skipped++))
        continue
    fi

    size=$(du -sk "$nm_path" 2>/dev/null | cut -f1)
    size_mb=$(( size / 1024 ))

    if $DRY_RUN; then
        log "WOULD DELETE (${size_mb}MB): $nm_path"
        ((deleted++))
        ((freed_bytes += size))
    else
        rm -rf "$nm_path"
        if [[ $? -eq 0 ]]; then
            log "DELETED (${size_mb}MB): $nm_path"
            ((deleted++))
            ((freed_bytes += size))
        else
            log "ERROR: Failed to delete $nm_path"
        fi
    fi
done < <(find "$SEARCH_ROOT" -name "node_modules" -type d -prune -print0)

freed_mb=$(( freed_bytes / 1024 ))
log "Done. Deleted: $deleted | Skipped: $skipped | Freed: ~${freed_mb}MB"
log "--- Cleanup finished ---"
