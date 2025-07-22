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
winget install -e -h --id JohnMacFarlane.Pandoc --accept-source-agreements --accept-package-agreements
winget install -e -h --id Microsoft.PowerToys --accept-source-agreements --accept-package-agreements # Note: Settings for PowerToys should be synced separately.
#endregion

#region Development Tools
Write-Host "Installing Development Tools..." -ForegroundColor Yellow
winget install -e -h --id AndreasWascher.RepoZ --accept-source-agreements --accept-package-agreements
winget install -e -h --id GitHub.cli --accept-source-agreements --accept-package-agreements
choco install -y python
choco install -y vscode
winget install -e -h --id JetBrains.Toolbox
#endregion

#region Windows Terminal Configuration
Write-Host "Configuring PowerShell, Windows Terminal and Oh-My-Posh..." -ForegroundColor Yellow
# Install Windows Terminal (Stable and Preview) and Cascadia Code Nerd Font.
winget install -e -h --id Microsoft.PowerShell
winget install -e -h --id Microsoft.WindowsTerminal
winget install -e -h --id JanDeDobbeleer.OhMyPosh

RefreshEnv

pwsh -Command { Install-Module posh-git -Scope CurrentUser -Force }
oh-my-posh font install meslo

# Configure PowerShell
Remove-Item -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\\PowerShell\Microsoft.PowerShell_profile.ps1" -Target "$env:USERPROFILE\winplay\config\powerShell\Microsoft.PowerShell_profile.ps1"

# Configure Windows Terminal settings and icons.
$terminalSettingsPath = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$terminalIconsPath = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState\"
Remove-Item -Path $terminalSettingsPath -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $terminalSettingsPath -Target "$env:USERPROFILE\winplay\config\windowsTerminal\settings.json"
Copy-Item -Path "$env:USERPROFILE\winplay\config\windowsTerminal\icons\*" -Destination $terminalIconsPath -Force
#endregion

#region Azure Tools
Write-Host "Installing Azure Tools..." -ForegroundColor Yellow
winget install -e -h --id Microsoft.AzureCLI --accept-source-agreements --accept-package-agreements
# winget install -e -h --id Microsoft.AzureCosmosEmulator
# winget install -e -h --id Microsoft.AzureDataStudio
# winget install -e -h --id Microsoft.azure-iot-explorer
# winget install -e -h --id Microsoft.AzureStorageExplorer
# winget install -e -h --id Pulumi.Pulumi
# winget install -e -h --id Microsoft.AzureFunctionsCoreTools
#endregion

Write-Host "Tool installation and configuration complete." -ForegroundColor Green