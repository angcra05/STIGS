# STIGS
STIG Portfolio


## Windows 11 security configuration scripts

This repository contains ten PowerShell scripts for targeted Windows 11 configuration changes. The inventory below is derived from the checked-in code. These are individual configuration scripts, not a full compliance scanner or a claim of complete STIG compliance.

| Script | Implemented change |
| --- | --- |
| [1-remediation-WN11-CC-000315.ps1](1-remediation-WN11-CC-000315.ps1) | Set machine AlwaysInstallElevated to 0 |
| [2-remediation-WN11-CC-000110.ps1](2-remediation-WN11-CC-000110.ps1) | Set DisableHTTPPrinting to 1 |
| [3-remediation-WN11-AC-000020.ps1](3-remediation-WN11-AC-000020.ps1) | Set password history to 24 |
| [4-remediation-WN11-SO-000025.ps1](4-remediation-WN11-SO-000025.ps1) | Rename the built-in Guest account if still named Guest |
| [5-remediation-WN11-EP-000310.ps1](5-remediation-WN11-EP-000310.ps1) | Set DeviceEnumerationPolicy to 0 |
| [6-remediation-WN11-CC-000035.ps1](6-remediation-WN11-CC-000035.ps1) | Set NoNameReleaseOnDemand to 1 |
| [7-remediation-WN11-CC-000326.ps1](7-remediation-WN11-CC-000326.ps1) | Set EnableScriptBlockLogging to 1 |
| [8-remediation-WN11-CC-000185.ps1](8-remediation-WN11-CC-000185.ps1) | Set NoAutorun to 1 |
| [9-remediation-WN11-AC-000010.ps1](9-remediation-WN11-AC-000010.ps1) | Set lockout threshold to 3 |
| [10-remediation-WN11-AC-000005.ps1](10-remediation-WN11-AC-000005.ps1) | Set lockout duration to 15 minutes |

## Validation status

The scripts include administrator requirements and local readback logic. Their `.TESTED ON` fields are blank, and this repository currently contains no execution transcripts or before/after compliance scan. Do not interpret a printed REMEDIATED message as independent proof of compliance. The STIG identifiers and version links come from the existing script headers; their current applicability has not been revalidated here.

## Review and use

Read the chosen script before running it in a disposable Windows lab. Record the original setting, prepare a rollback, and execute only the individual change you intend to evaluate. These scripts require an elevated PowerShell session. On managed devices, review effective Group Policy because local changes may be overwritten. Account lockout changes can affect access; the duration, threshold, and reset window must be considered together.

The DMA script sets a policy value; that alone does not establish hardware or firmware support. The Guest script renames the account but does not disable it. The installer script writes the machine policy only. These boundaries matter when evaluating a broader security requirement.

## Evidence to add after testing

Record the Windows build, PowerShell version, original value, exact script revision, execution output, effective policy after refresh or restart, and independent validation result. Keep failed tests as well as successful ones. No test results have been invented to fill the blank records.

[Related vulnerability-management case study](https://github.com/angcra05/Vulnerability_Management)
