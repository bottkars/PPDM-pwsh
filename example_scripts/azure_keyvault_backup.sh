#!/bin/bash
# Copyright Karsten Bott, Dell Inc. 2025
# Author: Karsten Bott
# Date Modified: 2025-07-28
# Version: 1.03
# Change log: 2025-07-20 - Initial version

# Licensed under the MIT License.
# Required Azure RBAC Roles for Exporting Vault Data
# Object Type	Required Role	Permissions
# Secrets	Key Vault Secrets Officer	Full access to secrets (read/write/delete), except managing permissions
# Certificates	Key Vault Certificates Officer	Full access to certificates, except managing permissions
# Keys	Key Vault Crypto Officer	Full access to keys (read/backup/restore), except managing permissions
# ─── Default Values ────────────────────────────────────────────────────────────
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi


LOG_DIR="/var/log/azure_vault_backup"
LOG_BASENAME="azure_vault_backup.log"
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
    # Discover all Key Vaults in the current subscription
    log "🔍 Discovering Key Vaults..."
    vaults=$(az keyvault list --query "[].name" -o tsv)

    total_secrets=0
    total_certs=0
    total_keys=0

    for vault in $vaults; do
        log "📁 Processing vault: $vault"
        VAULT_DIR="$OUTPUT_DIR/$vault"
        mkdir -p "$VAULT_DIR"

        vault_secrets=0
        vault_certs=0
        vault_keys=0

        # Export Secrets
        log "  🔐 Exporting secrets..."
        for secret in $(az keyvault secret list --vault-name "$vault" --query "[].id" -o tsv); do
            name=$(basename "$secret")
            value=$(az keyvault secret show --vault-name "$vault" --name "$name" --query "value" -o tsv)
            echo "$value" > "$VAULT_DIR/${name}_secret.txt"
            ((vault_secrets++))
        done

        # Export Certificates
        log "  📜 Exporting certificates..."
        for cert in $(az keyvault certificate list --vault-name "$vault" --query "[].id" -o tsv); do
            name=$(basename "$cert")
            pfx=$(az keyvault secret show --vault-name "$vault" --name "$name" --query "value" -o tsv)
            echo "$pfx" | base64 -d > "$VAULT_DIR/${name}_cert.pfx"
            ((vault_certs++))
        done

        # Export Keys (metadata only)
        log "  🔑 Exporting keys..."
        for key in $(az keyvault key list --vault-name "$vault" --query "[].kid" -o tsv); do
            name=$(basename "$key")
            az keyvault key show --vault-name "$vault" --name "$name" > "$VAULT_DIR/${name}_key.json"
            ((vault_keys++))
        done

        log "✅ Finished exporting vault: $vault"
        log "   ➤ Secrets: $vault_secrets, Certificates: $vault_certs, Keys: $vault_keys"

        ((total_secrets+=vault_secrets))
        ((total_certs+=vault_certs))
        ((total_keys+=vault_keys))
    done

    log "🎉 All vaults exported to $OUTPUT_DIR"
    log "📊 Total exported: Secrets=$total_secrets, Certificates=$total_certs, Keys=$total_keys"
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
    log "🔄 Starting FULL Azure Key Vault backup for Tenant ID: $TENANT_ID"
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
