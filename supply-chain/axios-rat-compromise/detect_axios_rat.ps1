# detect_axios_rat.ps1
# Detects compromised axios npm package versions associated with RAT delivery
# Deploy via JumpCloud Custom Command, run as SYSTEM
#
# Author: Keith Oquelí
# Version: 1.0 | May 2026

$CompromisedVersions = @("1.14.1", "0.30.4")
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Hostname = $env:COMPUTERNAME
$LoggedInUser = (Get-WMIObject -class Win32_ComputerSystem | Select-Object -ExpandProperty UserName).Split('\')[1]
$Findings = 0

Write-Output "============================================"
Write-Output "axios RAT Detection Script"
Write-Output "Timestamp: $Timestamp"
Write-Output "Hostname:  $Hostname"
Write-Output "User:      $LoggedInUser"
Write-Output "============================================"

# Check if npm is installed
$NpmPath = Get-Command npm -ErrorAction SilentlyContinue
if (-not $NpmPath) {
    Write-Output "npm not found on this endpoint. No axios packages to scan."
    Write-Output "============================================"
    exit 0
}

# Check global npm packages
Write-Output "Scanning global npm packages..."
$GlobalAxios = npm list -g axios --depth=0 2>$null

if ($GlobalAxios) {
    foreach ($Version in $CompromisedVersions) {
        if ($GlobalAxios -match $Version) {
            Write-Output "CRITICAL: Compromised axios v$Version found in global npm packages"
            Write-Output $GlobalAxios
            $Findings++
        }
    }
}
# Check for RAT artifact
Write-Output "Checking for RAT artifacts..."
$RatArtifact = "$env:PROGRAMDATA\wt.exe"
if (Test-Path $RatArtifact) {
    Write-Output "CRITICAL: RAT artifact detected at $RatArtifact"
    Write-Output "ACTION:    Endpoint is compromised. Isolate immediately and rotate all credentials."
    $Findings++
}

# Check for malicious plain-crypto-js dependency
Write-Output "Checking for malicious plain-crypto-js dependency..."
$PlainCryptoSearch = Get-ChildItem -Path "C:\Users\$LoggedInUser" -Recurse -Filter "plain-crypto-js" -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
if ($PlainCryptoSearch) {
    Write-Output "CRITICAL: Malicious plain-crypto-js dependency found at $($PlainCryptoSearch.FullName)"
    $Findings++
}
# Search common project directories
Write-Output "Scanning common project directories..."
$SearchDirs = @(
    "C:\Users\$LoggedInUser\Documents",
    "C:\Users\$LoggedInUser\Desktop",
    "C:\Users\$LoggedInUser\Projects",
    "C:\inetpub",
    "C:\dev"
)

foreach ($Dir in $SearchDirs) {
    if (Test-Path $Dir) {
        $PackageFiles = Get-ChildItem -Path $Dir -Recurse -Filter "package.json" -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notlike "*\node_modules\*" }

        foreach ($PackageFile in $PackageFiles) {
            $ProjectDir = $PackageFile.DirectoryName
            $AxiosPackage = "$ProjectDir\node_modules\axios\package.json"

            if (Test-Path $AxiosPackage) {
                $AxiosVersion = (Get-Content $AxiosPackage | ConvertFrom-Json).version
                foreach ($Version in $CompromisedVersions) {
                    if ($AxiosVersion -eq $Version) {
                        Write-Output "CRITICAL: Compromised axios v$Version found in $ProjectDir"
                        $Findings++
                    }
                }
            }
        }
    }
}

Write-Output "============================================"
if ($Findings -gt 0) {
    Write-Output "STATUS:    CRITICAL - $Findings compromised axios installation(s) found"
    Write-Output "ACTION:    Isolate endpoint and escalate to Security Operations immediately"
    exit 1
} else {
    Write-Output "STATUS:    CLEAN - No compromised axios versions detected"
    exit 0
}