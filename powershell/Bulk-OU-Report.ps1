<#
.SYNOPSIS
    Generates a report of all Organizational Units (OUs) and their linked Group Policy Objects (GPOs).

.DESCRIPTION
    This script scans all OUs in Active Directory and outputs:
    - OU name and distinguished name
    - Linked GPOs (if any)
    - GPO link order and enforcement status

.NOTES
    Author: abg1122
    Requires: RSAT GroupPolicy and ActiveDirectory modules
#>

Import-Module ActiveDirectory
Import-Module GroupPolicy

# --- Output File ---
$ReportPath = ".\OU_GPO_Report.csv"
$Report = @()

# --- Get all OUs ---
$OUs = Get-ADOrganizationalUnit -Filter *

foreach ($OU in $OUs) {
    $GPOLinks = Get-GPInheritance -Target $OU.DistinguishedName

    foreach ($GPO in $GPOLinks.GpoLinks) {
        $Report += [PSCustomObject]@{
            OU_Name           = $OU.Name
            OU_Distinguished  = $OU.DistinguishedName
            GPO_Name          = $GPO.DisplayName
            GPO_Enforced      = $GPO.Enforced
            GPO_LinkOrder     = $GPO.LinkOrder
        }
    }

    # If no GPOs linked
    if ($GPOLinks.GpoLinks.Count -eq 0) {
        $Report += [PSCustomObject]@{
            OU_Name           = $OU.Name
            OU_Distinguished  = $OU.DistinguishedName
            GPO_Name          = "None"
            GPO_Enforced      = "-"
            GPO_LinkOrder     = "-"
        }
    }
}

# --- Export to CSV ---
$Report | Export-Csv -NoTypeInformation -Path $ReportPath
Write-Host "`nOU + GPO Report saved to: $ReportPath"
