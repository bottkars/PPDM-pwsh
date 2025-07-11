# 📦 AWS S3 Backup Script

This Bash script performs **parallelized, incremental backups** from an AWS S3-compatible bucket to a local directory. It supports full backups based on object modification dates and includes retry logic for robustness.

---

## 🛠️ Features

- Downloads S3 objects modified within a specified time window
- Supports **FULL** backup mode (incremental based on age)
- Parallel downloads with configurable concurrency
- Retry mechanism for failed downloads
- Logging to `/tmp/awssync.log`

---

## 📁 Requirements

- `awscli` installed and accessible at `/usr/local/bin/aws`
- Environment variables:
  - `DD_TARGET_DIRECTORY`: Local directory to store backups
  - `BACKUP_LEVEL`: Must be set to `FULL` (only mode currently supported)

---

## 🚀 Usage

```bash
./backup.sh -b <bucket> -c <cloud_profile> -e <endpoint_url> -p <prefix> -s <streams> -f <full_max_age>
