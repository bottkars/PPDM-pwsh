#!/bin/bash
# Copyright Karsten Bott, Dell Inc. 2025
# Author: Karsten Bott
# Date Modified: 2025-07-28
# Version: 1.03
# Change log: 2025-07-20 - Initial version

# Licensed under the MIT License.
# ─── Default Values ────────────────────────────────────────────────────────────
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi


LOG_DIR="/var/log/azure_dns_backup"
LOG_BASENAME="azure_dns_backup.log"
LOG_FILE="${LOG_DIR}/${LOG_BASENAME}"
MAX_LOG_SIZE=1048576  # 1MB
MAX_LOGS=5            # Number of rotated logs to keep

# ─── Function Definitions ──────────────────────────────────────────────────────

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}

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
  find "$target" -type f -exec unlink {} \;
  find "$target" -depth -type d -exec rmdir {} \;
}

export_data() {


log "🔄 Fetching DNS zones from subscription..."

# Get all DNS zones in the subscription
dns_zones=$(az network dns zone list --query "[].{name:name, resourceGroup:resourceGroup}" -o tsv)

# Loop through each DNS zone
while IFS=$'\t' read -r zone_name resource_group; do
    log "🔄 Exporting DNS records for zone: $zone_name in resource group: $resource_group"

    # Export DNS records to JSON
    az network dns record-set list \
        --zone-name "$zone_name" \
        --resource-group "$resource_group" \
        -o json > "$OUTPUT_DIR/${zone_name}_records.json"

done <<< "$dns_zones"

echo "Export complete. Files saved in: $OUTPUT_DIR"
}


# ─── Setup ─────────────────────────────────────────────────────────────────────

mkdir -p "$LOG_DIR"

if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -ge $MAX_LOG_SIZE ]; then
  TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
  mv "$LOG_FILE" "${LOG_FILE}.${TIMESTAMP}"
  touch "$LOG_FILE"
fi

find "$LOG_DIR" -name "${LOG_BASENAME}.*" -type f \
  | sort -r \
  | tail -n +$((MAX_LOGS + 1)) \
  | xargs -r rm -f

if ! command -v az >/dev/null 2>&1; then
  log "Error: Azure CLI is not installed. Please install Azure CLI before running this script."
  exit 1
fi
while getopts ":t:s:" opt; do
  case $opt in
    t) TENANT_ID="$OPTARG" ;;
    s) SUBSCRIPTION_ID="$OPTARG" ;;
    \?)
      log "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done
CLIENT_ID=$ASSET_USERNAME
CLIENT_SECRET=$ASSET_PASSWORD

# Validate required environment variables individually
missing_vars=0

if [ -z "$DD_TARGET_DIRECTORY" ]; then
  log "❌ Error: DD_TARGET_DIRECTORY is not set."
  missing_vars=1
fi

if [ -z "$TENANT_ID" ]; then
  log "❌ Error: TENANT_ID is not set."
  missing_vars=1
fi

if [ -z "$CLIENT_ID" ]; then
  log "❌ Error: CLIENT_ID is not set."
  missing_vars=1
fi

if [ -z "$CLIENT_SECRET" ]; then
  log "❌ Error: CLIENT_SECRET is not set."
  missing_vars=1
fi
if [ -z "$SUBSCRIPTION_ID" ]; then
  log "❌ Error: SUBSCRIPTION_ID is not set."
  missing_vars=1
fi

if [ "$missing_vars" -ne 0 ]; then
  log "❌ One or more required environment variables are missing. Exiting."
  exit 1
fi

OUTPUT_DIR="$DD_TARGET_DIRECTORY"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# ─── Authentication ───────────────────────────────────────────────────────────
log "🔑 Authenticating with Microsoft Azure ..."

# Login using the service principal
az login --service-principal \
         --username "$CLIENT_ID" \
         --password "$CLIENT_SECRET" \
         --tenant "$TENANT_ID"

# Set the subscription
az account set --subscription "$SUBSCRIPTION_ID"

# Confirm login
az account show
if [ $? -ne 0 ]; then
  log "❌ Authentication failed. Please check your credentials."
  exit 1
fi

log "✅ Authentication successful."

# ─── Execution ─────────────────────────────────────────────────────────────────

case "$BACKUP_LEVEL" in
  FULL)
    log "🔄 Starting FULL backup for Tenant ID: $TENANT_ID"
# Export each category
    export_data
    EXIT_CODE=$?    
    log "✅ Export complete. Files saved in $OUTPUT_DIR"


    ;;
  LOG)
    EXIT_CODE=$?
    log "Log Backup, not implemented yet"

    ;;
  *)
    log "Error: BACKUP_LEVEL must be either FULL or LOG."
    exit 1
    ;;
esac

# ─── Final Status Check ─────────────────────────────────────────────────────────────	
if [ $EXIT_CODE -ne 0 ]; then
  log "❌ Backup failed with status $EXIT_CODE."
  exit 1
else
  log "✅ Backup completed successfully."
  exit 0
fi
