# WinPlay

Provides a single-click experience for booting up a developer environment in Windows 10/11.
> Note: the scripts are tailored to my needs. Use the scripts at your own discretion.

sources:
* https://github.com/microsoft/windows-dev-box-setup-scripts/
* https://github.com/TechWatching/dotfiles/tree/main
* https://github.com/Vets-Who-Code/windows-dev-guide

## How to run

Run the `dev_setup.ps1` script with Boxstarter. Ideally you can then leave the job unattended and come back when it's finished. It may automatically restart the system a few times and resume. At start it will prompt to elevate rights to Administrator and ask for user login password and cache it locally.

**Click <a href='http://boxstarter.org/package/url?https://raw.githubusercontent.com/predragstefanovic/winplay/main/dev_setup.ps1'> HERE </a> to start it up with `boxstarter`.** 

> Note: Please use Edge to run the ClickOnce installer. The Boxstarter ClickOnce installer does not work through Chrome. This issue is being tracked [here](https://github.com/chocolatey/boxstarter/issues/345).

> Note: The script is idempotent.

## Software Being Installed

This script will install and configure the following software on your machine:

**WSL - Ubuntu:**
*   **Microsoft-Windows-Subsystem-Linux:** Enables WSL.
*   **WSL Kernel:** The latest kernel for the Windows Subsystem for Linux.
*   **Ubuntu 24.04:** Installed as a WSL distribution.
*   **curl:** Command-line tool for transferring data with URLs.
*   **git:** Version control system (within WSL).
*   **gh:** GitHub CLI (within WSL).
*   **zsh:** An alternative shell to bash.
*   **nano:** A simple text editor.
*   **bat:** A `cat` clone with syntax highlighting.
*   **jq:** A command-line JSON processor.
*   **unzip:** A utility for decompressing `zip` archives.
*   **Oh My Zsh:** A framework for managing Zsh configuration.
*   **Oh My Posh:** A prompt theme engine compatible with Zsh
*   **fzf:** A command-line fuzzy finder.
*   **fd-find:** A fast and user-friendly alternative to `find`.

**Windows:**
*   **Google Chrome:** Web browser.
*   **7-Zip:** File archiver.
*   **Git:** Version control system.
*   **GitHub CLI:** Command-line tool for GitHub.
*   **Pandoc:** Universal document converter.
*   **Microsoft PowerToys:** A set of utilities for power users.
*   **RepoZ:** A Git repository hub.
*   **Python:** Programming language.
*   **Visual Studio Code:** Code editor.
*   **JetBrains Toolbox:** Manages JetBrains IDEs.
*   **PowerShell:** The latest version of PowerShell.
*   **Windows Terminal:** A modern terminal application.
*   **Oh My Posh:** A prompt theme engine for PowerShell.
*   **Microsoft Azure CLI:** Command-line tool for Azure.
*   **posh-git:** A PowerShell module that integrates Git and PowerShell.
*   **psfzf:** A PowerShell module that integrates fzf and PowerShell
*   **Meslo Nerd Font:** Installed via Oh My Posh for better terminal icons.
*   **nano:** A simple text editor.
*   **bat:** A `cat` clone with syntax highlighting.
*   **less:** A terminal pager for viewing file contents.
*   **eza:** A modern replacement for the `ls` command.
*   **jq:** A command-line JSON processor.
*   **fzf:** A command-line fuzzy finder.
*   **fd:** A fast and user-friendly alternative to `find`.

The script also attempts to uninstall some typically unused software.

## Known issues
- WSL1 is used, since WSL2 requires enabling Virtualization in BIOS. There is a single line change to use WSL2 as default in the wsl.ps1 script

## Common follow up steps

### Ubuntu: Change default password

Change the password for the default user. Open a WSL command line and type (default password is `admin`):

```sh
passwd
```

### Git Configuration

#### Name

To set up your Git config file, open a WSL command line and set your name with this command (replacing "Your Name" with your preferred username):

```sh
git config --global user.name "Your Name"
```

#### Email

Set your email with this command (replacing "youremail@domain.com" with the email you prefer):

```sh
git config --global user.email "youremail@domain.com"
```

#### Username

And finally, add your GitHub username to link it to git (case sensitive!):

```sh
git config --global user.username "GitHub username"
```

Make sure you are inputting `user.username` and not `user.name` otherwise, you will overwrite your name and you will not be correctly synced to your GitHub account.

You can double-check any of your settings by typing `git config --global user.name` and so on. To make any changes just type the necessary command again as in the examples above.

## Open Items

* WSL2 Docker Setup
* Code Refactor
    * Consistent documentation, logging and error handling
    * Semantically break up large scripts
    * Reduce repetition
    * Abstract away parameters, at least default username and password