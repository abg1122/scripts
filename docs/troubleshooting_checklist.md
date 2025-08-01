 Troubleshooting Checklist.

Author: abg1122  

---

## 🔹 1. Disk Space Issues
- [ ] Run `df -h` to check mount usage
- [ ] Identify large files: `du -sh /* | sort -hr | head -20`
- [ ] Rotate or delete old logs in `/var/log`, `C:\Windows\Temp`, etc.
- [ ] Verify if backups or snapshots are consuming space

---

## 🔹 2. Account Lockouts
- [ ] Use `Get-EventLog -LogName Security -Newest 1000 | Where-Object { $_.EventID -eq 4740 }`
- [ ] Check AD replication delays
- [ ] Look for mapped drives or scheduled tasks with old passwords

---

## 🔹 3. Service Failures
- [ ] Run `systemctl status <service>` (Linux) or `Get-Service` (Windows)
- [ ] Check relevant logs (`journalctl`, Event Viewer)
- [ ] Restart the service and monitor for immediate failure
- [ ] Confirm required dependencies (e.g., SQL, network shares)

---

## 🔹 4. Network Connectivity
- [ ] Test name resolution: `nslookup`, `dig`, `Resolve-DnsName`
- [ ] Ping local gateway, DNS, target server
- [ ] Use `traceroute` or `Test-NetConnection` to trace path
- [ ] Check firewall rules or ACLs

---

## 🔹 5. Backup Failures
- [ ] Check job logs (Veeam, Acronis, etc.)
- [ ] Verify cloud connectivity or repository space
- [ ] Restart backup agent or service
- [ ] Run test backup manually

---

## 🔹 6. VM Performance/Access Issues
- [ ] Check resource allocation (vCPU, RAM)
- [ ] Review VM tools/agent health
- [ ] Snapshot age and disk usage
- [ ] Review host performance (ESXi or Hyper-V)

---

## 🔹 7. Cloud Access Errors
- [ ] Validate credentials and roles (Azure/AWS IAM)
- [ ] Check endpoint reachability (proxy/firewall)
- [ ] Confirm subscription/usage limits not exceeded

---

## 🔹 8. Audit/Compliance Checks
- [ ] Review AD user activity via PowerShell
- [ ] Check GPO link and enforcement
- [ ] Audit NTFS permissions and access logs
