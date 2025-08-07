#!/bin/bash
# Copyright Karsten Bott, Dell Inc. 2025
# Author: Karsten Bott
# Date Modified: 2025-07-28
# Version: 1.03
# Change log: 2025-07-20 - Initial version
#              2025-07-26 - added ASSET_USERNAME and ASSET_PASSWORD for authentication
#              2025-07-28 - Added support for Azure AD Graph API export
#              2025-08-01 - Added B2C and B2B export
#              2025-08-02 - Added logging and cleanup functions
#              2025-08-03 - Added error handling and improved logging
# Licensed under the MIT License.
# ─── Default Values ────────────────────────────────────────────────────────────
LOG_DIR="/var/log/entra_backup"
LOG_BASENAME="entra_backup.log"
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

export_graph_data() {
  local endpoint=$1
  local filename=$2
  local url="https://graph.microsoft.com/v1.0/$endpoint"
  local output_file="$OUTPUT_DIR/$filename.json"

  log "Exporting $filename..."
  echo "[" > "$output_file"
  local page=1
  local first_item=true
  local total_exported=0

  while [ -n "$url" ]; do
    response=$(curl -s -X GET "$url" \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "Content-Type: application/json")

    # Validate JSON
    if ! echo "$response" | jq empty > /dev/null 2>&1; then
      log "❌ Invalid JSON response for $filename (page $page)"
      break
    fi

    # Extract items
    mapfile -t items < <(echo "$response" | jq -c '.value[]?')
    nextLink=$(echo "$response" | jq -r '."@odata.nextLink"')

    # If first page and no data, log warning
    if [ "$page" -eq 1 ] && [ "${#items[@]}" -eq 0 ]; then
      log "⚠️ No data found for $filename"
      break
    fi

    for item in "${items[@]}"; do
      if [ "$first_item" = true ]; then
        first_item=false
      else
        echo "," >> "$output_file"
      fi
      echo "  $item" >> "$output_file"
      total_exported=$((total_exported + 1))
    done

    url="$nextLink"
    page=$((page + 1))
  done

  echo "]" >> "$output_file"
    if [ $total_exported -eq 0 ]; then
      log "⚠️ No items exported for $filename"
    else
      log "✅ Exported $total_exported items to $filename"
    fi
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
while getopts ":t:" opt; do
  case $opt in
    t) TENANT_ID="$OPTARG" ;;
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

if [ "$missing_vars" -ne 0 ]; then
  log "❌ One or more required environment variables are missing. Exiting."
  exit 1
fi

OUTPUT_DIR="$DD_TARGET_DIRECTORY"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# ─── Authentication ───────────────────────────────────────────────────────────
log "🔑 Authenticating with Microsoft Graph for Tenant $TENANT_ID"
ACCESS_TOKEN=$(curl -s -X POST https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "scope=https://graph.microsoft.com/.default" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials" | jq -r .access_token)

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
  log "❌ Failed to obtain access token."
  exit 1
fi

# ─── Endpoint Definitions ──────────────────────────────────────────────────────

declare -A endpoints=(
  ["Users"]="users"
  ["Groups"]="groups"
  ["Applications"]="applications"
  ["ServicePrincipals"]="servicePrincipals"
  ["ConditionalAccess"]="identity/conditionalAccess/policies"
  ["AccessReviews"]="identityGovernance/accessReviews"
  ["EntitlementManagement"]="identityGovernance/entitlementManagement"
  ["PIM"]="identityGovernance/privilegedAccess"
  ["PIMAzure"]="identityGovernance/privilegedAccess/azureResources"
  ["PIMAAD"]="identityGovernance/privilegedAccess/aadRoles"
  ["AppProxy"]="onPremisesPublishingProfiles"
  ["Organization"]="organization"
  ["Domains"]="domains"
  ["Policies"]="policies"
  ["AdministrativeUnits"]="administrativeUnits"
  ["SKUs"]="subscribedSkus"
  ["Identity"]="identity"
  ["Roles"]="directoryRoles"
  ["Governance"]="identityGovernance"
  ["B2C"]="identity/b2cUserFlows"
  ["B2B"]="invitations"
)

# ─── Execution ─────────────────────────────────────────────────────────────────

case "$BACKUP_LEVEL" in
  FULL)
    log "🔄 Starting FULL backup for Tenant ID: $TENANT_ID"
# Export each category
    for name in "${!endpoints[@]}"; do
      export_graph_data "${endpoints[$name]}" "$name"
    done

    log "✅ Export complete. Files saved in $OUTPUT_DIR"

    EXIT_CODE=$?
    ;;
  LOG)
    log "Log Backup, not implemented yet"
    EXIT_CODE=$?
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
