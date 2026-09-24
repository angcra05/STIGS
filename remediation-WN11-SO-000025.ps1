<#
.SYNOPSIS
    This PowerShell script renames the built-in Guest account (the local account with the SID ending in -501) to a name other than "Guest".

.NOTES
    Author          : [Your Name]
    LinkedIn        : linkedin.com/in/[your-linkedin]/
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000025
    Vuln-ID         : V-253436
    Severity        : CAT II
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-SO-000025/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    The built-in Guest account is found by its well-known SID (ending in -501), so the script still works if it has already been renamed.
    Use -NewName to choose the new account name (default: AngelGuest). It must not be "Guest".
    Example syntax:
    PS C:\> .\remediation-WN11-SO-000025.ps1
    PS C:\> .\remediation-WN11-SO-000025.ps1 -NewName "MyNewName"
#>

#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [string]$NewName = "AngelGuest"
)

if ($NewName -ieq "Guest") {
    Write-Host "WN11-SO-000025: FAILED (the new name cannot be 'Guest')" -ForegroundColor Red
    exit 1
}

# Find the built-in Guest account by its well-known SID (always ends in -501)
$Guest = Get-LocalUser | Where-Object { $_.SID.Value -match '-501$' }

if (-not $Guest) {
    Write-Host "WN11-SO-000025: FAILED (built-in Guest account not found)" -ForegroundColor Red
    exit 1
}

Write-Host "Current name of built-in Guest account: $($Guest.Name)" -ForegroundColor Cyan

# Rename only if it is still named "Guest"
if ($Guest.Name -ieq "Guest") {
    Rename-LocalUser -Name $Guest.Name -NewName $NewName
}

# Verify the change
$Result = Get-LocalUser | Where-Object { $_.SID.Value -match '-501$' }

if ($Result.Name -ine "Guest") {
    Write-Host "WN11-SO-000025: REMEDIATED" -ForegroundColor Green
    $Result | Select-Object Name, Enabled, SID
} else {
    Write-Host "WN11-SO-000025: FAILED" -ForegroundColor Red
}
