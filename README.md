# ubuntu-debullshit!
  
#### An automated script to set-up Ubuntu as it should be. Tested on Ubuntu 22.04, 23.04 and 24.04

#### Who is this for?

This script is for people who want a clean Gnome experience on Ubuntu. But still want the ease of use that Ubuntu provides with its distribution.

Screenshot of the menu

<img src="https://raw.githubusercontent.com/tuxslack/ubuntu-debullshit/main/usr/share/doc/ubuntu-debullshit/menu2.png" width="500" />
  
#### Features:

* Removes snaps completely
* Installs a vanilla gnome session
* Sets up flathub and gnome-software with the flatpak plugin
* Installs gnome-tweaks
* Installs [Extension Manager](https://github.com/mjakeman/extension-manager)
* Disables the Ubuntu theming
* Enables the libadwaita theme in gtk3 apps using [adw-gtk3](https://github.com/lassekongo83/adw-gtk3)
* Installs the adwaita icon theme and morewaita for extended icon support
* Enables gnome integration with QT apps
* Installs Firefox from the Mozilla Repository
* Disables the data reporting component
* Disables the annoying crash popup
* Removes terminal ads

TL;DR, you will end up with a clean GNOME desktop with flatpaks, similar to a fresh Fedora install.

#### Preview

<img src="https://raw.githubusercontent.com/tuxslack/ubuntu-debullshit/00be09325de90e3dfcb3447b108bc44d32c95c6c/usr/share/doc/ubuntu-debullshit/screenshot.png" width="500" />

#### Installation

Use this script at your own risk.

I recommend a minimal install of the latest version of Ubuntu.

You can download the script from the repo or use this command, there are dependencies required (yad, dialog, gnome-icon-theme, gettext, notify-send, msgfmt, sed).

`$ git clone https://github.com/tuxslack/ubuntu-debullshit.git`

`$ cd ubuntu-debullshit`

`$ sudo ./install.sh instalar`



After the install, reboot and enjoy a clean experience :)


#### Uninstallation

`$ sudo ./install.sh desinstalar`


## Tested On
Here is a list of tested Distros and versions.

| Distro           | Tested |
| ---------------- | :----: | 
| **Ubuntu 24.04** | ✅     |
| **Ubuntu 23.10** | ⛔     |
| **Ubuntu 23.04** | ✅     |
| **Ubuntu 22.04** | ✅     |

