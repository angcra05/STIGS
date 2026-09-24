<#
.SYNOPSIS
    This PowerShell script configures the account lockout duration to 15 minutes by setting the local "Account lockout duration" policy.

.NOTES
    Author          : Angel Cabrera
    LinkedIn        : www.linkedin.com/in/angelcabrerajr
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000005
    Vuln-ID         : V-253297
    Severity        : CAT II
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-AC-000005/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    This sets the LOCAL policy. On GPO-managed systems, configure the setting in Group Policy instead:
    Computer Configuration > Windows Settings > Security Settings > Account Policies > Account Lockout Policy > Account lockout duration = 15 minutes or greater
    Example syntax:
    PS C:\> .\remediation-WN11-AC-000005.ps1
#>

#Requires -RunAsAdministrator

$Required = 15

# Set the account lockout duration to 15 minutes
Write-Host "Setting account lockout duration to $Required minutes..." -ForegroundColor Cyan
net accounts /lockoutduration:$Required | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "WN11-AC-000005: FAILED (net accounts returned an error)" -ForegroundColor Red
    exit 1
}

# Verify the change using the exported local security policy
Write-Host "`nVerifying configuration..." -ForegroundColor Cyan
$CfgPath = Join-Path $env:TEMP "secpol.cfg"
secedit /export /cfg $CfgPath /quiet
$Setting = Select-String -Path $CfgPath -Pattern "^LockoutDuration"
$Current = [int](($Setting.Line -split "=")[1].Trim())
Remove-Item $CfgPath -Force -ErrorAction SilentlyContinue

# STIG requires 15 or greater; 0 (or -1 in the export) means an administrator must unlock the account, which is also acceptable
if ($Current -ge $Required -or $Current -le 0) {
    Write-Host "WN11-AC-000005: REMEDIATED" -ForegroundColor Green
    Write-Host "LockoutDuration = $Current"
} else {
    Write-Host "WN11-AC-000005: FAILED" -ForegroundColor Red
    Write-Host "LockoutDuration = $Current (expected $Required or greater)"
}
