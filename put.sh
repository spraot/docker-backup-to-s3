#!/bin/bash

set -e

echo "Job started: $(date)"

ARCHIVE=backup.tar.gz
BACKUP_NAME="day_$(date +%u)"
[ "$(date +%u)" -eq 5 ] && BACKUP_NAME="week_$(date +%V)"
[ "$(date +%d)" -eq 1 ] && BACKUP_NAME="month_$(date +%m)"

if [ -f "$ARCHIVE" ] ; then
    rm "$ARCHIVE"
fi

ARGS=-zcf
EXCLUDE_FILE=/app/data/excludes
if [ -f "$EXCLUDE_FILE" ] ; then
    ARGS="-X $EXCLUDE_FILE $ARGS"
fi

tar $ARGS "$ARCHIVE" "$DATA_PATH"

/usr/local/bin/aws s3 cp "$ARCHIVE" "$S3_PATH$BACKUP_NAME.tar.gz"

rm $ARCHIVE

echo "Job finished: $(date)"
