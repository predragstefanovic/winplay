<#
.SYNOPSIS
    Installs Ubuntu distribution for WSL.

.DESCRIPTION
    This script installs latest Ubuntu LTS (tested for 24.04) for Windows Subsystem for Linux (WSL)
    by downloading the official Appx package and setting up a non-root user.

    Features:
    - Skips installation if the distro already exists
    - Installs the distro using root mode for non-interactive setup
    - Creates a regular user and sets default shell and permissions
    - Runs system update and cleanup
    - Sets the newly created user as the default WSL user
#>

# --- Configuration ---
$username = "predrag"
$password = "admin"
$distro = "ubuntu"
$distroDisplayName = "Ubuntu"
$installerUrl = "https://aka.ms/wslubuntu"

Write-Host "Installing and configuring '$distroDisplayName'..." -ForegroundColor Yellow

# --- Check if distro is already installed ---
wsl.exe --list --quiet
$existingDistrosUNI = & wsl.exe --list --quiet
$existingDistros = $existingDistrosUNI -replace "\x00",""
if ($existingDistros -match "^$distroDisplayName$") {
    Write-Host "Distro '$distroDisplayName' is already installed. Skipping installation." -ForegroundColor Yellow
} else {
    # --- Download and install the distro ---
    $ubuntuInstaller = Join-Path $env:TEMP "Ubuntu.appx"
    if (Test-Path $ubuntuInstaller) {
        Write-Host "Installer already exists at $ubuntuInstaller. Skipping download." -ForegroundColor Yellow
    } else {
        Write-Host "Downloading Ubuntu installer..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $installerUrl -OutFile $ubuntuInstaller -UseBasicParsing
    }

    # Install the distro in root mode (non-interactive setup)
    Write-Host "Adding installer package..." -ForegroundColor Yellow
    Add-AppxPackage -Path $ubuntuInstaller
    Write-Host "Installer package added..." -ForegroundColor Yellow

    # Make sure updated environment variables (e.g., new PATH) are available
    RefreshEnv

    # Install the distro in root mode (non-interactive setup)
    Write-Host "Installing Ubuntu distro..." -ForegroundColor Yellow
    & $distro install --root
    if ($LASTEXITCODE -ne 0) { throw "Could not install distro." }

    Write-Host "Distro '$distroDisplayName' install completed." -ForegroundColor Yellow
}



# --- Create a regular user (if it doesn't exist) ---
# Using --root means all WSL sessions run as root by default.
# We need to create a non-root user manually.
# Reference: https://github.com/microsoft/WSL/issues/3369
& $distro run id "$username"
if ($LASTEXITCODE -eq 0) {
    Write-Host "User '$username' already exists. Skipping user setup." -ForegroundColor Yellow
} else {
    Write-Host "Creating user '$username'..." -ForegroundColor Yellow
    & $distro run useradd -m "$username"
    if ($LASTEXITCODE -ne 0) { throw "User creation failed." }

    Write-Host "Setting password for '$username'..." -ForegroundColor Yellow
    & $distro run "chpasswd <<< ${username}:${password}"
    if ($LASTEXITCODE -ne 0) { throw "Password setting failed." }

    Write-Host "Setting default shell to bash..." -ForegroundColor Yellow
    & $distro run chsh -s /bin/bash "$username"
    if ($LASTEXITCODE -ne 0) { throw "Shell change failed." }

    Write-Host "Adding user to standard groups (sudo, etc.)..." -ForegroundColor Yellow
    & $distro run usermod -aG adm,cdrom,sudo,dip,plugdev "$username"
    if ($LASTEXITCODE -ne 0) { throw "Group assignment failed." }

    # Set the created user as default for future WSL sessions
    & $distro config --default-user "$username"
    if ($LASTEXITCODE -ne 0) { throw "Setting default user failed." }
}

# --- Perform system update and cleanup ---
# Setting DEBIAN_FRONTEND avoids interactive prompts during apt operations
$env:DEBIAN_FRONTEND = "noninteractive"
$env:WSLENV += ":DEBIAN_FRONTEND"

$defaultUser = & $distro run whoami
if ($defaultUser -match "root") {
    Write-Host "Switching to user '$username' to finish the ubuntu setup..." -ForegroundColor Yellow
    & $distro run "su ${username}"
    if ($LASTEXITCODE -ne 0) { throw "Unable to switch out from root user." }
}


Write-Host "Running '$distroDisplayName' update and cleanup..." -ForegroundColor Yellow
& $distro run "sudo -S <<< ${password} apt-get update"
if ($LASTEXITCODE -ne 0) { throw "apt-get update failed." }

