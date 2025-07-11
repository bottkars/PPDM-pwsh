#!/bin/bash

###############################################################################
# Copyright (c) 2025 Dell Inc. or its subsidiaries. All Rights Reserved.
# Author: Karsten.Bott@dell.com
###############################################################################

# Set the base directory for backups, provided by the agent via environment variable
BASE_BACKUP_DIR="${DD_TARGET_DIRECTORY}"

# Define log file path and log rotation settings
LOG_FILE="/tmp/rclone.log"
MAX_LOGS=5
LOG_BASENAME=$(basename "$LOG_FILE")
LOG_DIR=$(dirname "$LOG_FILE")

# Rotate the current log file if it exists by renaming it with a timestamp
if [ -f "$LOG_FILE" ]; then
  TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
  mv "$LOG_FILE" "${LOG_FILE}.${TIMESTAMP}"
fi

# Keep only the most recent 5 rotated logs, delete older ones
find "$LOG_DIR" -name "${LOG_BASENAME}.*" -type f \
  | sort -r \
  | tail -n +$((MAX_LOGS + 1)) \
  | xargs -r rm -f

# Function to log messages with timestamps
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}

# Parse command-line options
while getopts ":b:c:p:s:i:f:" opt; do
  case $opt in
    b) BUCKET="$OPTARG" ;;               # Cloud bucket name
    c) CLOUD_PROFILE="$OPTARG" ;;        # Rclone cloud profile
    p) PREFIX="$OPTARG" ;;               # Optional prefix path within the bucket
    s) STREAMS="$OPTARG" ;;              # Number of parallel transfer streams
    i) INCREMENTAL_MAX_AGE="$OPTARG" ;;  # Max age for incremental backups (in hours)
    f) FULL_MAX_AGE="$OPTARG" ;;         # Max age for full backups (in hours)
    \?)
      log "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

# Log script start and environment variables
log "Script started with arguments: $*"
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

# Define rclone command and common options
COPY_COMMAND="rclone copy"
COMMON_OPTIONS="--transfers ${STREAMS} --multi-thread-write-buffer-size 512k --multi-thread-streams 1 --stats-log-level NOTICE --stats=10s"

# Perform backup based on the specified BACKUP_LEVEL
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

# Check the result of the backup operation
exit_status=$?
if [ $exit_status -ne 0 ]; then
  log "Backup failed with status $exit_status."
  exit 1
else
  log "Backup completed successfully."
  exit 0
fi