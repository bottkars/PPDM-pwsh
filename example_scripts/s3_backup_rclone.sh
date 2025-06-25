#!/bin/bash

#
# Copyright (c) 2025 Dell Inc. or its subsidiaries. All Rights Reserved.
# Karsten.Bott@dell.com
# This software contains the intellectual property of Dell Inc.
# or is licensed to Dell Inc. from third parties. Use of this
# software and the intellectual property contained therein is
# expressly limited to the terms and conditions of the License
# Agreement under which it is provided by or on behalf of Dell
# Inc. or its subsidiaries.
#

# $PG_BASEBACKUP_PATH is the path of the pg_basebackup utility


# DD_TARGET_DIRECTORY is an exported value of the Destination path by the agent
BASE_BACKUP_DIR=${DD_TARGET_DIRECTORY}

# Process command line options
while getopts ":b:c:p:s:i:f:" opt; do
  case $opt in
    b)
      ## the bucket to backup
      BUCKET="$OPTARG"
      ;;
    c)
      # the cloud profile to be defined on the datamover
      CLOUD_PROFILE="$OPTARG"
      ;;
      
    p)
      # bucket prefix to backup
      PREFIX="$OPTARG"
      ;;
    s)
      # backup tool stream count ( parallel copies")
      STREAMS="$OPTARG"
      ;;
    i)
     ## incremental Max Age in hrs
      INCREMENTAL_MAX_AGE="$OPTARG"
      ;;
    f)
     ## incremental Max Age in hrs
      FULL_MAX_AGE="$OPTARG"
      ;;
    # Invalid option
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
echo echo $@ >> /tmp/rclone.log
echo  "$(printenv)" >> /tmp/rclone.log
echo "entering Backup phase"
if [ -z $BASE_BACKUP_DIR ]; then
    echo "Not provided the backup directory for BASE_BACKUP_DIR"
    exit 1
fi
if [ -z $BACKUP_LEVEL ]; then
    echo "Not provided the backup level for BACKUP_LEVEL"
    exit 1
fi


# Perform a full backup
if [[ "$BACKUP_LEVEL" == "FULL" ]]; then
            COPY_COMMAND=" rclone copy "
            ## do not change multi thread options  need to stay 1!
            ${COPY_COMMAND} --max-age ${FULL_MAX_AGE} --transfers ${STREAMS} --multi-thread-write-buffer-size 512k --multi-thread-streams 1 --progress ${CLOUD_PROFILE}:${BUCKET}${PREFIX} ${BASE_BACKUP_DIR}/  2>&1 >> /tmp/rclone.log
            exit_status=$?
    if [ $exit_status -ne 0 ]; then
       echo "Unable to perform FULL backup"
       exit 1
    fi
    echo "Backup Completed Successfully"
    exit 0

# Perform a log backup
elif [[ "$BACKUP_LEVEL" == "LOG" ]]; then
            COPY_COMMAND=" rclone copy "
            ${COPY_COMMAND} --max-age ${INCREMENTAL_MAX_AGE} --transfers ${STREAMS} --multi-thread-write-buffer-size 512k --multi-thread-streams 1 --progress ${CLOUD_PROFILE}:${BUCKET}${PREFIX} ${BASE_BACKUP_DIR}/  2>&1 >> /tmp/rclone.log
            exit_status=$?
    if [ $exit_status -ne 0 ]; then
       echo "Unable to perform Incremental backup"
       exit 1
    fi
    echo "Backup Completed Successfully"
    exit 0
else
    echo "Invalid backup level. Please specify 'FULL' or 'LOG'."
    exit 1
fi
