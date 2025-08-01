#!/usr/bin/env python3

"""
multi_server_health_check.py

Connects to a list of Linux servers via SSH and checks:
- CPU load
- Memory usage
- Disk usage

Logs output and prints alerts if thresholds are exceeded.

Author: abg1122
"""

import paramiko
import datetime
import os

# Configuration
servers = [
    {"host": "192.168.1.10", "user": "admin", "password": "yourpass"},
    {"host": "192.168.1.11", "user": "admin", "password": "yourpass"}
]

CPU_THRESHOLD = 80       # Percentage
MEM_THRESHOLD = 85       # Percentage
DISK_THRESHOLD = 90      # Percentage

log_file = "health_check.log"


def log(message):
    """Logs a message with timestamp to file and stdout."""
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    full_message = f"[{timestamp}] {message}"
    print(full_message)
    with open(log_file, "a") as f:
        f.write(full_message + "\n")


def ssh_command(host, user, password, command):
    """Executes a remote command over SSH and returns output."""
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname=host, username=user, password=password, timeout=10)
        stdin, stdout, stderr = ssh.exec_command(command)
        result = stdout.read().decode().strip()
        ssh.close()
        return result
    except Exception as e:
        log(f"Connection to {host} failed: {e}")
        return None


def check_server(server):
    """Performs health checks on a server: CPU, memory, and disk."""
    host = server["host"]
    user = server["user"]
    password = server["password"]

    log(f"Checking server: {host}")

    # CPU Load (1-minute average)
    cpu_cmd = "uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1"
    cpu_raw = ssh_command(host, user, password, cpu_cmd)
    if cpu_raw:
        try:
            cpu_load = float(cpu_raw.strip())
            cpu_percent = round(cpu_load * 100 / os.cpu_count(), 2)
            log(f"CPU Load: {cpu_percent}%")
            if cpu_percent > CPU_THRESHOLD:
                log(f"Warning: CPU load on {host} is above threshold.")
        except ValueError:
            log("Unable to parse CPU load output.")

    # Memory usage
    mem_cmd = "free | awk '/Mem:/ { printf(\"%.2f\", $3/$2 * 100.0) }'"
    mem_raw = ssh_command(host, user, password, mem_cmd)
    if mem_raw:
        try:
            mem_percent = float(mem_raw)
            log(f"Memory Usage: {mem_percent}%")
            if mem_percent > MEM_THRESHOLD:
                log(f"Warning: Memory usage on {host} is above threshold.")
        except ValueError:
            log("Unable to parse memory usage output.")

    # Disk usage
    disk_cmd = "df / | awk 'NR==2 { print $5 }' | sed 's/%//g'"
    disk_raw = ssh_command(host, user, password, disk_cmd)
    if disk_raw:
        try:
            disk_percent = int(disk_raw)
            log(f"Disk Usage (/): {disk_percent}%")
            if disk_percent > DISK_THRESHOLD:
                log(f"Warning: Disk usage on {host} is above threshold.")
        except ValueError:
            log("Unable to parse disk usage output.")


def main():
    log("===== Health Check Started =====")
    for server in servers:
        check_server(server)
    log("===== Health Check Completed =====\n")


if __name__ == "__main__":
    main()
