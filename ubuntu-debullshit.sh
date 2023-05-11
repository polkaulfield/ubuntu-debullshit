#!/bin/bash

disable_ubuntu_report() {
sudo ubuntu-report send no
sudo apt remove ubuntu-report -y
}


remove_appcrash_popup() {
sudo apt remove apport apport-gtk -y
}

remove_snaps() {
sudo snap remove --purge firefox
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge gnome-42-2204
sudo snap remove --purge snapd-desktop-integration
sudo snap remove --purge snap-store
sudo snap remove --purge core22
sudo snap remove --purge bare
sudo snap remove --purge snapd
sudo apt remove --autoremove snapd
sudo systemctl stop snapd
sudo systemctl disable snapd
sudo systemctl mask snapd
sudo apt purge snapd -y
sudo apt-mark hold snapd
rm -rf ~/snap/
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
sudo cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
}


update_system() {
sudo apt update && sudo apt upgrade -y
}

cleanup() {
sudo apt autoremove -y
}

setup_flathub() {
sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo apt install --install-suggests gnome-software -y
}

setup_vanilla_gnome() {
sudo apt install gnome-session -y
sudo apt install fonts-cantarell adwaita-icon-theme-full gnome-backgrounds -y
sudo apt install gnome-tweaks -y
sudo update-alternatives --config gdm-theme.gresource
}

install_adwgtk3() {
    wget https://github.com/lassekongo83/adw-gtk3/releases/download/v4.6/adw-gtk3v4-6.tar.xz -O /tmp/adw-gtk3.tar.xz
    mkdir -p ~/.local/share/themes 
    tar -xvf /tmp/adw-gtk3.tar.xz -C ~/.local/share/themes
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
}

msg() {
    echo '[*] '$1
}

print_banner() {
    echo '                           _                               
 | | |_      ._ _|_       | \  _  |_      | |  _ |_  o _|_ 
 |_| |_) |_| | | |_ |_|   |_/ (/_ |_) |_| | | _> | | |  |_ 
 '
}

main() {
print_banner
msg 'Updating system'
update_system
msg 'Disabling ubuntu report'
disable_ubuntu_report
msg 'Removing annoying appcrash popup'
remove_appcrash_popup
msg 'Deleting everything snap related'
remove_snaps
msg 'Setting up flathub'
setup_flathub
msg 'Installing vanilla Gnome session'
setup_vanilla_gnome
msg 'Install adw-gtk3 and set dark theme'
install_adwgtk3
msg 'Cleaning up'
cleanup
msg Reboot now to finish installation
}

main
