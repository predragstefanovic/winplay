<#
.SYNOPSIS
    Installs and configures Windows Subsystem for Linux (WSL).
.DESCRIPTION
    This script enables the necessary Windows features for WSL,
    installs the latest WSL kernel update, sets WSL2 as the default.
#>

# Enable required system features
Write-Host "Enabling system features to run WSL..."
choco install -y Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"


# Download and install the latest WSL kernel update.
Write-Host "Installing latest WSL kernel update..."
$wslKernelUpdatePackage = Join-Path $env:TEMP "wsl_update_x64.msi"
Invoke-RestMethod -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile $wslKernelUpdatePackage
Start-Process msiexec.exe -Wait -ArgumentList "/I $wslKernelUpdatePackage /quiet"


# Set WSL2 as the default version
Write-Host "Setting WSL2 as the default version..."
wsl --set-default-version 2