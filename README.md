# Gnomify Distro!

## Overview

### A script to change Ubuntu into a clean Gnome experince.

Gnomify-Distro is a script fork of [ubuntu-debullshit!](https://github.com/polkaulfield/ubuntu-debullshit) and is intended to be used on a fresh install of Ubuntu with no additional software.
It will remove the Ubuntu desktop environment and install the near vanilla Gnome desktop environment with some additional tweaks.

The gnomify-distro script will also install many of the official Gnome applications.

### Who is this for?

This script is for people who want a clean Gnome experience on Ubuntu.
But still want the ease of use that Ubuntu provides with its distribution.

### Screenshot of the menu

<img src="https://raw.githubusercontent.com/SirBisgaard/Gnomify-Distro/main/menu.png" width="500" />

I made it a one option script to make it easier for people to use, but if you want to see what the script does, you can read the script and run the commands manually.

## Preview

Here is a screenshot of Ubuntu 24.4 desktop after running the script, with the default wallpaper and the Papirus icon theme.

<img src="https://raw.githubusercontent.com/SirBisgaard/Gnomify-Distro/main/screenshot.png" width="500" />

## Installation

I recommend a minimal install of the latest version of Ubuntu.
To use the script, open a terminal and run the following command:

**Use this script at your own risk.**

`sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/SirBisgaard/Gnomify-Distro/main/gnomify-distro.sh)"`

Check that the version number is equal to: **0.1.3**

After the the script has finished, you will need to reboot your computer.

## Features

The script does the following:

* Removes snaps completely
* Removes terminal ads
* Removes the data reporting component & the application crash popup
* Removes Ubuntu desktop environment
* Removes many preinstalled deb applications.
* Installs vanilla Gnome desktop environment
* Installs gnome-software-center, gnome-tweaks, gnome-backgrounds
* installs flatpak and gnome-software flatpak plugin
* Installs [Extension Manager](https://github.com/mjakeman/extension-manager)
* Installs [Firefox](https://www.mozilla.org/en-US/firefox/new/) from the Mozilla Repository
* Installs [Papirus icon theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) and enables it
* Installs most of the official Gnome applications (See script for details)
* Installs [Julian FairFax](https://gitlab.com/julianfairfax/package-repo) package repo.
* Enables Gnome integration with QT apps
* Enables dark mode as default
* Enables the libadwaita theme in gtk3 apps using [adw-gtk3](https://github.com/lassekongo83/adw-gtk3)
* Enables [flathub](https://flathub.org/) repository
* Disables Ubuntu Gnome extensions

## Tested On
Here is a list of tested Distros and versions.

| Distro           | Tested |
| ---------------- | :----: | 
| **Ubuntu 25.04** | ✅     |
| **Ubuntu 24.04** | ✅     |
| **Ubuntu 23.10** | ⛔     |
| **Ubuntu 23.04** | ⛔     |
