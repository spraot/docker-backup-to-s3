#!/bin/bash

set -e

echo "Job started: $(date)"

ARCHIVE=backup.tar.gz
BACKUP_NAME="day_$(date +%u)"
[ "$(date +%u)" -eq 5 ] && BACKUP_NAME="week_$(date +%V)"
[ "$(date +%d)" -eq 1 ] && BACKUP_NAME="month_$(date +%m)"

tar -zcvf "$ARCHIVE" "$DATA_PATH"

aws s3 cp "$ARCHIVE" "$S3_PATH$BACKUP_NAME.tar.gz"

rm $ARCH

echo "Job finished: $(date)"
