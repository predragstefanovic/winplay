<#
.SYNOPSIS
    Installs a collection of development tools, browsers, and system utilities.
.DESCRIPTION
    This script uses Chocolatey and winget to install a wide range of software,
    including browsers, development tools, command-line utilities, and Azure tools.
    It also configures PowerShell, Windows Terminal, and other settings.
#>

#region Browsers
Write-Host "Installing Browsers..." -ForegroundColor Yellow
choco install -y googlechrome
#endregion

#region Common Tools
Write-Host "Installing Common Tools..." -ForegroundColor Yellow
choco install -y 7zip
winget install -e -h --id JohnMacFarlane.Pandoc
winget install -e -h --id Microsoft.Whiteboard -s msstore
winget install -e -h --id Microsoft.PowerToys # Note: Settings for PowerToys should be synced separately.
#endregion

#region Development Tools
Write-Host "Installing Development Tools..." -ForegroundColor Yellow
winget install -e -h --id AndreasWascher.RepoZ
winget install -e -h --id GitHub.cli
choco install -y python
#endregion

# TODO: replace with windows terminal and ohmyzsh setup

# #region PowerShell Configuration
# Write-Host "Configuring PowerShell..." -ForegroundColor Yellow
# winget install -e -h --id Microsoft.PowerShell
# RefreshEnv
# # Create a symbolic link for the PowerShell profile.
# Remove-Item -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Force -ErrorAction SilentlyContinue
# New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$env:USERPROFILE\winplay\config\powerShell\Microsoft.PowerShell_profile.ps1"
# #endregion

# #region Prompt Customization
# Write-Host "Configuring Prompt..." -ForegroundColor Yellow
# winget install -e -h --id JanDeDobbeleer.OhMyPosh
# RefreshEnv
# pwsh -Command { Install-Module posh-git -Scope CurrentUser -Force }
# #endregion

# #region Nushell Configuration
# Write-Host "Configuring NuShell..." -ForegroundColor Yellow
# winget install -e -h --id Nushell.Nushell
# RefreshEnv
# # saves an initialization script to ~/.oh-my-posh.nu that will be used in Nushell config file
# oh-my-posh init nu --config "$env:USERPROFILE\winplay\config\prompt\.oh-my-posh.omp.json"
# Remove-Item -Path "$env:USERPROFILE\AppData\Roaming\nushell\config.nu" -Force
# New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\AppData\Roaming\nushell\config.nu" -Target "$env:USERPROFILE\winplay\config\nu\config.nu"
# #endregion

# #region Windows Terminal Configuration
# Write-Host "Configuring Windows Terminal..." -ForegroundColor Yellow
# # Install Windows Terminal (Stable and Preview) and Cascadia Code Nerd Font.
# winget install -e -h --id Microsoft.WindowsTerminal
# choco install -y cascadia-code-nerd-font

# # Configure Windows Terminal settings and icons.
# $terminalSettingsPath = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
# $terminalIconsPath = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\"
# Remove-Item -Path $terminalSettingsPath -Force -ErrorAction SilentlyContinue
# New-Item -ItemType SymbolicLink -Path $terminalSettingsPath -Target "$env:USERPROFILE\winplay\config\windowsTerminal\settings.json"
# Copy-Item -Path "$env:USERPROFILE\winplay\config\windowsTerminal\icons\*" -Destination $terminalIconsPath -Force
# #endregion

#region Azure Tools
Write-Host "Installing Azure Tools..." -ForegroundColor Yellow
winget install -e -h --id Microsoft.AzureCLI
# winget install -e -h --id Microsoft.AzureCosmosEmulator
# winget install -e -h --id Microsoft.AzureDataStudio
# winget install -e -h --id Microsoft.azure-iot-explorer
# winget install -e -h --id Microsoft.AzureStorageExplorer
# winget install -e -h --id Pulumi.Pulumi
# winget install -e -h --id Microsoft.AzureFunctionsCoreTools
#endregion

Write-Host "Tool installation and configuration complete." -ForegroundColor Green