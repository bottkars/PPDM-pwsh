# Dell Inc. Backup Script with Log Rotation

This script automates the process of backing up data from an S3-compatible bucket to a local directory, with robust logging and log rotation. It is designed for environments requiring consistent backups, traceability, and error reporting.

---

## Features

- Performs **full** S3-to-local directory backups using `aws s3 sync`.
- Supports custom cloud profiles and endpoints.
- Maintains operation logs with auto-rotation when log files exceed 1MB.
- Accepts various runtime parameters for flexible integration.
- Validates key environment requirements before backup operations.
- Clearly logs all critical actions and errors for troubleshooting.

---

## Prerequisites

Before using this script, ensure:

- **Bash** is available on your system.
- **AWS CLI** is installed at `/usr/local/bin/aws` and properly configured.
- You have sufficient permissions to read from the S3 bucket and write to the target local directory.
- The target local backup directory exists or its parent path is available.
- The script is executed with required environment variables.

---

## Environment Variables

Set the following environment variables before running the script:

| Variable           | Description                                                            | Required |
|--------------------|------------------------------------------------------------------------|----------|
| DD_TARGET_DIRECTORY| Directory where files are to be backed up locally (target path).        | Yes      |
| BACKUP_LEVEL       | Backup type: must be `FULL` (only FULL is supported).                  | Yes      |

---

## Usage

Make the script executable and run it with the required options:

```bash
chmod +x backup_script.sh

BASE_BACKUP_DIR=/your/backup/path \
BACKUP_LEVEL=FULL \
./backup_script.sh \
  -b mybucket \
  -c myawsprofile \
  -e https://s3.endpoint.url
```

---

## Command-Line Options

| Option | Argument           | Description                                             | Required |
|--------|--------------------|---------------------------------------------------------|----------|
| `-b`   | BUCKET             | Name of the S3 bucket                                  | Yes      |
| `-c`   | CLOUD_PROFILE      | AWS CLI profile to use                                 | Yes      |
| `-e`   | ENDPOINT_URL       | Custom S3 endpoint URL                                 | Yes      |
| `-p`   | PREFIX             | Prefix for S3 keys (*currently not used by script*)    | No       |
| `-s`   | STREAMS            | Number of parallel streams (*currently not used*)      | No       |
| `-i`   | INCREMENTAL_MAX_AGE| Not yet implemented                                    | No       |
| `-f`   | FULL_MAX_AGE       | Not yet implemented                                    | No       |

---

## How It Works

1. **Logging Directory & File Handling:**
   - Logs all activities to `/var/log/awssync/awssync.log`.
   - Rotates log file when it exceeds 1MB, appending a timestamp to the old log.

2. **Startup and Argument Parsing:**
   - Accepts runtime options for bucket, profile, and endpoint.
   - Logs invocation arguments and environment.

3. **Backup Execution:**
   - Validates essential environment variables.
   - Supports only `FULL` backup (`LOG` is not yet implemented).
   - Uses `aws s3 sync` to mirror the S3 bucket contents to the local path.
   - Logs all command outputs and statuses.

4. **Error Handling:**
   - Logs and exits if any required environment variable or a backup operation fails.
   - Provides clear log entries for all issues.

---

## Example

```bash
export DD_TARGET_DIRECTORY="/mnt/backups"
export BACKUP_LEVEL="FULL"

./backup_script.sh \
  -b prod-backup-bucket \
  -c s3prod \
  -e https://s3.example.com
```

- This will backup all objects from `prod-backup-bucket` to `/mnt/backups` using the `s3prod` profile and the specified endpoint.

---

## Notes

- Only `FULL` backup mode is supported; incremental/log backups are not yet implemented.
- Ensure the user running this script has write access to the log directory and target backup path.
- Logs are stored in `/var/log/awssync`; adjust permissions as needed.

---

## Troubleshooting

- If the script fails, review `/var/log/awssync/awssync.log` for detailed error information.
- Verify all required environment variables are set and all directories exist and are writable.

---

## Author

Karsten Bott (<karsten.bott@dell.com>)

---

*This script is provided as-is for Dell Inc. backup automation scenarios. Adapt and extend as needed for your environment.*