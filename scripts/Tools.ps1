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

#region PowerShell, Terminal and Themes
Write-Host "Configuring PowerShell, Windows Terminal and Oh-My-Posh..." -ForegroundColor Yellow
winget install -e -h --id Microsoft.PowerShell --accept-source-agreements --accept-package-agreements
winget install -e -h --id Microsoft.WindowsTerminal --accept-source-agreements --accept-package-agreements
winget install -e -h --id JanDeDobbeleer.OhMyPosh --accept-source-agreements --accept-package-agreements

RefreshEnv
oh-my-posh font install meslo
#endregion

#region Common Tools
Write-Host "Installing Common Tools..." -ForegroundColor Yellow
choco install -y 7zip
choco install -y nano
choco install -y fd
choco install -y fzf
choco install -y jq
choco install -y less
choco install -y bat
winget install -e -h --id eza-community.eza --accept-source-agreements --accept-package-agreements
winget install -e -h --id JohnMacFarlane.Pandoc --accept-source-agreements --accept-package-agreements
winget install -e -h --id Microsoft.PowerToys --accept-source-agreements --accept-package-agreements # Note: Settings for PowerToys should be synced separately.

#endregion

#region PowerShell, Terminal and Themes profiles
# powershell modules
pwsh -Command { Install-Module posh-git -Scope CurrentUser -Force }
pwsh -Command { Install-Module PSFzf -Scope CurrentUser -Force }

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

#region Development Tools
Write-Host "Installing Development Tools..." -ForegroundColor Yellow
iex "& { $(irm https://aka.ms/install-artifacts-credprovider.ps1) }"
winget install -e -h --id AndreasWascher.RepoZ --accept-source-agreements --accept-package-agreements
winget install -e -h --id GitHub.cli --accept-source-agreements --accept-package-agreements
choco install -y python
choco install -y vscode
winget install -e -h --id JetBrains.Toolbox --accept-source-agreements --accept-package-agreements
#endregion

#region Azure Tools
Write-Host "Installing Azure Tools..." -ForegroundColor Yellow
winget install -e -h --id Microsoft.AzureCLI --accept-source-agreements --accept-package-agreements
winget install -e -h --id Microsoft.AzureCosmosEmulator --accept-source-agreements --accept-package-agreements
# winget install -e -h --id Microsoft.AzureDataStudio
# winget install -e -h --id Microsoft.azure-iot-explorer
# winget install -e -h --id Microsoft.AzureStorageExplorer
# winget install -e -h --id Pulumi.Pulumi
# winget install -e -h --id Microsoft.AzureFunctionsCoreTools
#endregion

Write-Host "Tool installation and configuration complete." -ForegroundColor Green
