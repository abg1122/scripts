<#
.SYNOPSIS
    Finds stale (inactive or disabled) Active Directory user accounts.

.DESCRIPTION
    This script queries Active Directory for users who:
    - Are disabled, OR
    - Have not logged in for the past X days

    It can help with AD cleanup and user audits.

.NOTES
    Author: abg1122
    Requires: RSAT AD module (Import-Module ActiveDirectory)
#>

Import-Module ActiveDirectory

# --- Configuration ---
$DaysInactive = 90
$CutoffDate = (Get-Date).AddDays(-$DaysInactive)

# --- Query for disabled or inactive users ---
$StaleUsers = Get-ADUser -Filter {Enabled -eq $false -or LastLogonDate -lt $CutoffDate} -Properties Name, SamAccountName, Enabled, LastLogonDate |
    Select-Object Name, SamAccountName, Enabled, LastLogonDate |
    Sort-Object LastLogonDate

# --- Output ---
$StaleUsers | Format-Table -AutoSize
$StaleUsers | Export-Csv -NoTypeInformation -Path ".\StaleUsers_Report.csv"

Write-Host "`nTotal stale users found: $($StaleUsers.Count)"
