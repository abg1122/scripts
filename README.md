A collection of scripts, automation tools, and infrastructure configs designed to support Systems Administration across hybrid environments.

Built for Windows, Linux, and cloud platforms (Azure/AWS), these tools reflect practical solutions I've used to manage infrastructure, enforce security baselines, and automate repetitive tasks.

---

## 📁 Contents

### 🖥️ Windows / PowerShell

| Script | Description |
|--------|-------------|
| `Get-StaleADUsers.ps1` | Finds disabled/inactive AD users |
| `Bulk-OU-Report.ps1` | Generates OU report with GPO links |
| `Veeam-Backup-Status.ps1` | Lists backup job history from Veeam |
| `File-Permissions-Audit.ps1` | Recursively audits NTFS folder/file permissions |
| `group_membership_monitor.ps1` | Logs unexpected users in privileged AD groups |
| `restart_critical_services.ps1` | Restarts stopped Windows services and logs action |

---

### 🐧 Linux / Bash

| Script | Description |
|--------|-------------|
| `restart_critical_services.sh` | Restarts stopped Linux services and logs them |
| `logrotate-custom.sh` | Manually rotates and compresses logs |
| `network-info.sh` | Prints current IP, open ports, and basic stats |
| `analyze_syslog.sh` | Scans syslog for error/fail/crash patterns |
| `prometheus_exporter_setup.sh` | Installs and enables node_exporter |

---

### ☁️ Cloud & DevOps

| Script | Description |
|--------|-------------|
| `azure_vm.tf` | Deploys a basic Azure VM via Terraform |
| `aws_instance.tf` | Provisions an AWS EC2 with security group |
| `aws_security_group_audit.py` | Detects risky 0.0.0.0/0 rules in AWS Security Groups |
| `ansible-playbook.yml` | Installs LAMP stack or Docker on Ubuntu |
| `.github/workflows/ci.yml` | GitHub Actions pipeline to lint PowerShell/Terraform |
| `pre_deployment_check.py` | Validates env, CLI tools, and ports before deploying |

---

### 🧰 Log & Alerting Tools

| Script | Description |
|--------|-------------|
| `analyze_eventlog.py` | Parses Windows Event Logs for errors and warnings |
| `pre_deployment_check.py` | Verifies env vars, CLI tools, and network before deployment |

---

### 📄 Documentation

| File | Description |
|------|-------------|
| `troubleshooting_checklist.md` | Common steps for resolving disk issues, AD lockouts, service failures, etc. |

---

## 🚀 How to Use

- Scripts are grouped by platform (`windows/`, `linux/`, `cloud/`, `automation/`, `docs/`)
- Each script is fully commented and production-ready
- Designed for real use cases — from backups to monitoring to access control

---

## 🔒 Security & Reliability

- Avoids hardcoded credentials and stores sensitive info in environment variables
- CI validation with GitHub Actions
- Scripts are modular and follow safe error handling practices

---
