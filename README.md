# ubuntu-debullshit!
  
#### An automated script to set-up Ubuntu as it should be. Tested on Ubuntu 22.04 and 23.04

<img src="https://raw.githubusercontent.com/tuxslack/ubuntu-debullshit/main/usr/share/doc/ubuntu-debullshit/menu2.png" width="500" />
  
#### Features:

* Removes snaps completely
* Installs a vanilla gnome session
* Sets up flathub and gnome-software with the flatpak plugin
* Installs gnome-tweaks
* Installs [Extension Manager](https://github.com/mjakeman/extension-manager)
* Disables the Ubuntu theming
* Enables the libadwaita theme in gtk3 apps using [adw-gtk3](https://github.com/lassekongo83/adw-gtk3)
* Installs the adwaita 46 icon theme and morewaita for extended icon support
* Enables gnome integration with QT apps
* Installs Firefox from the Mozilla Repository
* Disables the data reporting component
* Disables the annoying crash popup
* Removes terminal ads

TL;DR, you will end up with a clean GNOME desktop with flatpaks, similar to a fresh Fedora install.

#### Preview

<img src="https://raw.githubusercontent.com/tuxslack/ubuntu-debullshit/00be09325de90e3dfcb3447b108bc44d32c95c6c/usr/share/doc/ubuntu-debullshit/screenshot.png" width="500" />

#### Installation

I recommend a minimal install of Ubuntu 23.04 to run this. 

You can download the script from the repo or use this oneliner command, there are no dependencies required.

`$ git clone https://github.com/tuxslack/ubuntu-debullshit.git`

`$ cd ubuntu-debullshit`

`$ sudo ./install.sh instalar`



After the install, reboot and enjoy a clean experience :)

<a href='https://ko-fi.com/polkaulfield' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />

#### Uninstallation

`$ sudo ./install.sh desinstalar`

