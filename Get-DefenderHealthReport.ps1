<#
.SYNOPSIS
    Collects local Microsoft Defender Antivirus health, configuration and
    threat-detection data.

.PARAMETER OutputPath
    JSON report path.
#>

[CmdletBinding()]
param(
    [string]$OutputPath = ".\DefenderHealth_$($env:COMPUTERNAME)_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
)

$RequiredCommands = @(
    'Get-MpComputerStatus',
    'Get-MpPreference',
    'Get-MpThreatDetection'
)

$Missing = @(
    $RequiredCommands |
        Where-Object { -not (Get-Command $_ -ErrorAction SilentlyContinue) }
)

if ($Missing.Count -gt 0) {
    throw "Required Defender cmdlets are unavailable: $($Missing -join ', ')"
}

$Status = Get-MpComputerStatus
$Preferences = Get-MpPreference
$ThreatDetections = @(Get-MpThreatDetection -ErrorAction SilentlyContinue)

$Summary = [PSCustomObject]@{
    AMServiceEnabled              = $Status.AMServiceEnabled
    AntivirusEnabled              = $Status.AntivirusEnabled
    AntispywareEnabled            = $Status.AntispywareEnabled
    BehaviorMonitorEnabled        = $Status.BehaviorMonitorEnabled
    IoavProtectionEnabled         = $Status.IoavProtectionEnabled
    NISEnabled                    = $Status.NISEnabled
    RealTimeProtectionEnabled     = $Status.RealTimeProtectionEnabled
    AntivirusSignatureVersion     = $Status.AntivirusSignatureVersion
    AntivirusSignatureLastUpdated = $Status.AntivirusSignatureLastUpdated
    AMEngineVersion               = $Status.AMEngineVersion
    AMProductVersion              = $Status.AMProductVersion
    ComputerState                 = $Status.ComputerState
}

$Report = [PSCustomObject]@{
    ComputerName     = $env:COMPUTERNAME
    CollectedAt      = (Get-Date).ToString('o')
    Summary          = $Summary
    ComputerStatus   = $Status
    Preferences      = $Preferences
    ThreatDetections = $ThreatDetections
}

$Report |
    ConvertTo-Json -Depth 10 |
    Set-Content -Path $OutputPath -Encoding UTF8

$Summary | Format-List
Write-Output "Full Defender report written to: $OutputPath"
