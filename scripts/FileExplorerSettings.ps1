<#
.SYNOPSIS
    Configures Windows File Explorer settings for a better user experience.
.DESCRIPTION
    This script modifies the Windows Registry to change several File Explorer setting.
    It makes hidden and system files visible, shows file extensions, and adjusts the
    navigation pane and taskbar behaviors.
#>

# Show hidden files, protected OS files, and file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

# Set File Explorer to expand to the current folder in the navigation pane
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1

# Show all folders in the navigation pane, including Recycle Bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1

# Set File Explorer to open to "This PC" instead of "Quick access"
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1

# Configure the taskbar to show windows on the monitor where they are open
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2