# 🧰 Script Prerequisites, Notes, and Usage Guide

This document provides **everything** you need to know to use, test, and troubleshoot every script in this repository. It includes prerequisites, common errors, notes, usage tips, and directory structure.

---

## 📁 Repository Structure Overview

```
.
├── windows/
│   ├── Get-StaleADUsers.ps1
│   ├── Bulk-OU-Report.ps1
│   ├── Veeam-Backup-Status.ps1
│   ├── File-Permissions-Audit.ps1
│   ├── group_membership_monitor.ps1
│   ├── restart_critical_services.ps1
│   ├── analyze_eventlog.py
│   ├── pre_deployment_check.py
│
├── linux/
│   ├── restart_critical_services.sh
│   ├── logrotate-custom.sh
│   ├── network-info.sh
│   ├── analyze_syslog.sh
│   └── prometheus_exporter_setup.sh
│
├── cloud/
│   ├── azure_vm.tf
│   ├── aws_instance.tf
│   ├── aws_security_group_audit.py
│   └── ansible-playbook.yml
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── docs/
│   ├── troubleshooting_checklist.md
│   └── prerequisites.md
```

---

## 🖥️ Windows / PowerShell Scripts

### `Get-StaleADUsers.ps1`

* 📌 **Purpose**: Finds disabled/inactive users in AD.
* ✅ **Prereqs**:

  * RSAT: Active Directory Tools
  * PowerShell 5.1+
  * Run as a domain user
* ⚠️ **Mistakes**:

  * Not running in AD-connected domain
  * Missing module: `Install-WindowsFeature RSAT-AD-PowerShell`

---

### `Bulk-OU-Report.ps1`

* 📌 **Purpose**: Inventory of OUs and GPOs.
* ✅ **Prereqs**:

  * `Get-ADOrganizationalUnit` + `Get-GPO` (RSAT, GPMC)
  * PowerShell 5.1+
* 🛠️ **Usage Tip**: Pipe output to CSV using `Export-Csv`.

---

### `Veeam-Backup-Status.ps1`

* 📌 **Purpose**: Gets backup history from Veeam.
* ✅ **Prereqs**:

  * Veeam Backup & Replication PowerShell SnapIn
  * Run on Veeam server or with Veeam Console installed
* ⚠️ **Errors**:

  * SnapIn not loaded: Use `Add-PSSnapin VeeamPSSnapIn`.

---

### `File-Permissions-Audit.ps1`

* 📌 **Purpose**: Recursively audits NTFS ACLs.
* ✅ **Prereqs**:

  * Run as Administrator or user with read ACL rights
  * Works on NTFS drives only

---

### `group_membership_monitor.ps1`

* 📌 **Purpose**: Detects unauthorised members in privileged AD groups.
* ✅ **Prereqs**:

  * RSAT tools
  * PowerShell 5.1+
* ⚠️ **Common Mistake**: Forgetting to update the `$BaselineUsers` list.

---

### `restart_critical_services.ps1`

* 📌 **Purpose**: Monitors and restarts critical Windows services.
* ✅ **Prereqs**:

  * PowerShell 5.1+
  * Local admin rights to restart services
* 🛠️ **Usage**:

  * Schedule via Task Scheduler for periodic checks

---

### `analyze_eventlog.py`

* 📌 **Purpose**: Searches Windows event logs for errors
* ✅ **Prereqs**:

  * Windows OS
  * `pywin32` installed

---

### `pre_deployment_check.py`

* 📌 **Purpose**: Validates CLI tools, ports, env vars
* ✅ **Checks for**:

  * `terraform`, `docker`, `ansible`
  * AWS/Cloud ENV variables
  * Ports 22, 443 to GitHub or cloud target

---

## 🐧 Linux / Bash Scripts

### `restart_critical_services.sh`

* 📌 **Purpose**: Restarts services like `apache2`, `logstash`, etc.
* ✅ **Prereqs**:

  * `systemctl` or `service` available
  * Run as root/sudo

---

### `logrotate-custom.sh`

* 📌 **Purpose**: Rotates and compresses logs manually.
* ✅ **Prereqs**:

  * `gzip`, `mv`, `find`
* ⚠️ **Mistakes**:

  * Not checking write permissions
  * Target log path wrong

---

### `network-info.sh`

* 📌 **Purpose**: Displays network interfaces and port usage.
* ✅ **Prereqs**:

  * `ip`, `netstat`, or `ss`
* ⚠️ **Note**: `net-tools` is deprecated on many systems

---

### `analyze_syslog.sh`

* 📌 **Purpose**: Greps syslog for errors, fails, crashes.
* ✅ **Prereqs**:

  * Path to `/var/log/syslog` or `/var/log/messages`
* 🛠️ **Usage Tip**: Pipe output into `less` or `tee`.

---

### `prometheus_exporter_setup.sh`

* 📌 **Purpose**: Installs node\_exporter for monitoring.
* ✅ **Prereqs**:

  * `wget`, `systemctl`, permissions to `/usr/local/bin`
* 🛠️ **Usage**:

  * Integrates with Prometheus or Grafana

---

## ☁️ Cloud + DevOps

### `azure_vm.tf`

* 📌 **Purpose**: Deploys Azure VM.
* ✅ **Prereqs**:

  * Terraform CLI
  * Azure credentials (`az login` or service principal)
* ⚠️ **Errors**:

  * Missing provider block or region config

---

### `aws_instance.tf`

* 📌 **Purpose**: Launches AWS EC2 instance.
* ✅ **Prereqs**:

  * Terraform CLI
  * AWS CLI credentials

---

### `aws_security_group_audit.py`

* 📌 **Purpose**: Flags 0.0.0.0/0 rules on port 22/3389
* ✅ **Prereqs**:

  * `boto3`
  * AWS credentials in `~/.aws/credentials`

---

### `ansible-playbook.yml`

* 📌 **Purpose**: Installs LAMP or Docker stack on Ubuntu
* ✅ **Prereqs**:

  * `ansible` installed
  * SSH access to target host

---

## 🧪 CI / Automation

### `.github/workflows/ci.yml`

* 📌 **Purpose**: Validates PowerShell and Terraform scripts on push.
* ✅ **Checks**:

  * PowerShell scripts using `PSScriptAnalyzer`
  * Terraform: `init`, `fmt`, and `validate`
  * Ensures YAML/Terraform/Pwsh code syntax is clean
* 🛠️ **Usage Tips**:

  * Push to a branch to trigger the pipeline
  * Modify workflows in `.github/workflows/` to extend coverage
* ⚠️ **Common Pitfall**:

  * GitHub Runner OS must match your script assumptions (e.g., Windows vs Ubuntu)

---

## 📄 Documentation

### `docs/troubleshooting_checklist.md`

* ✅ **Content**: Covers disk space, lockouts, backups, AD, and service restarts
* 📌 Use this for interviews or as a handover doc

### `docs/prerequisites.md`

* ✅ **This document**
* 📌 Lists all environment needs, dependencies, gotchas

---

## 🔐 Security Notes

* Never commit `.env`, `.pem`, or credential files
* Use `.gitignore` (included)
* Review scripts with `secrets` tools if publishing

---


**Maintained by:** Absam Gill

---
