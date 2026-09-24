<#
.SYNOPSIS
    This PowerShell script configures the default autorun behavior to prevent autorun commands by setting the NoAutorun registry value to 1.

.NOTES
    Author          : Angel Caberera
    LinkedIn        : www.linkedin.com/in/angelcabrerajr
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000185
    Vuln-ID         : V-253387
    Severity        : CAT I
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000185/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    This sets the registry value directly. On GPO-managed systems, configure it in Group Policy instead:
    Computer Configuration > Administrative Templates > Windows Components > AutoPlay Policies > Set the default behavior for AutoRun = Enabled: Do not execute any autorun commands
    Example syntax:
    PS C:\> .\remediation-WN11-CC-000185.ps1
#>

#Requires -RunAsAdministrator

# Registry location and value for the AutoRun policy
$Path      = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$ValueName = "NoAutorun"

# Create the policy key if it does not exist
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}

# Set NoAutorun to 1 (Do not execute any autorun commands)
New-ItemProperty `
    -Path $Path `
    -Name $ValueName `
    -PropertyType DWord `
    -Value 1 `
    -Force | Out-Null

# Verify the change
$Result = Get-ItemProperty -Path $Path -Name $ValueName -ErrorAction SilentlyContinue

if ($null -ne $Result -and $Result.$ValueName -eq 1) {
    Write-Host "WN11-CC-000185: REMEDIATED" -ForegroundColor Green
    Write-Host "$ValueName = $($Result.$ValueName)"
} else {
    Write-Host "WN11-CC-000185: FAILED" -ForegroundColor Red
}
