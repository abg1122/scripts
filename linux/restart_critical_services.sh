#!/bin/bash
# restart_critical_services.sh
# Monitors and restarts Linux services if inactive

# Author: abg1122

SERVICES=("logstash" "apache2" "mysql")  # Add your services here
LOGFILE="/var/log/service_monitor.log"

for SERVICE in "${SERVICES[@]}"; do
  if ! systemctl is-active --quiet "$SERVICE"; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    systemctl restart "$SERVICE"
    echo "$TIMESTAMP - Restarted service: $SERVICE" >> "$LOGFILE"
  fi
done
