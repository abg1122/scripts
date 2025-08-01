<#
.SYNOPSIS
    Recursively audits NTFS file/folder permissions from a specified root path.

.DESCRIPTION
    This script scans all files and folders under a given root directory
    and exports a report of their access control entries (ACEs).

.NOTES
    Author: abg1122
    Permissions: Requires read access to the target directories
#>

# --- Configuration ---
$StartPath = "C:\Shared"         # Root folder to audit
$ReportPath = ".\NTFS_Permissions_Report.csv"

# --- Collect data ---
$Results = @()

Write-Host "Scanning files and folders under $StartPath..."

Get-ChildItem -Path $StartPath -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $acl = Get-Acl $_.FullName
        foreach ($entry in $acl.Access) {
            $Results += [PSCustomObject]@{
                Path        = $_.FullName
                Identity    = $entry.IdentityReference
                Access      = $entry.FileSystemRights
                Inherited   = $entry.IsInherited
                Type        = $entry.AccessControlType
            }
        }
    }
    catch {
        Write-Warning "Failed to read ACL for $_.FullName"
    }
}

# --- Export report ---
$Results | Export-Csv -Path $ReportPath -NoTypeInformation
Write-Host "`nNTFS permission report saved to: $ReportPath"
