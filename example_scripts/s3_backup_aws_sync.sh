#!/bin/bash

# Dell Inc. - Backup Script with Log Rotation
# Author: Karsten.Bott@dell.com

BASE_BACKUP_DIR=${DD_TARGET_DIRECTORY}
LOG_DIR="/var/log/awssync"
LOG_FILE="$LOG_DIR/awssync.log"
MAX_LOG_SIZE=1048576  # 1MB

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Rotate log if it exceeds MAX_LOG_SIZE
if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -ge $MAX_LOG_SIZE ]; then
  mv "$LOG_FILE" "$LOG_FILE.$(date +%Y%m%d%H%M%S)"
  touch "$LOG_FILE"
fi

# Logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG_FILE"
}

# Process command line options
while getopts ":b:c:p:e:s:i:f:" opt; do
  case $opt in
    b) BUCKET="$OPTARG" ;;
    c) CLOUD_PROFILE="$OPTARG" ;;
    e) ENDPOINT_URL="$OPTARG" ;;
    p) PREFIX="$OPTARG" ;;
    s) STREAMS="$OPTARG" ;;
    i) INCREMENTAL_MAX_AGE="$OPTARG" ;;
    f) FULL_MAX_AGE="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

log "Script started with arguments: $*"
printenv >> "$LOG_FILE"

log "Entering backup phase..."

# Validate required environment variables
if [ -z "$BASE_BACKUP_DIR" ]; then
  log "❌ BASE_BACKUP_DIR is not set."
  exit 1
fi

if [ -z "$BACKUP_LEVEL" ]; then
  log "❌ BACKUP_LEVEL is not set."
  exit 1
fi

# Perform a full backup
if [[ "$BACKUP_LEVEL" == "FULL" ]]; then
  COPY_COMMAND="/usr/local/bin/aws s3 sync"
  $COPY_COMMAND s3://${BUCKET}${PREFIX} "$BASE_BACKUP_DIR" \
    --profile "$CLOUD_PROFILE" \
    --endpoint-url "$ENDPOINT_URL" >> "$LOG_FILE" 2>&1

  exit_status=$?
  if [ $exit_status -ne 0 ]; then
    log "❌ Unable to perform FULL backup."
    exit 1
  fi

  log "✅ Backup completed successfully."
  exit 0

elif [[ "$BACKUP_LEVEL" == "LOG" ]]; then
  log "⚠️ LOG backup not supported yet."
  exit 1

else
  log "❌ Invalid backup level. Please specify 'FULL' or 'LOG'."
  exit 1
fi
