<#
.SYNOPSIS
    Installs and configures Windows Subsystem for Linux (WSL).
.DESCRIPTION
    This script enables the necessary Windows features for WSL,
    installs the latest WSL kernel update, sets WSL2 as the default.
#>

# Enable the Windows Subsystem for Linux (WSL) and Virtual Machine Platform features.
Write-Host "Enabling System Features to run WSL..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Download and install the latest WSL kernel update.
Write-Host "Installing latest WSL kernel update..."
$wslKernelUpdatePackage = Join-Path $env:TEMP "wsl_update_x64.msi"
Invoke-RestMethod -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile $wslKernelUpdatePackage
Start-Process msiexec.exe -Wait -ArgumentList "/I $wslKernelUpdatePackage /quiet"
wsl --set-default-version 2