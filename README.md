# ubuntu-debullshit! (ubuntu-rolling-debloat, forked by Runa Inoue)
  
#### An automated script to set-up Ubuntu as it should be. Tested on Ubuntu LTS and Devel (rolling-build)

<img src="https://raw.githubusercontent.com/polkaulfield/ubuntu-debullshit/main/menu.png" width="500" />
  
#### Features:

* Removes snaps completely
* Installs a vanilla gnome session
* Sets up flathub and gnome-software with the flatpak plugin
* Installs gnome-tweaks
* Installs [Extension Manager](https://github.com/mjakeman/extension-manager)
* Disables the Ubuntu theming
* Enables the libadwaita theme in gtk3 apps using [adw-gtk3](https://github.com/lassekongo83/adw-gtk3)
* Enables gnome integration with QT apps
* Installs Firefox from the Mozilla PPA
* Installs the adwaita 43 icon theme
* Disables the data reporting component
* Disables the annoying crash popup
* Removes terminal ads

TL;DR, you will end up with a clean GNOME desktop with flatpaks, similar to a fresh Fedora install.

#### Preview

<img src="https://raw.githubusercontent.com/runa-chin/ubuntu-rolling-debloat/main/screenshot.png" width="500" />

#### Installation

You can download the script from the repo or use this oneliner command, there are no dependencies required.

`sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/runa-chin/ubuntu-rolling-debloat/main/ubuntu-debullshit.sh)"`

After the install, reboot and enjoy a clean experience :)
