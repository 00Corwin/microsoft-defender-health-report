# Microsoft Defender Local Health Report

A local PowerShell collector for Microsoft Defender Antivirus status,
configuration and threat-detection data.

It records the service/protection state, engine and platform information,
security-intelligence version and update time, Defender preferences, and local
threat detections to JSON.

## Example

```powershell
.\Get-DefenderHealthReport.ps1
```

The output is intended for troubleshooting, rollout validation and comparing an
endpoint against an expected configuration. It does not call cloud Defender
APIs and contains no tenant-specific identifiers in the code.
