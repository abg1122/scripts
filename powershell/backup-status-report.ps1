<#
.SYNOPSIS
    Summarises backup job results for Veeam and/or Acronis and generates a status report.

.DESCRIPTION
    This script checks recent backup job statuses using Veeam PowerShell or local log scraping for Acronis.
    Outputs a summary to screen and optionally logs or emails the result.

.NOTES
    Author: abg1122
    Requirements:
      - Veeam PowerShell Snap-In (for Veeam jobs)
      - Acronis logs accessible on local machine
#>

# Settings
$reportDate = Get-Date -Format "yyyy-MM-dd"
$logPath = "C:\Logs\backup-report-$reportDate.txt"
$report = @()

# --- VEEAM BACKUPS ---
Try {
    Add-PSSnapin VeeamPSSnapIn -ErrorAction SilentlyContinue
    $veeamJobs = Get-VBRJob
    foreach ($job in $veeamJobs) {
        $lastResult = $job.FindLastSession()
        $status = $lastResult.Result
        $report += "Veeam: Job '$($job.Name)' - Status: $status - $(($lastResult.EndTime).ToString('u'))"
    }
} Catch {
    $report += "Veeam: Unable to retrieve job statuses. PowerShell snap-in may not be loaded."
}

# --- ACRONIS BACKUPS (Log file scrape example) ---
$acronisLogPath = "C:\ProgramData\Acronis\BackupAndRecovery\MMS\logs\backup.log"

if (Test-Path $acronisLogPath) {
    $acronisLines = Get-Content $acronisLogPath | Select-String -Pattern "$reportDate" | Select-String -Pattern "Backup plan"
    $acronisSummary = $acronisLines | ForEach-Object {
        ($_ -replace '\s+', ' ').Trim()
    }
    $report += "Acronis:"
    $report += $acronisSummary
} else {
    $report += "Acronis: Log file not found."
}

# Output and log
$report | Out-File -FilePath $logPath -Encoding UTF8
$report | ForEach-Object { Write-Output $_ }

Write-Host "`nBackup status report complete. Output saved to $logPath"
