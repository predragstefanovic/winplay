source: https://github.com/microsoft/windows-dev-box-setup-scripts/

source: https://github.com/TechWatching/dotfiles/tree/main

source: https://github.com/Vets-Who-Code/windows-dev-guide

(manual forking)

## Project structure
The script code is organized in a hierarchy

**Recipes**
A recipe is the script you run. It calls multiple helper scripts. These currently live in the root of the project (e.g. dev_setup.ps1)

**Helper Scripts**: A helper script performs setup routines that may be useful by many recipes. Recipes call helper scripts (you don't run helper scripts directly).  The helper scripts live in the **scripts** folder

## How to run the scripts

<a href='http://boxstarter.org/package/url?https://raw.githubusercontent.com/predragstefanovic/winplay/main/dev_setup.ps1'>CLICK TO START SETUP</a>

Run a recipe script. You can then leave the job unattended and come back when it's finished.

## Known issues
- The Boxstarter ClickOnce installer does not work when using Chrome.  This issue is being tracked [here](https://github.com/chocolatey/boxstarter/issues/345). Please use Edge to run the ClickOnce installer.
- WSL1 is used, since WSL2 requires enabling Virtualization in BIOS. There is a single line change to use WSL2 as default in the wsl.ps1 script

## Post processing steps

### WSL - Ubuntu

Change the password for the default user. Open a WSL command line and type:

```sh
passwd
```

### Git

#### Name

To set up your Git config file, open a WSL command line and set your name with this command (replacing "Your Name" with your preferred username):

```sh
git config --global user.name "Your Name"
```

### Email

Set your email with this command (replacing "youremail@domain.com" with the email you prefer):

```sh
git config --global user.email "youremail@domain.com"
```

### Username

And finally, add your GitHub username to link it to git (case sensitive!):

```sh
git config --global user.username "GitHub username"
```

Make sure you are inputting `user.username` and not `user.name` otherwise, you will overwrite your name and you will not be correctly synced to your GitHub account.

You can double-check any of your settings by typing `git config --global user.name` and so on. To make any changes just type the necessary command again as in the examples above.

TODO

* OPEN docker installation for wsl1/2
* OPEN clean up