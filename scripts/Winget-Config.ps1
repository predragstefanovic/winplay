<#
.SYNOPSIS
    Configures winget by linking the settings.json file.
.DESCRIPTION
    This script removes the existing winget settings.json file and creates a symbolic
    link to the one in this repository. This allows for version-controlled winget settings.
#>

Write-Host "Configuring winget..." -ForegroundColor Yellow

$wingetPackages = "$env:USERPROFILE\winplay\config\winget\packages.json"
$wingetConfigSource = "$env:USERPROFILE\winplay\config\winget\settings.json"
$wingetConfigTarget = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"

if (Test-Path $wingetConfigTarget) {
    Remove-Item -Path $wingetConfigTarget -Force
}

New-Item -ItemType SymbolicLink -Path $wingetConfigTarget -Target $wingetConfigSource

winget import $wingetPackages

Write-Host "winget configuration complete." -ForegroundColor Green
