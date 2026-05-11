# detect_gemini_nano.ps1
# Detects the presence of Google Chrome Gemini Nano model weights on Windows
# Deploy via JumpCloud Custom Command, run as SYSTEM
#
# Author: Keith A. Oquelí | Security Operations Manager, GRC
# Version: 1.0 | May 2026

$LoggedInUser = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty UserName).Split('\')[1]
$ModelPath = Get-ChildItem -Path "C:\Users\$LoggedInUser\AppData\Local\Google\Chrome\User Data\OptGuideOnDeviceModel" -Recurse -Filter "weights.bin" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
$Hostname = $env:COMPUTERNAME
$Username = $LoggedInUser
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Output "============================================"
Write-Output "Gemini Nano Detection Script"
Write-Output "Timestamp: $Timestamp"
Write-Output "Hostname:  $Hostname"
Write-Output "User:      $Username"
Write-Output "============================================"

if (Test-Path $ModelPath) {
    $FileInfo = Get-Item $ModelPath
    $SizeGB = [math]::Round($FileInfo.Length / 1GB, 2)
    $SizeBytes = $FileInfo.Length
    $Modified = $FileInfo.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")

    Write-Output "STATUS:    FOUND"
    Write-Output "Path:      $ModelPath"
    Write-Output "Size:      $SizeGB GB ($SizeBytes bytes)"
    Write-Output "Modified:  $Modified"
    Write-Output "============================================"
    Write-Output "ACTION REQUIRED: Gemini Nano model weights detected."
    Write-Output "Review remediation options in security advisory."
    exit 1
} else {
    Write-Output "STATUS:    NOT FOUND"
    Write-Output "Path checked: $ModelPath"
    Write-Output "============================================"
    Write-Output "No action required on this endpoint."
    exit 0
}