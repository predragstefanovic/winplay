<#
.SYNOPSIS
    Installs Ubuntu distribution for WSL.

.DESCRIPTION
    This script installs Ubuntu 24.04 for Windows Subsystem for Linux (WSL)
    by downloading the official Appx package and setting up a non-root user.

    Features:
    - Skips installation if the distro already exists
    - Installs the distro using root mode for non-interactive setup
    - Creates a regular user and sets default shell and permissions
    - Runs system update and cleanup
    - Sets the newly created user as the default WSL user
#>

# --- Configuration ---
$username = "ubuntu"
$password = "ubuntu"
$distro = "ubuntu2404"
$distroDisplayName = "Ubuntu-24.04"
$installerUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/Ubuntu2404-240425.AppxBundle"

# --- Check if distro is already installed ---
$existingDistros = & wsl.exe --list --quiet
if ($existingDistros -match "^$distroDisplayName$") {
    Write-Host "Distro '$distroDisplayName' is already installed. Skipping installation."
} else {
    # --- Download and install the distro ---
    Write-Host "Downloading Ubuntu distro..."
    $ubuntuInstaller = Join-Path $env:TEMP "Ubuntu.appx"
    Invoke-WebRequest -Uri $installerUrl -OutFile $ubuntuInstaller -UseBasicParsing
    Add-AppxPackage -Path $ubuntuInstaller

    # Make sure updated environment variables (e.g., new PATH) are available
    RefreshEnv

    # Install the distro in root mode (non-interactive setup)
    Write-Host "Installing Ubuntu distro..."
    & $distro install --root
    if ($LASTEXITCODE -ne 0) { throw "Could not install distro." }
}



# --- Create a regular user (if it doesn't exist) ---
# Using --root means all WSL sessions run as root by default.
# We need to create a non-root user manually.
# Reference: https://github.com/microsoft/WSL/issues/3369
Write-Host "Checking if user '$username' already exists..."
& $distro run id "$username"
if ($LASTEXITCODE -eq 0) {
    Write-Host "User '$username' already exists. Skipping user setup."
} else {
    Write-Host "Creating user '$username'..."
    & $distro run useradd -m "$username"
    if ($LASTEXITCODE -ne 0) { throw "User creation failed." }

    Write-Host "Setting password for '$username'..."
    & $distro run sh -c 'echo "${username}:${password}" | chpasswd'  # piping requires a shell
    if ($LASTEXITCODE -ne 0) { throw "Password setting failed." }

    Write-Host "Setting default shell to bash..."
    & $distro run chsh -s /bin/bash "$username"
    if ($LASTEXITCODE -ne 0) { throw "Shell change failed." }

    Write-Host "Adding user to standard groups (sudo, etc.)..."
    & $distro run usermod -aG adm,cdrom,sudo,dip,plugdev "$username"
    if ($LASTEXITCODE -ne 0) { throw "Group assignment failed." }
}

# --- Perform system update and cleanup ---
# Setting DEBIAN_FRONTEND avoids interactive prompts during apt operations
$env:DEBIAN_FRONTEND = "noninteractive"
$env:WSLENV += ":DEBIAN_FRONTEND"

Write-Host "Running system update and cleanup..."
& $distro run apt-get update
if ($LASTEXITCODE -ne 0) { throw "apt-get update failed." }

& $distro run apt-get full-upgrade -y
if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade failed." }

& $distro run apt-get autoremove -y
if ($LASTEXITCODE -ne 0) { throw "autoremove failed." }

& $distro run apt-get autoclean
if ($LASTEXITCODE -ne 0) { throw "autoclean failed." }

# Terminate WSL instance instead of rebooting the whole machine
wsl --terminate $distroDisplayName
if ($LASTEXITCODE -ne 0) { throw "WSL termination failed." }

# Set the created user as default for future WSL sessions
& $distro config --default-user "$username"
if ($LASTEXITCODE -ne 0) { throw "Setting default user failed." }
