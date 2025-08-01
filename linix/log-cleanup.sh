#!/bin/bash

##########################################
# log-cleanup.sh
# Rotates and archives logs older than N days
# Author: abg1122
##########################################

# CONFIG
LOG_DIR="/var/log"
ARCHIVE_DIR="/var/log/archive"
DAYS_OLD=30

# Create archive directory if not exists
mkdir -p "$ARCHIVE_DIR"

echo " Searching for log files older than $DAYS_OLD days in $LOG_DIR..."

# Find and compress old log files
find "$LOG_DIR" -type f -name "*.log" -mtime +"$DAYS_OLD" ! -path "$ARCHIVE_DIR/*" | while read -r logfile; do
    filename=$(basename "$logfile")
    archive_file="$ARCHIVE_DIR/${filename}.gz"

    echo "🗜️ Archiving: $logfile -> $archive_file"
    gzip -c "$logfile" > "$archive_file" && rm -f "$logfile"
done

echo " Log cleanup complete."
