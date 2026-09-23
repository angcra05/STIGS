<#
.SYNOPSIS
    This PowerShell script prevents printing over HTTP by setting the DisableHTTPPrinting registry value to 1.

.NOTES
    Author          : [Your Name]
    LinkedIn        : linkedin.com/in/[your-linkedin]/
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000110
    Vuln-ID         : V-253376
    Severity        : CAT II
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000110/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    Example syntax:
    PS C:\> .\remediation-WN11-CC-000110.ps1
#>

#Requires -RunAsAdministrator

# Registry location and value for the printer policy
$RegPath   = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$ValueName = "DisableHTTPPrinting"

# Create the policy key if it does not exist
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set DisableHTTPPrinting to 1 (Enabled = printing over HTTP is turned off)
New-ItemProperty `
    -Path $RegPath `
    -Name $ValueName `
    -PropertyType DWord `
    -Value 1 `
    -Force | Out-Null

# Verify the change
$Result = Get-ItemProperty -Path $RegPath -Name $ValueName

if ($Result.$ValueName -eq 1) {
    Write-Host "WN11-CC-000110: REMEDIATED" -ForegroundColor Green
    Write-Host "$ValueName = $($Result.$ValueName)"
} else {
    Write-Host "WN11-CC-000110: FAILED" -ForegroundColor Red
}
