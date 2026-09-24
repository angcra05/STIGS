<#
.SYNOPSIS
    This PowerShell script configures the password history to remember 24 passwords by setting the local "Enforce password history" policy.

.NOTES
    Author          : Angel Cabrera
    LinkedIn        : www.linkedin.com/in/angelcabrerajr
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000020
    Vuln-ID         : V-253300
    Severity        : CAT II
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-AC-000020/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    This sets the LOCAL policy. On GPO-managed systems, configure the setting in Group Policy instead:
    Computer Configuration > Windows Settings > Security Settings > Account Policies > Password Policy > Enforce password history
    Example syntax:
    PS C:\> .\remediation-WN11-AC-000020.ps1
#>

#Requires -RunAsAdministrator

$Required = 24

# Set the password history to 24 remembered passwords
Write-Host "Setting password history to $Required..." -ForegroundColor Cyan
net accounts /uniquepw:$Required | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "WN11-AC-000020: FAILED (net accounts returned an error)" -ForegroundColor Red
    exit 1
}

# Verify the change using the exported local security policy
Write-Host "`nVerifying configuration..." -ForegroundColor Cyan
$CfgPath = Join-Path $env:TEMP "secpol.cfg"
secedit /export /cfg $CfgPath /quiet
$Setting = Select-String -Path $CfgPath -Pattern "^PasswordHistorySize"
$Current = [int](($Setting.Line -split "=")[1].Trim())
Remove-Item $CfgPath -Force -ErrorAction SilentlyContinue

if ($Current -eq $Required) {
    Write-Host "WN11-AC-000020: REMEDIATED" -ForegroundColor Green
    Write-Host "PasswordHistorySize = $Current"
} else {
    Write-Host "WN11-AC-000020: FAILED" -ForegroundColor Red
    Write-Host "PasswordHistorySize = $Current (expected $Required)"
}
