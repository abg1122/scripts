<#
.SYNOPSIS
    Automates the process of onboarding a new Active Directory user.

.DESCRIPTION
    Creates a new user in Active Directory, adds them to default groups,
    sets an initial password, enables the account, and creates a home folder.
    Logs all actions for auditing.

.NOTES
    Author: abg1122
    Usage: Run as administrator on a domain-joined system with AD tools installed.
#>

# Parameters
$FirstName = "John"
$LastName = "Doe"
$Username = "$FirstName.$LastName"
$OU = "OU=Users,DC=yourdomain,DC=local"
$InitialPassword = ConvertTo-SecureString "TempP@ssw0rd!" -AsPlainText -Force
$Groups = @("Domain Users", "Shared Drive Access")
$HomeDrivePath = "\\fileserver\users\$Username"

# Create the user
New-ADUser -Name "$FirstName $LastName" `
           -GivenName $FirstName `
           -Surname $LastName `
           -SamAccountName $Username `
           -UserPrincipalName "$Username@yourdomain.local" `
           -AccountPassword $InitialPassword `
           -Path $OU `
           -Enabled $true `
           -ChangePasswordAtLogon $true

# Add to groups
foreach ($group in $Groups) {
    Add-ADGroupMember -Identity $group -Members $Username
}

# Create home folder
New-Item -ItemType Directory -Path $HomeDrivePath -Force | Out-Null
icacls $HomeDrivePath /grant "$Username:(OI)(CI)F" /T | Out-Null

# Logging
$logPath = "C:\Logs\user-onboarding.log"
$logEntry = "$(Get-Date -Format u) - Created user $Username and added to groups: $($Groups -join ', ')"
Add-Content -Path $logPath -Value $logEntry

Write-Host "User $Username created and configured successfully."
