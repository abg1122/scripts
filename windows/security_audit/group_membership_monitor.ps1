# group_membership_monitor.ps1
# Monitors AD group membership for Domain Admins and logs any changes or unexpected users

# Author: abg1122

# Define target group and approved baseline members
$GroupName = "Domain Admins"
$BaselineUsers = @("Administrator", "svc_admin", "abg1122")  # Update to your approved list
$LogPath = "C:\Scripts\group_membership_log.txt"

# Get current members
try {
    $GroupMembers = Get-ADGroupMember -Identity $GroupName -Recursive | Select-Object -ExpandProperty SamAccountName
} catch {
    Write-Error "❌ Could not retrieve group: $GroupName"
    exit 1
}

# Check for deviations
$UnexpectedUsers = $GroupMembers | Where-Object { $_ -notin $BaselineUsers }

# Log the result
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
if ($UnexpectedUsers) {
    foreach ($User in $UnexpectedUsers) {
        $LogEntry = "$Timestamp - ❗ Unauthorized user in '$GroupName': $User"
        Add-Content -Path $LogPath -Value $LogEntry
    }
    Write-Output "⚠️ Unexpected users found. Details logged to $LogPath"
} else {
    $LogEntry = "$Timestamp - ✅ All members of '$GroupName' match baseline."
    Add-Content -Path $LogPath -Value $LogEntry
    Write-Output "All OK"
}
