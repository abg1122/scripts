#!/bin/bash

############################################
# disk-usage-alert.sh
# Checks disk usage and logs warning if above threshold
# Author: abg1122
############################################

# Configuration
threshold=85
logfile="/var/log/disk-usage-alert.log"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

echo "=== [$timestamp] Disk Usage Check ===" >> "$logfile"

# Get list of mounted file systems excluding tmpfs, devtmpfs
df -h --output=target,pcent | grep -vE 'Filesystem|tmpfs|devtmpfs' | while read -r line; do
    mount_point=$(echo $line | awk '{print $1}')
    usage=$(echo $line | awk '{print $2}' | tr -d '%')

    if [ "$usage" -ge "$threshold" ]; then
        echo "[$timestamp] WARNING: $mount_point is at ${usage}% usage." | tee -a "$logfile"
    else
        echo "[$timestamp] OK: $mount_point is at ${usage}%." >> "$logfile"
    fi
done

echo "=== Disk Usage Check Complete ===" >> "$logfile"
