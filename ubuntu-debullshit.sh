#!/usr/bin/env bash

disable_ubuntu_report() {
    sudo ubuntu-report send no
    sudo apt remove ubuntu-report -y
}

remove_appcrash_popup() {
    sudo apt remove apport apport-gtk -y
}

remove_snaps() {
    while [ "$(snap list | wc -l)" -gt 0 ]; do
        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do
            sudo snap remove --purge "$snap"
        done
    done

    sudo systemctl stop snapd
    sudo systemctl disable snapd
    sudo systemctl mask snapd
    sudo apt purge snapd -y
    sudo rm -rf ~/snap/ /snap /var/lib/snapd
    cat <<-EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
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
    sudo apt install gnome-session fonts-cantarell adwaita-icon-theme-full gnome-backgrounds gnome-tweaks -y
    sudo update-alternatives --set gdm-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
    sudo apt remove ubuntu-session -y
}

install_adwgtk3() {
    wget https://github.com/lassekongo83/adw-gtk3/releases/download/v4.6/adw-gtk3v4-6.tar.xz -O /tmp/adw-gtk3.tar.xz
    sudo tar -xvf /tmp/adw-gtk3.tar.xz -C /usr/share/themes
    flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3-dark/x86_64/3.22
    flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3/x86_64/3.22
    gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
}

install_icons() {
    wget https://deb.debian.org/debian/pool/main/a/adwaita-icon-theme/adwaita-icon-theme_43-1_all.deb -O /tmp/adwaita-icon-theme.deb
    sudo apt install /tmp/adwaita-icon-theme.deb -y
}

restore_firefox() {
    flatpak install -y app/org.mozilla.firefox/x86_64/stable
}

ask_reboot() {
    echo 'Reboot now? (y/n)'
    while true; do
        read choice
        if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
            sudo reboot
            exit 0
        fi
        if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
            break
        fi
    done
}

msg() {
    tput setaf 2
    echo "[*] $1"
    tput sgr0
}

check_normal_user() {
    if [ "$(id -u)" -eq 0 ]; then
        echo 'Please run the script as your normal user!'
        echo 'It will prompt you for password when necessary'
        exit
    fi
    sudo -k
    sudo true
}

print_banner() {
    echo '                           _                               
 | | |_      ._ _|_       | \  _  |_      | |  _ |_  o _|_ 
 |_| |_) |_| | | |_ |_|   |_/ (/_ |_) |_| | | _> | | |  |_ 
 

 By @polkaulfield
 '
}

show_menu() {
    echo 'Choose what to do: '
    echo '1 - Apply everything (RECOMMENDED)'
    echo '2 - Disable Ubuntu report'
    echo '3 - Remove app crash popup'
    echo '4 - Remove snaps and snapd'
    echo '5 - Install flathub and gnome-software'
    echo '6 - Install firefox flatpak'
    echo '7 - Install vanilla GNOME session'
    echo '8 - Install adw-gtk3 and latest adwaita icons'
    echo 'q - Exit'
}

main() {
    check_normal_user
    while true; do
        print_banner
        show_menu
        read -p 'Enter your choice: ' choice
        case $choice in
        1)
            auto
            msg 'Done!'
            ask_reboot
            ;;
        2)
            disable_ubuntu_report
            msg 'Done!'
            ;;
        3)
            remove_appcrash_popup
            msg 'Done!'
            ;;
        4)
            remove_snaps
            msg 'Done!'
            ask_reboot
            ;;
        5)
            update_system
            setup_flathub
            msg 'Done!'
            ask_reboot
            ;;
        6)
            restore_firefox
            msg 'Done!'
            ;;
        7)
            update_system
            setup_vanilla_gnome
            msg 'Done!'
            ask_reboot
            ;;

        8)
            update_system
            install_adwgtk3
            install_icons
            msg 'Done!'
            ask_reboot
            ;;

        \
            q)
            exit 0
            ;;

        *)
            echo 'Wrong input'
            ;;
        esac
    done

}

auto() {
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
    msg 'Restoring Firefox as a flatpak'
    restore_firefox
    msg 'Installing vanilla Gnome session'
    setup_vanilla_gnome
    msg 'Install adw-gtk3 and set dark theme'
    install_adwgtk3
    msg 'Installing GNOME 43 icons'
    install_icons
    msg 'Cleaning up'
    cleanup
}

main
