<#
.SYNOPSIS
    Retrieves the status of recent Veeam backup jobs.

.DESCRIPTION
    This script connects to the Veeam Backup & Replication server using the Veeam PowerShell Snap-In
    and outputs the last session results of all backup jobs.

.NOTES
    Author: abg1122
    Requires: Veeam Backup PowerShell SnapIn
#>

# --- Load Veeam PowerShell Snap-In ---
if (-not (Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue)) {
    Add-PSSnapin VeeamPSSnapIn
}

# --- Configuration ---
$ReportPath = ".\Veeam_Backup_Job_Report.csv"
$CutoffDays = 7
$CutoffDate = (Get-Date).AddDays(-$CutoffDays)

# --- Fetch Jobs ---
$Jobs = Get-VBRJob

$JobReport = foreach ($Job in $Jobs) {
    $LastSession = Get-VBRBackupSession | Where-Object {
        $_.JobName -eq $Job.Name -and $_.CreationTime -ge $CutoffDate
    } | Sort-Object CreationTime -Descending | Select-Object -First 1

    if ($LastSession) {
        [PSCustomObject]@{
            JobName      = $Job.Name
            Status       = $LastSession.Result
            StartTime    = $LastSession.CreationTime
            EndTime      = $LastSession.EndTime
            Duration     = ($LastSession.EndTime - $LastSession.CreationTime).ToString()
        }
    }
    else {
        [PSCustomObject]@{
            JobName      = $Job.Name
            Status       = "No sessions found in last $CutoffDays days"
            StartTime    = "-"
            EndTime      = "-"
            Duration     = "-"
        }
    }
}

# --- Output Report ---
$JobReport | Export-Csv -NoTypeInformation -Path $ReportPath
$JobReport | Format-Table -AutoSize

Write-Host "`nBackup job report saved to: $ReportPath"
