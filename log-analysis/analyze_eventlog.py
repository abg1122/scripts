# analyze_eventlog.py
# Parses Windows Event Logs for critical and error events
# Python script requires pywin32 → install via: pip install pywin32

# Author: abg1122

import win32evtlog
import datetime

server = 'localhost'
log_type = 'Application'
flags = win32evtlog.EVENTLOG_BACKWARDS_READ | win32evtlog.EVENTLOG_SEQUENTIAL_READ

log = win32evtlog.OpenEventLog(server, log_type)
events = win32evtlog.ReadEventLog(log, flags, 0)

output = []

for event in events:
    if event.EventType in [1, 2]:  # 1=Error, 2=Warning
        timestamp = event.TimeGenerated.Format()
        msg = f"{timestamp} - {event.SourceName} - Event ID: {event.EventID} - {event.StringInserts}"
        output.append(msg)

with open("eventlog_errors.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(output))

print("Event log analysis complete. Output written to eventlog_errors.txt")
