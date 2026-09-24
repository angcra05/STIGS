<#
.SYNOPSIS
    This PowerShell script enables PowerShell Script Block Logging by setting the EnableScriptBlockLogging registry value to 1.

.NOTES
    Author          : [Your Name]
    LinkedIn        : linkedin.com/in/[your-linkedin]/
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000326
    Vuln-ID         : V-253414
    Severity        : CAT II
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000326/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    This sets the registry value directly. On GPO-managed systems, configure it in Group Policy instead:
    Computer Configuration > Administrative Templates > Windows Components > Windows PowerShell > Turn on PowerShell Script Block Logging = Enabled
    Example syntax:
    PS C:\> .\remediation-WN11-CC-000326.ps1
#>

#Requires -RunAsAdministrator

# Registry location and value for the Script Block Logging policy
$Path      = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$ValueName = "EnableScriptBlockLogging"

# Create the policy key if it does not exist
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}

# Enable Script Block Logging (1 = Enabled)
New-ItemProperty `
    -Path $Path `
    -Name $ValueName `
    -PropertyType DWord `
    -Value 1 `
    -Force | Out-Null

# Verify the change
$Setting = Get-ItemProperty -Path $Path -Name $ValueName -ErrorAction SilentlyContinue

if ($null -ne $Setting -and $Setting.$ValueName -eq 1) {
    Write-Host "WN11-CC-000326: REMEDIATED" -ForegroundColor Green
    Write-Host "$ValueName = $($Setting.$ValueName)"
} else {
    Write-Host "WN11-CC-000326: FAILED" -ForegroundColor Red
}
