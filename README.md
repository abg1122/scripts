This repo contains a collection of PowerShell and Bash scripts I’ve developed and used in real-world 3rd line support and infrastructure operations. These scripts have been used to automate repetitive tasks, improve monitoring, and enhance team efficiency across hybrid Windows/Linux environments.

## 🛠 Scripts Overview

### PowerShell
- **user-onboarding.ps1** – Automates new AD user creation, group assignment, folder setup, and logging.
- **disk-space-monitor.ps1** – Monitors disk usage and sends alerts when thresholds are crossed.
- **backup-status-report.ps1** – Pulls Acronis/Veeam backup job results and formats a summary.
- **scheduled-task-cleanup.ps1** – Lists and removes stale scheduled tasks by criteria.

### Bash
- **log-cleanup.sh** – Rotates and archives logs older than X days.
- **service-check.sh** – Checks and restarts critical services on a Linux system.
- **disk-usage-alert.sh** – Sends an alert when disk partitions exceed a threshold.

## 🔒 Notes
All sensitive details (e.g. usernames, domain names, tokens) have been stripped or anonymised.
