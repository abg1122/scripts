<#
.SYNOPSIS
    Cleans up old or disabled scheduled tasks.

.DESCRIPTION
    Finds and optionally deletes scheduled tasks that have not run in a long time
    or are disabled. Helps prevent clutter and reduce risk from forgotten tasks.

.NOTES
    Author: abg1122
    Run as administrator.
#>

param (
    [int]$OlderThanDays = 30,
    [switch]$Delete = $false
)

Write-Host " Searching for scheduled tasks older than $OlderThanDays days or disabled..." -ForegroundColor Cyan

$now = Get-Date
$tasks = Get-ScheduledTask | ForEach-Object {
    $task = $_
    $info = Get-ScheduledTaskInfo -TaskName $task.TaskName -TaskPath $task.TaskPath -ErrorAction SilentlyContinue
    if ($null -ne $info) {
        [PSCustomObject]@{
            TaskName = $task.TaskName
            Path     = $task.TaskPath
            LastRun  = $info.LastRunTime
            Enabled  = $task.Settings.Enabled
        }
    }
}

$staleTasks = $tasks | Where-Object {
    ($_ -and ($_.Enabled -eq $false -or ($_.LastRun -ne $null -and ($now - $_.LastRun).Days -ge $OlderThanDays)))
}

if ($staleTasks.Count -eq 0) {
    Write-Host " No stale or disabled tasks found."
    return
}

Write-Host "`nFound $($staleTasks.Count) stale or disabled task(s):`n" -ForegroundColor Yellow
$staleTasks | Format-Table -AutoSize

if ($Delete) {
    Write-Host "`no Deleting stale tasks..." -ForegroundColor Red
    foreach ($task in $staleTasks) {
        try {
            Unregister-ScheduledTask -TaskName $task.TaskName -TaskPath $task.Path -Confirm:$false
            Write-Host "Deleted: $($task.Path)$($task.TaskName)"
        } catch {
            Write-Host "Failed to delete: $($task.Path)$($task.TaskName) - $_"
        }
    }
} else {
    Write-Host "`no Use -Delete to remove these tasks automatically."
}
