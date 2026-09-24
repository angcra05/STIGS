<#
.SYNOPSIS
    This PowerShell script configures the account lockout threshold to 3 invalid logon attempts by setting the local "Account lockout threshold" policy.

.NOTES
    Author          : [Your Name]
    LinkedIn        : linkedin.com/in/[your-linkedin]/
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000010
    Vuln-ID         : V-253298
    Severity        : CAT II
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-AC-000010/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    This sets the LOCAL policy. On GPO-managed systems, configure the setting in Group Policy instead:
    Computer Configuration > Windows Settings > Security Settings > Account Policies > Account Lockout Policy > Account lockout threshold = 3 or less (not 0)
    Example syntax:
    PS C:\> .\remediation-WN11-AC-000010.ps1
#>

#Requires -RunAsAdministrator

$Required = 3

# Set the account lockout threshold to 3 invalid logon attempts
Write-Host "Setting account lockout threshold to $Required..." -ForegroundColor Cyan
net accounts /lockoutthreshold:$Required | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "WN11-AC-000010: FAILED (net accounts returned an error)" -ForegroundColor Red
    exit 1
}

# Verify the change using the exported local security policy
Write-Host "`nVerifying configuration..." -ForegroundColor Cyan
$CfgPath = Join-Path $env:TEMP "secpol.cfg"
secedit /export /cfg $CfgPath /quiet
$Setting = Select-String -Path $CfgPath -Pattern "^LockoutBadCount"
$Current = [int](($Setting.Line -split "=")[1].Trim())
Remove-Item $CfgPath -Force -ErrorAction SilentlyContinue

# STIG requires 3 or less, and 0 (never lock out) is not compliant
if ($Current -ge 1 -and $Current -le $Required) {
    Write-Host "WN11-AC-000010: REMEDIATED" -ForegroundColor Green
    Write-Host "LockoutBadCount = $Current"
} else {
    Write-Host "WN11-AC-000010: FAILED" -ForegroundColor Red
    Write-Host "LockoutBadCount = $Current (expected 1 to $Required)"
}
