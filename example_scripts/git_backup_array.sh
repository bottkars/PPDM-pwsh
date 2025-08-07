#!/bin/bash

# Check if Git is installed
if ! command -v git >/dev/null 2>&1; then
  echo "Error: Git is not installed. Please install Git before running this script."
  exit 1
fi

# Default values
LOG_DIR="/var/log/git_backup"
LOG_BASENAME="git-backup.log"
LOG_FILE="${LOG_DIR}/${LOG_BASENAME}"
MAX_LOG_SIZE=1048576  # 1MB
MAX_LOGS=5            # Number of rotated logs to keep
STREAMS=4
# Parse command-line options
while getopts ":s:i:f:r:" opt; do
  case $opt in
    s) STREAMS="$OPTARG" ;;
    i) INCREMENTAL_MAX_AGE="$OPTARG" ;;
    f) FULL_MAX_AGE="$OPTARG" ;;
    r) FILE_URL="$OPTARG" ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

# Validate required environment variables
if [ -z "$DD_TARGET_DIRECTORY" ] || [ -z "$FILE_URL" ] || [ -z "$BACKUP_LEVEL" ]; then
  echo "Error: DD_TARGET_DIRECTORY, FILE_URL, and BACKUP_LEVEL must be set."
  exit 1
fi

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Rotate log if it exceeds MAX_LOG_SIZE
if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -ge $MAX_LOG_SIZE ]; then
  TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
  mv "$LOG_FILE" "${LOG_FILE}.${TIMESTAMP}"
  touch "$LOG_FILE"
fi

# Keep only the most recent rotated logs
find "$LOG_DIR" -name "${LOG_BASENAME}.*" -type f \
  | sort -r \
  | tail -n +$((MAX_LOGS + 1)) \
  | xargs -r rm -f

# Logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}
ssh-keyscan github.com >> ~/.ssh/known_hosts
# Convert REPO_DOKUMENT

while IFS= read -r line; do
    REPO_ARRAY+=("$line")
done < <(curl -s "$FILE_URL")


# Timestamp for versioning
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# Timestamp diff function
timestamp_diff() {
  local input_timestamp=$1
  local current_timestamp
  current_timestamp=$(date +%s)
  local diff=$((current_timestamp - input_timestamp))
  echo "$diff"
}

delete_recursively() {
    local target="$1"
    log "[cleaning] temp dir $target"
    if [ ! -e "$target" ]; then
        log "Target '$target' does not exist."
    fi

    # First delete files
    find "$target" -type f -exec unlink {} \;

    # Then delete directories (bottom-up)
    find "$target" -depth -type d -exec rmdir {} \;
}

# Usage



# Backup function
backup_repo() {
  REPO_URL="$1"
  MODE="$2"
  AGE_LIMIT="$3"

  REPO_NAME=$(basename "$REPO_URL" .git)
  DEST="$DD_TARGET_DIRECTORY/${REPO_NAME}-${MODE}-${TIMESTAMP}.bundle"
  TMP_DIR=$(mktemp -d)

  {
    log "[$MODE] Starting backup for $REPO_NAME"

    if [ -n "$AGE_LIMIT" ]; then
      SINCE_DATE=$(date -d "-$AGE_LIMIT hours" +"%Y-%m-%d")
      git clone --shallow-since="$SINCE_DATE" "$REPO_URL" "$/$REPO_NAME"
    else
      git clone --mirror "$REPO_URL" "$TMP_DIR/$REPO_NAME"
    fi
#    sudo mount -t tmpfs -o size=1024m $() $TMP_DIR
    git -C "$TMP_DIR/$REPO_NAME" bundle create "$DEST" --all

    # Safe cleanup
    delete_recursively "$TMP_DIR"

    log "[$MODE] Completed backup for $REPO_NAME to $DEST"
  } >> "$LOG_FILE" 2>&1
}

# Run backups with concurrency control
run_backups() {
  local mode="$1"
  local age_limit="$2"
  local pids=()
  local count=0

  for repo in "${REPO_ARRAY[@]}"; do
    backup_repo "$repo" "$mode" "$age_limit" &
    pids+=($!)
    ((count++))

    if (( count % STREAMS == 0 )); then
      wait "${pids[@]}"
      pids=()
    fi
  done

  # Wait for any remaining jobs
  wait "${pids[@]}"
}

# Run based on BACKUP_LEVEL
case "$BACKUP_LEVEL" in
  FULL)
    log "Starting FULL backup for repositories: ${REPO_ARRAY[*]}"
    run_backups full 
    EXIT_CODE=$?
    ;;
  LOG)
    log "Starting LOG backup for repositories: ${REPO_ARRAY[*]}"  
    if [ "$INCREMENTAL_MAX_AGE" = "off" ]; then
        if [ -z "$LAST_BACKUP_TIME" ]; then
            log "Error: LAST_BACKUP_TIME must be set when INCREMENTAL_MAX_AGE is 'off'."
            exit 1
        fi
        INCREMENTAL_MAX_AGE=$(timestamp_diff "$LAST_BACKUP_TIME")
        INCREMENTAL_MAX_AGE=$((INCREMENTAL_MAX_AGE / 3600))
        log "Calculated INCREMENTAL_MAX_AGE: $INCREMENTAL_MAX_AGE hours"
    fi
    run_backups incremental "$INCREMENTAL_MAX_AGE"
    EXIT_CODE=$?
    ;;
  *)
    log "Error: BACKUP_LEVEL must be either FULL or LOG."
    exit 1
    ;;
esac

# Final status check
if [ $EXIT_CODE -ne 0 ]; then
  log "❌ Backup failed with status $EXIT_CODE."
  exit 1
else
  log "✅ Backup completed successfully."
  exit 0
fi
