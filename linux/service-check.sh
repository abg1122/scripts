#!/bin/bash

############################################
# service-check.sh
# Checks and restarts key services if inactive
# Author: abg1122
############################################

# Services to monitor
services=("logstash" "filebeat" "redis-server")

# Log file
logfile="/var/log/service-check.log"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

echo "=== [$timestamp] Service Check Started ===" >> "$logfile"

# Loop through each service
for svc in "${services[@]}"; do
    systemctl is-active --quiet "$svc"
    if [ $? -ne 0 ]; then
        echo "[$timestamp] $svc is not running. Attempting restart..." | tee -a "$logfile"
        systemctl restart "$svc"
        if [ $? -eq 0 ]; then
            echo "[$timestamp] $svc restarted successfully." | tee -a "$logfile"
        else
            echo "[$timestamp] Failed to restart $svc." | tee -a "$logfile"
        fi
    else
        echo "[$timestamp] $svc is running." >> "$logfile"
    fi
done

echo "=== Service Check Complete ===" >> "$logfile"
