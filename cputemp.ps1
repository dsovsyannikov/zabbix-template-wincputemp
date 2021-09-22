[System.Reflection.Assembly]::LoadFile("C:\zabbix\ps\LibreHardwareMonitorLib.dll") | Out-Null

$PC = New-Object LibreHardwareMonitor.Hardware.Computer
$PC.IsCpuEnabled = $true
$PC.Open()
Switch ($args[0]) {
    "CPU" {
        $CPUID=$args[1]
        @{
        'data' = @($PC.Hardware.Sensors | where { $_.Identifier -match "^$CPUID$" } | select Value
        ) } | ConvertTo-Json
    }
    Default {
        @{
        'data' = @($PC.Hardware.Sensors | where { $_.SensorType -eq "Temperature" -and $_.Name -notmatch "Distance" } | select Name,Identifier
        ) } | ConvertTo-Json
    }
}

$PC.Close();
# UserParameter=cputemp[*],powershell -NoProfile -ExecutionPolicy Bypass -File "C:\zabbix\ps\cputemp.ps1" "$1" "$2"