# 🔐 Azure Key Vault Backup Script for Dell PPDM Generic Application Protection

This document provides an overview, purpose, and detailed usage guide for the **Azure Key Vault Backup Script**, designed as a Generic Application integration for Dell PowerProtect Data Manager (PPDM).

---

## 📘 Overview

This Bash script automates the export of Azure Key Vault contents (secrets, certificates, and key metadata) for backup purposes. It runs as a PPDM Generic Application Protection job, enabling file-level backup of non-native or cloud applications.

It uses Azure CLI and a service principal with appropriate RBAC roles to perform **full backups** of all Key Vault objects in the target subscription.

---

## 🛡️ PPDM Generic Application Protection Context

PPDM’s Generic Application Protection supports custom workloads via scripts that interact with application data and store it on DD BoostFS targets.

This script:

- 📤 Exports Key Vault data to a specified directory
- 🔐 Uses PPDM environment variables for auth and paths
- 📋 Logs operations for visibility and troubleshooting
- 📦 Supports `FULL` backup level only

---

## ✨ Features

- 🔍 Discovers all Key Vaults in the Azure subscription
- 📄 Exports:
  - 🔑 Secrets → `.txt` files
  - 📜 Certificates → `.pfx` files (base64 decoded)
  - 🧾 Keys → `.json` metadata
- 🔁 Log rotation for backup tracking
- ✅ Validates Azure roles and environment variables
- 🔐 Secure service principal authentication
- 📋 Detailed logging
- 🔗 Seamless PPDM integration

---

## 🔑 Required Azure RBAC Roles

| 🔐 Object Type | 🛡️ Required Role               | 📋 Permissions |
|---------------|-------------------------------|----------------|
| Secrets       | Key Vault Secrets Officer      | Full access to secrets (except permissions) |
| Certificates  | Key Vault Certificates Officer | Full access to certificates (except permissions) |
| Keys          | Key Vault Crypto Officer       | Full access to keys (except permissions) |

---

## ⚙️ Prerequisites

- 🧰 Azure CLI installed
- 🛡️ PPDM Generic Application Protection configured
- 🔐 Service principal with correct roles
- 📦 Environment variables set by PPDM:

```bash
DD_TARGET_DIRECTORY="/path/to/output"
ASSET_USERNAME="client-id"
ASSET_PASSWORD="client-secret"
TENANT_ID="tenant-id"
SUBSCRIPTION_ID="subscription-id"
BACKUP_LEVEL="FULL"
```

---

## 🧪 Script Usage

### Required Environment Variables

| ⚙️ Variable            | 📌 Description                      |
|------------------------|-------------------------------------|
| `DD_TARGET_DIRECTORY`  | Directory for backup output         |
| `ASSET_USERNAME`       | Service principal client ID         |
| `ASSET_PASSWORD`       | Service principal secret            |
| `TENANT_ID`            | Azure tenant ID                     |
| `SUBSCRIPTION_ID`      | Azure subscription ID               |
| `BACKUP_LEVEL`         | Backup type (`FULL` supported)      |

### Command-Line Options

| 🏷️ Option | 🧭 Description           |
|----------|--------------------------|
| `-t`     | Azure Tenant ID          |
| `-s`     | Azure Subscription ID    |

---

## 🔄 Backup Flow

1. ✅ **Validation**: Checks CLI and env vars
2. 🔐 **Authentication**: Logs in and selects subscription
3. 📤 **Execution**:
   - Discovers Key Vaults
   - Exports secrets, certificates, and key metadata
   - Organizes data by vault in target directory
4. 📋 **Logging**: Logs actions and errors to `/var/log/azure_vault_backup/`

---

## 📁 Output Structure

```
DD_TARGET_DIRECTORY/
└── <vault-name>/
    ├── <secret1>_secret.txt
    ├── <cert1>_cert.pfx
    └── <key1>_key.json
```

---

## ⚠️ Limitations & Notes

- Only `FULL` backups supported
- No restore functionality included
- Key metadata only (no private key export)
- Data stored unencrypted—secure accordingly!
- Requires correct Azure roles

---

## 🛠️ Troubleshooting

- Check logs at `/var/log/azure_vault_backup/`
- Ensure Azure CLI is installed
- Confirm environment variables
- Verify service principal role assignments

---

## 📄 License

MIT License – see script for full terms.

---

## 🔗 References

- Azure Key Vault Documentation
- Dell PPDM User Guide (Generic Application Protection)

---
