<#
.SYNOPSIS
    Configures Git by linking the .gitconfig file.
.DESCRIPTION
    This script removes the existing .gitconfig file and creates a symbolic link to the
    one in this repository. This allows for version-controlled Git settings.
#>

Write-Host "Configuring Git..." -ForegroundColor Yellow

$gitConfigSource = "$env:USERPROFILE\winplay\config\git\.gitconfig"
$gitConfigTarget = "$env:USERPROFILE\.gitconfig"

if (Test-Path $gitConfigTarget) {
    Remove-Item -Path $gitConfigTarget -Force
}

New-Item -ItemType SymbolicLink -Path $gitConfigTarget -Target $gitConfigSource

Write-Host "Git configuration complete." -ForegroundColor Green
