<#
.SYNOPSIS
    This PowerShell script configures the system to ignore NetBIOS name release requests except from WINS servers by setting the NoNameReleaseOnDemand registry value to 1.

.NOTES
    Author          : Angel Cabrera
    LinkedIn        : www.linkedin.com/in/angelcabrerajr
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000035
    Vuln-ID         : V-253356
    Severity        : CAT III
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-CC-000035/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    This sets the registry value directly. On GPO-managed systems, configure it in Group Policy instead:
    Computer Configuration > Administrative Templates > MSS (Legacy) > MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers = Enabled
    Example syntax:
    PS C:\> .\remediation-WN11-CC-000035.ps1
#>

#Requires -RunAsAdministrator

# Registry location and value for the NetBT parameters
$Path      = "HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters"
$ValueName = "NoNameReleaseOnDemand"

# Create the key if it does not exist
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}

# Set NoNameReleaseOnDemand to 1 (Enabled)
New-ItemProperty `
    -Path $Path `
    -Name $ValueName `
    -PropertyType DWord `
    -Value 1 `
    -Force | Out-Null

# Verify the change
$Result = Get-ItemProperty -Path $Path -Name $ValueName -ErrorAction SilentlyContinue

if ($null -ne $Result -and $Result.$ValueName -eq 1) {
    Write-Host "WN11-CC-000035: REMEDIATED" -ForegroundColor Green
    Write-Host "$ValueName = $($Result.$ValueName)"
} else {
    Write-Host "WN11-CC-000035: FAILED" -ForegroundColor Red
}
