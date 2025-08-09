#!/bin/bash

# Blog Monitor Script

# Monitors Obsidian vault for draft status changes and commits to Git

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration

VAULT_PATH=”$HOME/Documents/NoEngineer”
DOCS_PATH=”$VAULT_PATH/docs/blog/posts”
LOG_DIR=”$VAULT_PATH/scripts/logs”
LOG_FILE=”$LOG_DIR/blog_monitor_$(date +%Y%m).log”
LOCK_FILE=”/tmp/blog_monitor.lock”
STATE_FILE=”$LOG_DIR/published_posts.state”

# Ensure directories exist

mkdir -p “$LOG_DIR”
touch “$STATE_FILE”

# Logging function

log() {
echo “[$(date ‘+%Y-%m-%d %H:%M:%S’)] $1” | tee -a “$LOG_FILE”
}

# Error handling

cleanup() {
rm -f “$LOCK_FILE”
log “Script terminated”
}
trap cleanup EXIT

# Prevent multiple instances

if [[ -f “$LOCK_FILE” ]]; then
log “ERROR: Another instance is running (lock file exists)”
exit 1
fi
echo $$ > “$LOCK_FILE”

log “Starting blog monitor scan”

# Check if we’re in the right directory

if [[ ! -d “$VAULT_PATH/.git” ]]; then
log “ERROR: Not a git repository at $VAULT_PATH”
exit 1
fi

cd “$VAULT_PATH”

# Find all markdown files with drafting: false (case insensitive)

readarray -t ready_files < <(
find “$DOCS_PATH” -name “*.md” -type f -exec grep -l “^drafting:[[:space:]]*[Ff][Aa][Ll][Ss][Ee]” {} ; 2>/dev/null || true
)

if [[ ${#ready_files[@]} -eq 0 ]]; then
log “No files ready for publication”
exit 0
fi

# Read previously published files

readarray -t published_files < “$STATE_FILE”

# Check for new files ready for publication

new_files=()
for file in “${ready_files[@]}”; do
if ! printf ‘%s\n’ “${published_files[@]}” | grep -Fxq “$file”; then
new_files+=(”$file”)
fi
done

if [[ ${#new_files[@]} -eq 0 ]]; then
log “No new files to publish (${#ready_files[@]} already published)”
exit 0
fi

log “Found ${#new_files[@]} new file(s) ready for publication:”
for file in “${new_files[@]}”; do
log “  - $file”
done

# Validate files before committing

invalid_files=()
for file in “${new_files[@]}”; do
if [[ ! -f “$file” ]]; then
log “WARNING: File not found: $file”
invalid_files+=(”$file”)
continue
fi

```
# Check if file has required frontmatter
if ! head -20 "$file" | grep -q "^drafting:[[:space:]]*[Ff][Aa][Ll][Ss][Ee]"; then
    log "WARNING: File missing proper drafting status: $file"
    invalid_files+=("$file")
fi
```

done

# Remove invalid files

for invalid in “${invalid_files[@]}”; do
new_files=(”${new_files[@]/$invalid}”)
done
new_files=(”${new_files[@]}”)  # Remove empty elements

if [[ ${#new_files[@]} -eq 0 ]]; then
log “No valid files to publish after validation”
exit 0
fi

# Git operations with error handling

log “Performing git operations…”

# Stash any unstaged changes

if ! git diff –quiet; then
log “Stashing unstaged changes”
git stash push -m “Auto-stash before blog publish $(date)”
fi

# Pull latest changes

if ! git pull origin main; then
log “ERROR: Failed to pull from origin”
exit 1
fi

# Stage the new files

for file in “${new_files[@]}”; do
if git add “$file”; then
log “Staged: $file”
else
log “ERROR: Failed to stage $file”
exit 1
fi
done

# Create meaningful commit message

if [[ ${#new_files[@]} -eq 1 ]]; then
# Single file - use its title if available
title=$(grep -m1 “^# “ “${new_files[0]}” | sed ‘s/^# //’ || echo “New post”)
commit_msg=“Publish: $title”
else
commit_msg=“Publish: ${#new_files[@]} new posts”
fi

# Commit changes

if git commit -m “$commit_msg

Published files:
$(printf ‘- %s\n’ “${new_files[@]}”)

Auto-committed by blog monitor at $(date)”; then
log “Committed changes: $commit_msg”
else
log “ERROR: Failed to commit changes”
exit 1
fi

# Push to origin

if git push origin main; then
log “Successfully pushed to origin/main”

```
# Update state file with newly published files
for file in "${new_files[@]}"; do
    echo "$file" >> "$STATE_FILE"
done

log "Updated state file with ${#new_files[@]} new published files"

# Optional: Trigger manual build notification
log "Files committed successfully. Daily build will publish at scheduled time."
```

else
log “ERROR: Failed to push to origin”
exit 1
fi

log “Blog monitor completed successfully”