#!/bin/bash

BASE_BACKUP_DIR=${DD_TARGET_DIRECTORY}
LOG_FILE="/tmp/awssync.log"
MAX_RETRIES=3
RETRY_DELAY=5


# Function to download a single object with retries
download_object() {
  local key="$1"
  local attempt=1
  local success=0

  while [ $attempt -le $MAX_RETRIES ]; do
    echo "Copying: $key (Attempt $attempt)" | tee -a "$LOG_FILE"
    /usr/local/bin/aws s3 cp "s3://${BUCKET}/${key}" "${BASE_BACKUP_DIR}/${key}" \
      --profile "${CLOUD_PROFILE}" \
      --endpoint-url "${ENDPOINT_URL}" >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
      success=1
      break
    else
      echo "⚠️ Attempt $attempt failed for $key. Retrying in $RETRY_DELAY seconds..." | tee -a "$LOG_FILE"
      sleep $RETRY_DELAY
      ((attempt++))
    fi
  done

  if [ $success -ne 1 ]; then
    echo "❌ Failed to copy $key after $MAX_RETRIES attempts" | tee -a "$LOG_FILE"
    exit 1
  fi
}

# Semaphore function to limit parallel jobs
parallel_limit() {
  while [ "$(jobs -rp | wc -l)" -ge "$STREAMS" ]; do
    sleep 1
  done
}

# Parse options (same as before)
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

echo "$@" >> "$LOG_FILE"
printenv >> "$LOG_FILE"

echo "Entering backup phase..." | tee -a "$LOG_FILE"

if [ -z "$BASE_BACKUP_DIR" ] || [ -z "$BACKUP_LEVEL" ]; then
  echo "Missing required environment variables." | tee -a "$LOG_FILE"
  exit 1
fi

if [[ "$BACKUP_LEVEL" == "FULL" ]]; then
  DATE_CUTOFF=$(date -u -d "${FULL_MAX_AGE} days ago" +"%Y-%m-%dT%H:%M:%SZ")

  echo "Listing objects modified since $DATE_CUTOFF..." | tee -a "$LOG_FILE"

  OBJECT_KEYS=$(/usr/local/bin/aws s3api list-objects-v2 \
    --bucket "${BUCKET}" \
    --prefix "${PREFIX}" \
    --endpoint-url "${ENDPOINT_URL}" \
    --profile "$CLOUD_PROFILE" \
    --query "Contents[?LastModified>=\`$DATE_CUTOFF\`].[Key]" \
    --output text 2>>"$LOG_FILE")

  if [ $? -ne 0 ]; then
    echo "❌ Failed to list objects from bucket $BUCKET" | tee -a "$LOG_FILE"
    exit 1
  fi

  for key in $OBJECT_KEYS; do
    parallel_limit
    download_object "$key" &
  done

  wait  # Wait for all background jobs to finish

  echo "✅ Full backup completed successfully" | tee -a "$LOG_FILE"
  exit 0

elif [[ "$BACKUP_LEVEL" == "LOG" ]]; then
  echo "❌ LOG backup not supported yet" | tee -a "$LOG_FILE"
  exit 1

else
  echo "❌ Invalid backup level. Please specify 'FULL' or 'LOG'." | tee -a "$LOG_FILE"
  exit 1
fi
