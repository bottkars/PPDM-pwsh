# 🗃️ Git Backup Array Script for Dell PPDM Generic Application Protection

This README provides comprehensive technical guidance for **`git_backup_array.sh`**, a Bash script designed to enable automated, policy-driven backup of Git repositories at scale within the Dell PowerProtect Data Manager (PPDM) Generic Application Protection framework.

---

## 📘 Overview

`git_backup_array.sh` automates the backup of multiple Git repositories, supporting both full and incremental modes. It retrieves a list of repositories from a remote file, clones each one, and exports their content as `.bundle` files into a PPDM-managed directory.

### 🔧 Key Capabilities

- ⚡ Parallel processing for large jobs  
- 📋 Structured logging with rotation  
- ✅ Input validation and error handling  
- 🔗 PPDM-ready environment variable integration

---

## 🛡️ PPDM Generic Application Protection Context

PPDM’s Generic Application Protection supports custom workloads via user-defined scripts. This script:

- 📤 Exports Git data to PPDM-managed storage  
- 🔐 Uses PPDM environment variables  
- 📊 Logs job status and errors  
- 📦 Supports `FULL` and `LOG` (incremental) backups

---

## ✨ Features

- 🧺 **Batch Git Backup**: Handles multiple repositories from a remote list  
- 🔄 **Parallelism**: Default 4 streams, configurable  
- 🧭 **Backup Levels**:
  - `FULL`: Full mirror bundle
  - `LOG`: Incremental commits only  
- 🧠 **Environment-Aware**: Reads PPDM variables  
- 📄 **Logging**: Rotates logs at `/var/log/git_backup/git-backup.log`  
- 🔍 **Validation**: Checks tools and variables before execution

---

## ⚙️ Prerequisites

- 🧰 Git installed and accessible  
- 🛡️ PPDM Generic Application Protection configured  
- 📦 Environment variables set by PPDM:

| Variable              | Purpose                                          |
|-----------------------|--------------------------------------------------|
| `DD_TARGET_DIRECTORY` | Path for backup output                           |
| `FILE_URL`            | URL of file with Git repo URLs                   |
| `BACKUP_LEVEL`        | `FULL` or `LOG`                                  |
| `INCREMENTAL_MAX_AGE` | (Optional) Age in hours for incremental backups  |
| `LAST_BACKUP_TIME`    | (Optional) Unix timestamp of last backup         |

---

## 🧪 Script Usage

### Required Environment Variables

| Variable              | Description                                      |
|-----------------------|--------------------------------------------------|
| `DD_TARGET_DIRECTORY` | Directory for `.bundle` outputs                  |
| `FILE_URL`            | Remote file with one Git URL per line            |
| `BACKUP_LEVEL`        | Must be `FULL` or `LOG`                          |
| `INCREMENTAL_MAX_AGE` | Optional for `LOG` mode                          |
| `LAST_BACKUP_TIME`    | Required if `INCREMENTAL_MAX_AGE=off`            |

### Command-Line Options

| Option | Description                                              |
|--------|----------------------------------------------------------|
| `-s`   | Number of parallel streams (default: 4)                  |
| `-i`   | Override `INCREMENTAL_MAX_AGE`                           |
| `-f`   | `FULL_MAX_AGE` (not implemented)                         |
| `-r`   | Override `FILE_URL`                                      |

### ▶️ Example Manual Run

```bash
export DD_TARGET_DIRECTORY="/mnt/ppdm/gitback"
export FILE_URL="https://myrepo.example.com/git-list.txt"
export BACKUP_LEVEL="FULL"

./git_backup_array.sh -s 8 -r "$FILE_URL"
```

---

## 🔄 Operational Flow

1. ✅ **Validation**: Checks Git and environment variables  
2. 📋 **Logging Setup**: Initializes and rotates logs  
3. 🌐 **Repo List Retrieval**: Downloads and parses `FILE_URL`  
4. 🧩 **Backup Execution**:
   - `FULL`: `git clone --mirror` + `git bundle create`
   - `LOG`: `git clone --shallow-since` with age filter  
5. 🧹 **Cleanup & Logging**: Logs status and cleans temp dirs

---

## 📁 Output Structure

```
DD_TARGET_DIRECTORY/
├── repo1-full-20250807-153012.bundle
├── repo2-incremental-20250807-153012.bundle
└── ...
```

Each file is a self-contained Git bundle for the corresponding repository and backup mode.

---

## ⚠️ Limitations & Notes

- 🔄 **Restore**: Manual via `git clone repo.bundle` or custom script  
- ⏱️ **Incremental Accuracy**: Depends on age and timestamp tracking  
- 🔐 **Security**: Secure `.bundle` files and SSH access  
- 🌐 **Network**: Repos must be reachable with credentials  
- 📋 **Coverage**: Only repos listed in `FILE_URL` are backed up  
- 🧰 **Dependencies**: Requires Git and network access; no retry logic

---

## 🛠️ Troubleshooting

- Check `/var/log/git_backup/git-backup.log` for errors  
- Validate `FILE_URL` and its contents  
- Ensure SSH keys or tokens are available  
- Confirm all required environment variables are set

---

## 📄 License

MIT License – see script header for details

---

## 🔗 References

- Git Documentation: git bundle, git clone  
- Dell PPDM User Guide: Generic Application Protection

