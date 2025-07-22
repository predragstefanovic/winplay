<#
.SYNOPSIS
    Installs and configures Windows Subsystem for Linux (WSL).
.DESCRIPTION
    This script enables the necessary Windows features for WSL,
    installs the latest WSL kernel update, sets WSL2 as the default.
#>

function Get-WindowsFeatureState {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$FeatureName
    )

    try {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $FeatureName -ErrorAction Stop
        return $feature.State -eq 'Enabled'
    } catch {
        Write-Warning "Feature not found: $FeatureName"
        return $False
    }
}

# Enable required system features
Write-Host "Enabling system features to run WSL..." -ForegroundColor Yellow
$wslEnabledBefore = Get-WindowsFeatureState "Microsoft-Windows-Subsystem-Linux"

choco install -y Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"
RefreshEnv

$wslEnabledAfter = Get-WindowsFeatureState "Microsoft-Windows-Subsystem-Linux"

if ($wslEnabledBefore -ne $wslEnabledAfter) {
    Write-Host "After enabling WSL, restart is necessary ..." -ForegroundColor Yellow
    Invoke-Reboot
}

# Download and install the latest WSL kernel update.
Write-Host "Installing latest WSL kernel update..." -ForegroundColor Yellow
$wslKernelUpdatePackage = Join-Path $env:TEMP "wsl_update_x64.msi"
Invoke-RestMethod -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -OutFile $wslKernelUpdatePackage
Start-Process msiexec.exe -Wait -ArgumentList "/I $wslKernelUpdatePackage /quiet"

RefreshEnv

# Set WSL1 as the default version
Write-Host "Setting WSL1 as the default version..." -ForegroundColor Yellow
wsl --set-default-version 1

Write-Host "WSL installation and configuration complete." -ForegroundColor Green