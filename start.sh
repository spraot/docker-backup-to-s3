#!/bin/bash

set -e

: ${S3_PATH:?"S3_PATH env variable is required"}
export DATA_PATH=${DATA_PATH:-/data/}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

if [[ -n "$AWS_ACCESS_KEY_ID"  &&  -n "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "Credentials found"
else
    echo "WARNING No AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY env variable found, assume use of IAM"
fi

if [[ "$1" == 'no-cron' ]]; then
    exec ./put.sh
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV=""
    CRON_ENV="$CRON_ENV\nAWS_ACCESS_KEY_ID='$AWS_ACCESS_KEY_ID'"
    CRON_ENV="$CRON_ENV\nAWS_SECRET_ACCESS_KEY='$AWS_SECRET_ACCESS_KEY'"
    CRON_ENV="$CRON_ENV\nDATA_PATH='$DATA_PATH'"
    CRON_ENV="$CRON_ENV\nS3_PATH='$S3_PATH'"
    CRON_ENV="$CRON_ENV\nEXCLUDES='$EXCLUDES'"
    echo -e "$CRON_ENV\n$CRON_SCHEDULE $(pwd)/put.sh > $LOGFIFO 2>&1" | crontab -
    cron
    tail -f "$LOGFIFO"
fi
