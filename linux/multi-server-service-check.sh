#!/bin/bash

#########################################################
# multi-server-service-check.sh
# Checks and restarts services on multiple servers via SSH
# Author: abg1122
#########################################################

# Configuration
servers=("server1.domain.local" "server2.domain.local" "server3.domain.local")
services=("logstash" "filebeat" "redis-server")
user="adminuser"
logfile="multi-service-check.log"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

echo "=== [$timestamp] Multi-Server Service Check Started ===" >> "$logfile"

for host in "${servers[@]}"; do
    echo "🔗 Connecting to $host..." | tee -a "$logfile"
    for svc in "${services[@]}"; do
        ssh -o BatchMode=yes "$user@$host" "systemctl is-active --quiet $svc"
        if [ $? -ne 0 ]; then
            echo "[$timestamp] ❌ $svc is not running on $host. Attempting restart..." | tee -a "$logfile"
            ssh "$user@$host" "sudo systemctl restart $svc"
            if [ $? -eq 0 ]; then
                echo "[$timestamp] ✅ $svc restarted successfully on $host." | tee -a "$logfile"
            else
                echo "[$timestamp] ❗ Failed to restart $svc on $host." | tee -a "$logfile"
            fi
        else
            echo "[$timestamp] ✅ $svc is running on $host." >> "$logfile"
        fi
    done
    echo "---" >> "$logfile"
done

echo "=== [$timestamp] Multi-Server Service Check Complete ===" >> "$logfile"
