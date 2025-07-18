<#
.SYNOPSIS
    Uninstalls a list of pre-installed and suggested applications from Windows.
.DESCRIPTION
    This script removes a predefined list of Windows Store applications (Appx packages)
    for all users and prevents them from being re-installed on new user accounts. It also
    disables suggested apps in the Start Menu.
#>

Write-Host "Uninstalling default Windows applications..." -ForegroundColor Yellow

# Function to remove a specified Appx package for all users and its provisioned package.
function Remove-AppPackage {
    param (
        [string]$AppName
    )

    Write-Output "Attempting to remove $AppName..."
    Get-AppxPackage $AppName -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like $AppName } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# List of applications to be removed.
$applicationList = @(
    "Microsoft.BingFinance",
    "Microsoft.3DBuilder",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.BingWeather",
    "Microsoft.CommsPhone",
    "Microsoft.Getstarted",
    "Microsoft.WindowsMaps",
    "*MarchofEmpires*",
    "Microsoft.GetHelp",
    "Microsoft.Messaging",
    "*Minecraft*",
    "Microsoft.OneConnect",
    "Microsoft.WindowsPhone",
    "Microsoft.WindowsSoundRecorder",
    "*Solitaire*",
    "Microsoft.Office.Sway",
    "Microsoft.XboxApp",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.NetworkSpeedTest",
    "Microsoft.FreshPaint",
    "Microsoft.Print3D",
    "*Autodesk*",
    "*BubbleWitch*",
    "king.com*",
    "G5*",
    "*Facebook*",
    "*LinkedIn*",
    "*Keeper*",
    "*Netflix*",
    "*Twitter*",
    "*Plex*",
    "*.Duolingo-LearnLanguagesforFree",
    "*.EclipseManager",
    "ActiproSoftwareLLC.562882FEEB491", # Code Writer
    "*.AdobePhotoshopExpress"
)

# Iterate over the application list and remove each app.
foreach ($app in $applicationList) {
    Remove-AppPackage $app
}

# Disable suggested apps in the Start Menu.
Write-Output "Disabling suggested apps in the Start Menu..."
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Type DWord -Value 0

Write-Host "Default application removal complete." -ForegroundColor Green
