#!/usr/bin/env python3

"""
log_monitor.py

Monitors a log file for error patterns and writes alerts to a report file.

Useful for detecting early signs of service failure, unauthorized access,
or other operational issues.

Author: abg1122
"""

import os
import datetime

# === Configuration ===

LOG_FILE_PATH = "/var/log/syslog"           # Path to log file to monitor
OUTPUT_REPORT = "log_alerts.txt"            # Output file for matched lines

KEYWORDS = ["error", "fail", "critical"]    # Keywords to look for (case-insensitive)
LAST_N_LINES = 500                          # How many recent lines to scan

# =====================


def read_last_lines(file_path, num_lines):
    """Reads the last N lines from a log file."""
    try:
        with open(file_path, "rb") as f:
            f.seek(0, os.SEEK_END)
            buffer = bytearray()
            pointer = f.tell()

            while pointer >= 0 and num_lines > 0:
                f.seek(pointer)
                byte = f.read(1)
                if byte == b'\n':
                    num_lines -= 1
                buffer.extend(byte)
                pointer -= 1

            return buffer[::-1].decode(errors="ignore").splitlines()
    except Exception as e:
        print(f"Error reading log file: {e}")
        return []


def scan_for_keywords(lines, keywords):
    """Scans lines for any matching keywords."""
    matched = []
    for line in lines:
        if any(k.lower() in line.lower() for k in keywords):
            matched.append(line)
    return matched


def write_report(matches, report_file):
    """Writes matched log entries to an output report."""
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(report_file, "a") as f:
        f.write(f"\n--- Log scan at {timestamp} ---\n")
        for line in matches:
            f.write(line + "\n")


def main():
    print(f"Scanning last {LAST_N_LINES} lines of {LOG_FILE_PATH}...")

    lines = read_last_lines(LOG_FILE_PATH, LAST_N_LINES)
    if not lines:
        print("No lines read or file missing.")
        return

    matches = scan_for_keywords(lines, KEYWORDS)
    if matches:
        print(f"Found {len(matches)} matching lines.")
        write_report(matches, OUTPUT_REPORT)
        print(f"Report written to {OUTPUT_REPORT}")
    else:
        print("No issues detected.")


if __name__ == "__main__":
    main()
