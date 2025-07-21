<#
.SYNOPSIS
    Installs and configures Windows Subsystem for Linux (WSL).
.DESCRIPTION
    This script enables the necessary Windows features for WSL,
    installs the latest WSL kernel update, sets WSL2 as the default.
#>

# Enable required system features
Write-Host "Enabling system features to run WSL..." -ForegroundColor Yellow
choco install -y Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"


# Download and install the latest WSL kernel update.
Write-Host "Installing latest WSL kernel update..." -ForegroundColor Yellow
$wslKernelUpdatePackage = Join-Path $env:TEMP "wsl_update_x64.msi"
Invoke-RestMethod -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile $wslKernelUpdatePackage
Start-Process msiexec.exe -Wait -ArgumentList "/I $wslKernelUpdatePackage /quiet"


# Set WSL1 as the default version
Write-Host "Setting WSL1 as the default version..." -ForegroundColor Yellow
wsl --set-default-version 1

Write-Host "WSL installation and configuration complete." -ForegroundColor Green