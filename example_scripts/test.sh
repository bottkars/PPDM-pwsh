#!/bin/bash

###############################################################################
# Copyright (c) 2025 Dell Inc. or its subsidiaries. All Rights Reserved.
# Karsten.Bott@dell.com
###############################################################################

# DD_TARGET_DIRECTORY is an exported value of the destination path by the agent
BASE_BACKUP_DIR="${DD_TARGET_DIRECTORY}"
LOG_FILE="/tmp/rclone.log"
MAX_LOGS=5
LOG_BASENAME=$(basename "$LOG_FILE")
LOG_DIR=$(dirname "$LOG_FILE")

# Rotate log file if it exists
if [ -f "$LOG_FILE" ]; then
  TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
  mv "$LOG_FILE" "${LOG_FILE}.${TIMESTAMP}"
fi
# Keep only the 5 most recent rotated logs


find "$LOG_DIR" -name "${LOG_BASENAME}.*" -type f \
  | sort -r \
  | tail -n +$((MAX_LOGS + 1)) \
  | xargs -r rm -f

# Function to log with timestamp
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}

# Process command line options
while getopts ":b:c:p:s:i:f:" opt; do
  case $opt in
    b) BUCKET="$OPTARG" ;;         # Bucket to back up
    c) CLOUD_PROFILE="$OPTARG" ;;  # Cloud profile defined on the datamover
    p) PREFIX="$OPTARG" ;;         # Bucket prefix to back up
    s) STREAMS="$OPTARG" ;;        # Parallel copy stream count
    i) INCREMENTAL_MAX_AGE="$OPTARG" ;;  # Incremental max age (in hours)
    f) FULL_MAX_AGE="$OPTARG" ;;         # Full max age (in hours)
    \?)
      log "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

# Initial logging
log "Script started with arguments: $*"
printenv >> "$LOG_FILE"
log "Entering backup phase..."

# Validate required environment variables
if [ -z "$BASE_BACKUP_DIR" ]; then
  log "Error: BASE_BACKUP_DIR is not set."
  exit 1
fi

if [ -z "$BACKUP_LEVEL" ]; then
  log "Error: BACKUP_LEVEL is not set."
  exit 1
fi

# Set common rclone options
COPY_COMMAND="rclone copy"
COMMON_OPTIONS="--transfers ${STREAMS} --multi-thread-write-buffer-size 512k --multi-thread-streams 1 --progress"

# Perform backup based on level
case "$BACKUP_LEVEL" in
  FULL)
    log "Starting FULL backup..."
    $COPY_COMMAND --max-age "${FULL_MAX_AGE}" $COMMON_OPTIONS \
      "${CLOUD_PROFILE}:${BUCKET}${PREFIX}" "${BASE_BACKUP_DIR}/" >> "$LOG_FILE" 2>&1
    ;;
  LOG)
    log "Starting LOG (incremental) backup..."
    $COPY_COMMAND --max-age "${INCREMENTAL_MAX_AGE}" $COMMON_OPTIONS \
      "${CLOUD_PROFILE}:${BUCKET}${PREFIX}" "${BASE_BACKUP_DIR}/" >> "$LOG_FILE" 2>&1
    ;;
  *)
    log "Invalid backup level. Please specify 'FULL' or 'LOG'."
    exit 1
    ;;
esac

# Check result
exit_status=$?
if [ $exit_status -ne 0 ]; then
  log "Backup failed with status $exit_status."
  exit 1
else
  log "Backup completed successfully."
  exit 0
fi

