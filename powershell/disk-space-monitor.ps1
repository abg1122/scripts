<#
.SYNOPSIS
    Monitors disk space usage on all logical drives and sends an alert if thresholds are exceeded.

.DESCRIPTION
    This script checks all local fixed drives. If any drive exceeds the threshold (default 85%), it logs the warning to a file and optionally sends an email.

.NOTES
    Author: abg1122
    Usage: Run via scheduled task or manually on Windows servers.
#>

# Configuration
$threshold = 85
$logPath = "C:\Logs\disk-space-monitor.log"
$alertDrives = @()

# Optional email alert (set to $true to enable)
$sendEmail = $false
$smtpServer = "smtp.yourdomain.local"
$from = "monitor@yourdomain.local"
$to = "sysadmin@yourdomain.local"

# Check each logical drive
$drives = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
foreach ($drive in $drives) {
    $usedPercent = [math]::Round((($drive.Size - $drive.FreeSpace) / $drive.Size) * 100, 2)
    if ($usedPercent -ge $threshold) {
        $message = "$(Get-Date -Format u) - WARNING: Drive $($drive.DeviceID) is at $usedPercent% usage."
        Write-Output $message
        Add-Content -Path $logPath -Value $message
        $alertDrives += $message
    }
}

# Email alert
if ($sendEmail -and $alertDrives.Count -gt 0) {
    $body = $alertDrives -join "`n"
    Send-MailMessage -From $from -To $to -Subject "Disk Space Alert" -Body $body -SmtpServer $smtpServer
}

Write-Host "Disk space check completed.
