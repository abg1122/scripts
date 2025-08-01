#!/bin/bash
# analyze_syslog.sh
# Scans /var/log/syslog for common error keywords

# Author: abg1122

LOGFILE="/var/log/syslog"
KEYWORDS=("error" "fail" "fatal" "segfault" "denied")
OUTPUT="/tmp/log_errors_$(date +%F_%H-%M).log"

echo "Scanning $LOGFILE for common error patterns..."
for WORD in "${KEYWORDS[@]}"; do
  grep -i "$WORD" "$LOGFILE" >> "$OUTPUT"
done

echo "Results saved to: $OUTPUT"
