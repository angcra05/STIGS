<#
.SYNOPSIS
    This PowerShell script enables Kernel DMA Protection by setting the DeviceEnumerationPolicy registry value to 0 (Block all external devices incompatible with Kernel DMA Protection).

.NOTES
    Author          : Angel Cabrera
    LinkedIn        : www.linkedin.com/in/angelcabrerajr
    GitHub          : github.com/angcra05
    Date Created    : 2026-09-21
    Last Modified   : 2026-09-23
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-EP-000310
    Vuln-ID         : V-253426
    Severity        : CAT II
    Documentation   : https://stigaview.com/products/win11/v2r8/WN11-EP-000310/

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Run from an elevated (Administrator) PowerShell session.
    This sets the registry value directly. On GPO-managed systems, configure it in Group Policy instead:
    Computer Configuration > Administrative Templates > System > Kernel DMA Protection > Enumeration policy for external devices incompatible with Kernel DMA Protection = Enabled (Block All)
    Example syntax:
    PS C:\> .\remediation-WN11-EP-000310.ps1
#>

#Requires -RunAsAdministrator

# Registry location and value for the Kernel DMA Protection policy
$Path      = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Kernel DMA Protection"
$ValueName = "DeviceEnumerationPolicy"

# Create the policy key if it does not exist
if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
}

# Set DeviceEnumerationPolicy to 0 (Block all)
New-ItemProperty `
    -Path $Path `
    -Name $ValueName `
    -PropertyType DWord `
    -Value 0 `
    -Force | Out-Null

# Verify the change
$Result = Get-ItemProperty -Path $Path -Name $ValueName -ErrorAction SilentlyContinue

if ($null -ne $Result -and $Result.$ValueName -eq 0) {
    Write-Host "WN11-EP-000310: REMEDIATED" -ForegroundColor Green
    Write-Host "$ValueName = $($Result.$ValueName)"
} else {
    Write-Host "WN11-EP-000310: FAILED" -ForegroundColor Red
}
