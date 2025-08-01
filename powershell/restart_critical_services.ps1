# restart_critical_services.ps1
# Monitors and restarts Windows services if stopped

# Author: abg1122

$servicesToMonitor = @("MSSQLSERVER", "Spooler", "W32Time")  # Add your services here
$logFile = "C:\Scripts\service_monitor_log.txt"

foreach ($svc in $servicesToMonitor) {
    $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($service -and $service.Status -ne 'Running') {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Restart-Service -Name $svc -Force
        Add-Content -Path $logFile -Value "$timestamp - Restarted service: $svc"
    }
}
