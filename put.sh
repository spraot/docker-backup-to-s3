#!/bin/bash

set -e

echo "Job started: $(date)"

IFS=':' read -a DIRS <<< "$EXCLUDES"
for I in ${!DIRS[@]}; do
  DIRS[$I]="--exclude=$(echo "${DIRS[$I]}" | sed 's:/*$::')"
done

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

set +e
for i in {1..5}; do
  tar "${DIRS[@]}" $ARGS "$ARCHIVE" "$DATA_PATH"
  exitcode=$?

  if [ "$exitcode" == "0" ]; then
      break
  fi
  if [ "$exitcode" != "1" ]; then
      exit $exitcode
  fi
  if [ "$i" != "5" ]; then
    echo "Retrying tar command due to file change error"
    sleep 10
  else
    echo "tar command failed after 5 retries"
    exit $exitcode
  fi
done
set -e

/usr/local/bin/aws s3 cp --no-progress "$ARCHIVE" "$S3_PATH$BACKUP_NAME.tar.gz"

rm $ARCHIVE

echo "Job finished: $(date)"
