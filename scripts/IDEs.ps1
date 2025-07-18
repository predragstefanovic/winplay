<#
.SYNOPSIS
    Installs various Integrated Development Environments (IDEs) and tools.
.DESCRIPTION
    This script installs Visual Studio Code, and the JetBrains Toolbox.
    It also includes commented-out commands for installing Visual Studio 2022 Enterprise and OzCode.
#>

# Install Visual Studio Code using Chocolatey, as it's typically more up-to-date than the winget version.
choco install -y vscode

# Install the JetBrains Toolbox, which is used to manually install other JetBrains IDEs and tools (like Rider and .NET Tools).
winget install -e -h --id JetBrains.Toolbox