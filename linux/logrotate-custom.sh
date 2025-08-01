#!/bin/bash

# logrotate-custom.sh
# Rotates a log file, compresses the previous version, and maintains only N backups

# Author: abg1122

# === Configuration ===
LOG_FILE="/var/log/myapp/app.log"
ROTATE_COUNT=5

# === Begin ===
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
DIRNAME=$(dirname "$LOG_FILE")
BASENAME=$(basename "$LOG_FILE")

# Ensure log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file does not exist: $LOG_FILE"
    exit 1
fi

# Rotate the current log
mv "$LOG_FILE" "$LOG_FILE.$TIMESTAMP"
touch "$LOG_FILE"
gzip "$LOG_FILE.$TIMESTAMP"

# Delete older logs beyond retention
cd "$DIRNAME" || exit
ls -tp "$BASENAME".*.gz | grep -v '/$' | tail -n +$((ROTATE_COUNT + 1)) | xargs -r rm --

echo "Log rotation complete. Retained $ROTATE_COUNT backups."
