source: https://github.com/microsoft/windows-dev-box-setup-scripts/blob/master/README.md

source: https://github.com/TechWatching/dotfiles/tree/main

(manual forking)

## Project structure
The script code is organized in a hierarchy

**Recipes**
A recipe is the script you run. It calls multiple helper scripts. These currently live in the root of the project (e.g. dev_setup.ps1)

**Helper Scripts**: A helper script performs setup routines that may be useful by many recipes. Recipes call helper scripts (you don't run helper scripts directly).  The helper scripts live in the **scripts** folder

## How to run the scripts

<a href='http://boxstarter.org/package/url?https://raw.githubusercontent.com/predragstefanovic/winplay/main/dev_setup.ps1'>CLICK TO START SETUP</a>

Run a recipe script. You can then leave the job unattended and come back when it's finished.

**Post processing steps:**  
1. For WSL there's a followup step after running the setup script.  When the script finishes you will only have a root user with a blank password. You should  manually create a non-root user via `$ sudo adduser [USERNAME] sudo` 
with a non-blank password. Use this user going forward. For more info on WSL please refer to the [documentation](https://docs.microsoft.com/en-us/windows/wsl/about).

## Known issues
- The Boxstarter ClickOnce installer does not work when using Chrome.  This issue is being tracked [here](https://github.com/chocolatey/boxstarter/issues/345). Please use Edge to run the ClickOnce installer.
- WSL1 is used, since WSL2 requires enabling Virtualization in BIOS. There is a single line change to use WSL2 as default in the wsl.ps1 script

TODO

* replace nushel with oh-my-zsh
* install wls1/2 and ubuntu, setup ubuntu, shell, git, docker, oh-my-zsh plugins
* clean up