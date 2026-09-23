<#
.SYNOPSIS
    This PowerShell script ensures that the Windows Installer feature "Always install with elevated privileges" is disabled by setting the AlwaysInstallElevated registry value to 0.

.NOTES
    Author          : Angel Cabrera
    LinkedIn        : www.linkedin.com/in/angelcabrerajr
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-20
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000315
    Vuln-ID         : V-253411
    Severity        : CAT I
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000315/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    Example syntax:
    PS C:\> .\remediation-WN11-CC-000315.ps1
#>

#Requires -RunAsAdministrator

# Registry location for the Windows Installer policy
$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"

# Create the policy key if it does not exist (-Force also allows safe re-runs)
New-Item -Path $Path -Force | Out-Null

# Set AlwaysInstallElevated to 0 (Disabled)
New-ItemProperty `
    -Path $Path `
    -Name "AlwaysInstallElevated" `
    -PropertyType DWord `
    -Value 0 `
    -Force | Out-Null

Write-Host "WN11-CC-000315 remediation applied." -ForegroundColor Green

# Verify the change
Get-ItemProperty -Path $Path -Name "AlwaysInstallElevated" |
    Select-Object PSPath, AlwaysInstallElevated