& $distro run "sudo -S <<< ${password} apt-get full-upgrade -y"
if ($LASTEXITCODE -ne 0) {
    # after WSL1 install, upgrade fails and requires a manual fix: https://superuser.com/questions/1803992/getting-this-error-failed-to-take-etc-passwd-lock-invalid-argument
    Write-Host "Detected errors while upgrading, trying to self-heal..." -ForegroundColor Yellow
    & $distro run "sudo -S <<< ${password} mv /var/lib/dpkg/info /var/lib/dpkg/info_silent"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }

    & $distro run "sudo -S <<< ${password} mkdir /var/lib/dpkg/info"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }

    & $distro run "sudo -S <<< ${password} apt-get update"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }

    & $distro run "sudo -S <<< ${password} apt-get -f install"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }

    & $distro run "sudo -S <<< ${password} mv /var/lib/dpkg/info/* /var/lib/dpkg/info_silent"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }

    & $distro run "sudo -S <<< ${password} rm -rf /var/lib/dpkg/info"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }

    & $distro run "sudo -S <<< ${password} mv /var/lib/dpkg/info_silent /var/lib/dpkg/info"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }

    & $distro run "sudo -S <<< ${password} apt-get update"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }

    & $distro run "sudo -S <<< ${password} apt-get full-upgrade -y"
    if ($LASTEXITCODE -ne 0) { throw "apt-get upgrade-fix failed." }
    Write-Host "Self-healing success..." -ForegroundColor Yellow
}

& $distro run "sudo -S <<< ${password} apt-get autoremove -y"
if ($LASTEXITCODE -ne 0) { throw "autoremove failed." }

& $distro run "sudo -S <<< ${password} apt-get autoclean"
if ($LASTEXITCODE -ne 0) { throw "autoclean failed." }

Write-Host "Installing common Ubuntu tools curl, git, gh cli, zsh, oh-my-zsh, nano, bat, jq..." -ForegroundColor Yellow
# curl
& $distro run "sudo -S <<< ${password} apt install curl -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install gh cli." }

# unzip
& $distro run "sudo -S <<< ${password} apt-get install unzip -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install unzip." }

# git and gh cli
& $distro run "sudo -S <<< ${password} apt install git -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install git." }
& $distro run "sudo -S <<< ${password} apt install gh -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install gh cli." }

# zsh
& $distro run "sudo -S <<< ${password} apt install zsh -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install zsh." }

# fd
& $distro run "sudo -S <<< ${password} apt install fd-find -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install fd-find." }

# profile settings for zshrc and fzf
& $distro run "curl -fsSL https://raw.githubusercontent.com/predragstefanovic/winplay/refs/heads/main/config/zsh/.zshrc -o ~/.zshrc"
if ($LASTEXITCODE -ne 0) { throw "failed to install oh my zsh profile settings." }
& $distro run "curl -fsSL https://raw.githubusercontent.com/predragstefanovic/winplay/refs/heads/main/config/zsh/.fzf.zsh -o ~/.fzf.zsh"
if ($LASTEXITCODE -ne 0) { throw "failed to install oh my fzf settings." }

# oh-my-posh theme engine
& $distro run "curl -s https://ohmyposh.dev/install.sh | bash -s"
if ($LASTEXITCODE -ne 0) { throw "failed to install oh my posh theme engine." }

# fzf
$foundFzf = & $distro run "source ~/.zshrc &> /dev/null; type fzf"
if ($foundFzf -match "fzf not found") {
    # clean up and install oh my zsh
    & $distro run "rm -rf ~/.fzf"
    if ($LASTEXITCODE -ne 0) { throw "failed to clean up old fzf installation." }
    & $distro run "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf"
    if ($LASTEXITCODE -ne 0) { throw "failed to clone fzf." }
    & $distro run "~/.fzf/install --all"
    if ($LASTEXITCODE -ne 0) { throw "failed to install fzf." }
}

# oh-my-zsh
$foundOmz = & $distro run "source ~/.zshrc &> /dev/null; type omz"
if ($foundOmz -match "omz not found") {
    # install oh my zsh
    & $distro run "sh -c 'curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh'"
    if ($LASTEXITCODE -ne 0) { throw "failed to install oh my zsh." }

    # oh-my-zsh plugins
    & $distro run "git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    if ($LASTEXITCODE -ne 0) { throw "failed to install zsh-autosuggestions plugin." }
    & $distro run "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    if ($LASTEXITCODE -ne 0) { throw "failed to install zsh-syntax-highlighting plugin." }
}

# profile settings for zshrc and fzf
& $distro run "curl -fsSL https://raw.githubusercontent.com/predragstefanovic/winplay/refs/heads/main/config/zsh/.zshrc -o ~/.zshrc"
if ($LASTEXITCODE -ne 0) { throw "failed to install oh my zsh profile settings." }
& $distro run "curl -fsSL https://raw.githubusercontent.com/predragstefanovic/winplay/refs/heads/main/config/zsh/.fzf.zsh -o ~/.fzf.zsh"
if ($LASTEXITCODE -ne 0) { throw "failed to install oh my fzf settings." }

# activate zsh to be the default shell
& $distro run "sudo -S <<< ${password} chsh -s /usr/bin/zsh $username"
if ($LASTEXITCODE -ne 0) { throw "Shell change to zsh failed." }

# nano
& $distro run "sudo -S <<< ${password} apt install nano -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install nano." }

# bat
& $distro run "sudo -S <<< ${password} apt install bat -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install bat." }

# jq
& $distro run "sudo -S <<< ${password} apt-get install jq -y"
if ($LASTEXITCODE -ne 0) { throw "failed to install jq." }


# Terminate WSL instance instead of rebooting the whole machine
wsl --terminate $distroDisplayName
if ($LASTEXITCODE -ne 0) { throw "WSL termination failed." }

Write-Host "'$distroDisplayName' installation and configuration completed." -ForegroundColor Green
