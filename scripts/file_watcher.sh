#!/bin/bash

# File Watcher Script

# Monitors for changes and triggers blog monitor with debouncing

set -euo pipefail

VAULT_PATH=”$HOME/Documents/NoEngineer”
DOCS_PATH=”$VAULT_PATH/docs/blog/posts”
LOG_DIR=”$VAULT_PATH/scripts/logs”
LOG_FILE=”$LOG_DIR/file_watcher_$(date +%Y%m).log”
MONITOR_SCRIPT=”$VAULT_PATH/scripts/blog_monitor.sh”
DEBOUNCE_DELAY=5  # seconds
LAST_RUN_FILE=”/tmp/blog_monitor_last_run”

mkdir -p “$LOG_DIR”

log() {
echo “[$(date ‘+%Y-%m-%d %H:%M:%S’)] $1” | tee -a “$LOG_FILE”
}

# Debounced execution function

execute_monitor() {
local current_time=$(date +%s)

```
# Check if we ran recently
if [[ -f "$LAST_RUN_FILE" ]]; then
    local last_run=$(cat "$LAST_RUN_FILE")
    local time_diff=$((current_time - last_run))
    
    if [[ $time_diff -lt $DEBOUNCE_DELAY ]]; then
        log "Debouncing: Last run was ${time_diff}s ago, waiting..."
        return
    fi
fi

log "File change detected, running blog monitor..."
echo "$current_time" > "$LAST_RUN_FILE"

if "$MONITOR_SCRIPT"; then
    log "Blog monitor completed successfully"
else
    log "ERROR: Blog monitor failed with exit code $?"
fi
```

}

log “Starting file watcher for $DOCS_PATH”
log “Watching for .md file changes…”

# Check if fswatch is installed

if ! command -v fswatch &> /dev/null; then
log “ERROR: fswatch is not installed. Install with: brew install fswatch”
exit 1
fi

# Watch for markdown file changes in docs directory

fswatch -0   
–event=Updated   
–include=’.md$’   
–exclude=’.obsidian’   
–exclude=’.git’   
–recursive   
“$DOCS_PATH” | while read -d “” event
do
log “Change detected: $event”
execute_monitor
done