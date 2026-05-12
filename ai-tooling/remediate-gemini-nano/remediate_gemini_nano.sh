# remediate_gemini_nano.ps1
# Removes Google Chrome Gemini Nano model weights and applies persistent registry policy
# to prevent re-download on Windows managed endpoints
# Deploy via JumpCloud Custom Command, run as SYSTEM
#
# Author: Keith Oquelí
# Version: 1.0 | May 2026
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Hostname = $env:COMPUTERNAME
$LoggedInUser = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty UserName).Split('\')[1]
Write-Output "============================================"
Write-Output "Gemini Nano Remediation Script"
Write-Output "Timestamp: $Timestamp"
Write-Output "Hostname:  $Hostname"
Write-Output "User:      $LoggedInUser"
Write-Output "============================================"
# Find and remove weights.bin
$ModelPath = Get-ChildItem -Path "C:\Users\$LoggedInUser\AppData\Local\Google\Chrome\User Data\OptGuideOnDeviceModel" -Recurse -Filter "weights.bin" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
if ($ModelPath) {
    $VersionDir = Split-Path $ModelPath -Parent
    Remove-Item -Path $VersionDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "REMEDIATED: Removed $ModelPath"
} else {
    Write-Output "NOT FOUND: Gemini Nano weights.bin not present on this endpoint"
    Write-Output "No file removal required"
}
# Apply persistent Chrome registry policy to prevent re-download
$RegistryPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
$RegSuccess = $true
try {
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }
    Set-ItemProperty -Path $RegistryPath -Name "GenAILocalFoundationalModelSettings" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $RegistryPath -Name "OnDeviceModelEnabled" -Value 0 -Type DWord -Force
} catch {
    $RegSuccess = $false
    Write-Output "ERROR: Failed to apply registry policy. Run as administrator or deploy via JumpCloud as SYSTEM."
}
if ($RegSuccess) {
    Write-Output "POLICY:     Chrome registry policy applied"
    Write-Output "POLICY:     GenAILocalFoundationalModelSettings set to 1"
    Write-Output "POLICY:     OnDeviceModelEnabled set to 0"
}
Write-Output "============================================"
Write-Output "Remediation complete. Chrome restart required to apply policy."
exit 0