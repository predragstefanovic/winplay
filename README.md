source: https://github.com/microsoft/windows-dev-box-setup-scripts/blob/master/README.md

source: https://github.com/TechWatching/dotfiles/tree/main

(manual forking)

## Project structure
The script code is organized in a hierarchy

**Recipes**
A recipe is the script you run.  It calls multiple helper scripts.  These currently live in the root of the project (e.g. dev_web.ps1)

**Helper Scripts**: A helper script performs setup routines that may be useful by many recipes. Recipes call helper scripts (you don't run helper scripts directly).  The helper scripts live in the **scripts** folder

## How to run the scripts
To run a recipe script, click a link in the table below from your target machine. This will download the Boxstarter one-click application, and prompt you for Boxstarter to run with Administrator privileges (which it needs to do its job). Clicking yes in this dialog will cause the recipe to begin. You can then leave the job unattended and come back when it's finished.

|Click link to run  |Description  |
|---------|---------|
|<a href='http://boxstarter.org/package/url?https://raw.githubusercontent.com/predragstefanovic/winplay/main/dev_env.ps1'>Setup Dev Environment</a> | VS Code, WSL, ... |

**Post processing steps:**  
1. For WSL there's a followup step after running the setup script.  When the script finishes you will only have a root user with a blank password. You should  manually create a non-root user via `$ sudo adduser [USERNAME] sudo` 
with a non-blank password. Use this user going forward. For more info on WSL please refer to the [documentation](https://docs.microsoft.com/en-us/windows/wsl/about).

## Known issues
- The Boxstarter ClickOnce installer does not work when using Chrome.  This issue is being tracked [here](https://github.com/chocolatey/boxstarter/issues/345). Please use Edge to run the ClickOnce installer.
- Reboot is not always logging you back in to resume the script.  This is being tracked [here](https://github.com/chocolatey/boxstarter/issues/318).  The workaround is to login manually and the script will continue running. 
