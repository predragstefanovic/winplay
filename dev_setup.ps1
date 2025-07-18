<#
.SYNOPSIS
    A Boxstarter script to automate the setup of a Windows development environment.
.DESCRIPTION
    This script orchestrates the entire development environment setup. It disables UAC,
    installs essential tools like winget and Git, clones the winplay repository, and then
    executes a series of helper scripts to configure the system, install software, and
    set up the development environment.
#>

# Disable User Account Control (UAC) to allow the script to run without interruption.
# UAC will be re-enabled at the end of the script.
# WARNING: Disabling UAC can be a security risk. Review the installed software to ensure it is safe.
Disable-UAC
$Boxstarter.AutoLogin = $false

# Enable Developer Mode on the system.
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1


# Install winget if it's not already installed.
Write-Host "Installing winget..."
$wingetInstallScript = Join-Path $env:TEMP "winget-install.ps1"
Invoke-RestMethod -Uri "https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1" -OutFile $wingetInstallScript
& $wingetInstallScript

Write-Host "Installing Git..."
choco install -y git --params '''/GitOnlyOnPath /NoShellIntegration /WindowsTerminal'''

RefreshEnv

Write-Host "Cloning repository with scripts..."
if (Test-Path "$env:USERPROFILE\winplay") {
    Remove-Item -Recurse -Force "$env:USERPROFILE\winplay"
}

git clone https://github.com/predragstefanovic/winplay.git $env:USERPROFILE\winplay
Write-Host "Verifying clone... Listing contents of $env:USERPROFILE\winplay"
Get-ChildItem -Path "$env:USERPROFILE\winplay"

Write-Host "Configuring git and winget..."
# --- Configuration Scripts ---
. "$env:USERPROFILE\winplay\scripts\Git-Config.ps1"
. "$env:USERPROFILE\winplay\scripts\Winget-Config.ps1"

# --- Setup Scripts ---
. "$env:USERPROFILE\winplay\scripts\FileExplorerSettings.ps1"
. "$env:USERPROFILE\winplay\scripts\RemoveDefaultApps.ps1"
. "$env:USERPROFILE\winplay\scripts\Tools.ps1"
. "$env:USERPROFILE\winplay\scripts\IDEs.ps1"

# --- Finalization ---
# Re-enable User Account Control (UAC).
Enable-UAC