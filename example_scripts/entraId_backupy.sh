#!/bin/bash
# Default values
LOG_DIR="/var/log/entra_backup"
LOG_BASENAME="entra_backup.log"
LOG_FILE="${LOG_DIR}/${LOG_BASENAME}"
MAX_LOG_SIZE=1048576  # 1MB
MAX_LOGS=5            # Number of rotated logs to keep
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
# Check if Azure CLI is installed
if ! command -v az >/dev/null 2>&1; then
  log "Error: Azure CLI is not installed. Please install Azure CLI before running this script."
  exit 1
fi


# Parse command-line options
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
# Validate required environment variables
if [ -z "$DD_TARGET_DIRECTORY" ] || [ -z "$TENANT_ID" ] || [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
  log "❌ Error: DD_TARGET_DIRECTORY, TENANT_ID, CLIENT_ID, and CLIENT_SECRET must be set."
  exit 1
fi
OUTPUT_DIR="$DD_TARGET_DIRECTORY"


# Logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE"
}
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


# Function to export paginated data
export_graph_data() {
  local endpoint=$1
  local filename=$2
  local url="https://graph.microsoft.com/v1.0/$endpoint"
  local output_file="$OUTPUT_DIR/$filename.json"

  log "Exporting $filename..."

  echo "[" > "$output_file"
  local first=true

  while [ -n "$url" ]; do
    response=$(curl -s -X GET "$url" \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "Content-Type: application/json")

    # Check if response contains .value
    if ! echo "$response" | jq -e '.value' > /dev/null; then
      log "⚠️ No data found or error for $filename"
      break
    fi

    items=$(echo "$response" | jq '.value')
    nextLink=$(echo "$response" | jq -r '."@odata.nextLink"')

    # Append items to file
    if [ "$first" = true ]; then
      echo "$items" | jq -c '.[]' | sed 's/^/  /' >> "$output_file"
      first=false
    else
      echo "," >> "$output_file"
      echo "$items" | jq -c '.[]' | sed 's/^/  /' >> "$output_file"
    fi

    url="$nextLink"
  done

  echo "]" >> "$output_file"
}


# Get access token
log "Authenticating with Microsoft Graph..."
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

# Endpoints to export
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


# Run based on BACKUP_LEVEL
case "$BACKUP_LEVEL" in
  FULL)
    log "Starting FULL backup for Tenant ID: $TENANT_ID"
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

# Final status check
if [ $EXIT_CODE -ne 0 ]; then
  log "❌ Backup failed with status $EXIT_CODE."
  exit 1
else
  log "✅ Backup completed successfully."
  exit 0
fi
