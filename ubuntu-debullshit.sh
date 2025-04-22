#!/usr/bin/env bash

disable_ubuntu_report() {
    ubuntu-report send no
    apt remove ubuntu-report -y
}

remove_appcrash_popup() {
    apt remove apport apport-gtk -y
}

remove_snaps() {
    while [ "$(snap list | wc -l)" -gt 0 ]; do
        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do
            snap remove --purge "$snap" 2> /dev/null
        done
    done

    systemctl stop snapd
    systemctl disable snapd
    systemctl mask snapd
    apt purge snapd -y
    rm -rf /snap /var/lib/snapd
    for userpath in /home/*; do
        rm -rf $userpath/snap
    done
    cat <<-EOF | tee /etc/apt/preferences.d/nosnap.pref
	Package: snapd
	Pin: release a=*
	Pin-Priority: -10
	EOF
}

disable_terminal_ads() {
    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news 2>/dev/null
    pro config set apt_news=false
}

update_system() {
    apt update && apt upgrade -y
}

cleanup() {
    apt autoremove -y
}

setup_flathub() {
    apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    apt install --install-suggests gnome-software -y
}

gsettings_wrapper() {
    if ! command -v dbus-launch; then
        sudo apt install dbus-x11 -y
    fi
    sudo -Hu $(logname) dbus-launch gsettings "$@"
}

set_fonts() {
	gsettings_wrapper set org.gnome.desktop.interface monospace-font-name "Monospace 10"
}

setup_vanilla_gnome() {
    apt install qgnomeplatform-qt5 -y
    apt install qgnomeplatform-qt6 -y
    apt install gnome-session fonts-cantarell adwaita-icon-theme gnome-backgrounds gnome-tweaks vanilla-gnome-default-settings gnome-shell-extension-manager -y && apt remove ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound -y
    set_fonts
    restore_background
}

restore_background() {
    gsettings_wrapper set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
}

install_adwgtk3() {    
    wget -O /tmp/adw-gtk3.tar.xz https://github.com/lassekongo83/adw-gtk3/releases/download/v5.10/adw-gtk3v5.10.tar.xz
    tar -xf /tmp/adw-gtk3.tar.xz -C /usr/share/themes/
    if command -v flatpak; then
        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3-dark
        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3
    fi
    if [ "$(gsettings_wrapper get org.gnome.desktop.interface color-scheme | tail -n 1)" == ''\''prefer-dark'\''' ]; then
        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
        gsettings_wrapper set org.gnome.desktop.interface color-scheme prefer-dark
    else
        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3
    fi
}

install_icons() {
    apt install adwaita-icon-theme -y
    apt install git -y
    git clone https://github.com/somepaulo/MoreWaita.git /tmp/MoreWaita
    /tmp/MoreWaita/install.sh
    apt install adwaita-icon-theme -y
    gsettings_wrapper set org.gnome.desktop.interface icon-theme MoreWaita
    gsettings_wrapper set org.gnome.desktop.interface accent-color blue
}

restore_firefox() {
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- > /etc/apt/keyrings/packages.mozilla.org.asc
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list 
    echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' > /etc/apt/preferences.d/mozilla
    apt update
    apt install firefox -y
}

ask_reboot() {
    echo 'Reboot now? (y/n)'
    while true; do
        read choice
        if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
            reboot
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

error_msg() {
    tput setaf 1
    echo "[!] $1"
    tput sgr0
}

check_root_user() {
    if [ "$(id -u)" != 0 ]; then
        echo 'Please run the script as root!'
        echo 'We need to do administrative tasks'
        exit
    fi
}

enable_appindicator() {
    gsettings_wrapper set org.gnome.shell enabled-extensions "['ubuntu-appindicators@ubuntu.com']"
}

print_banner() {
    echo '                                                                                                                                   
    ▐            ▗            ▐     ▐       ▝▜  ▝▜      ▐    ▝   ▗   ▗  
▗ ▗ ▐▄▖ ▗ ▗ ▗▗▖ ▗▟▄ ▗ ▗      ▄▟  ▄▖ ▐▄▖ ▗ ▗  ▐   ▐   ▄▖ ▐▗▖ ▗▄  ▗▟▄  ▐  
▐ ▐ ▐▘▜ ▐ ▐ ▐▘▐  ▐  ▐ ▐     ▐▘▜ ▐▘▐ ▐▘▜ ▐ ▐  ▐   ▐  ▐ ▝ ▐▘▐  ▐   ▐   ▐  
▐ ▐ ▐ ▐ ▐ ▐ ▐ ▐  ▐  ▐ ▐  ▀▘ ▐ ▐ ▐▀▀ ▐ ▐ ▐ ▐  ▐   ▐   ▀▚ ▐ ▐  ▐   ▐   ▝  
▝▄▜ ▐▙▛ ▝▄▜ ▐ ▐  ▝▄ ▝▄▜     ▝▙█ ▝▙▞ ▐▙▛ ▝▄▜  ▝▄  ▝▄ ▝▄▞ ▐ ▐ ▗▟▄  ▝▄  ▐  
                                                                                                      
 By @polkaulfield
 '
}

show_menu() {
    echo 'Choose what to do: '
    echo '1 - Apply everything (RECOMMENDED)'
    echo '2 - Disable Ubuntu report'
    echo '3 - Remove app crash popup'
    echo '4 - Remove snaps and snapd'
    echo '5 - Disable terminal ads (LTS versions)'
    echo '6 - Install flathub and gnome-software'
    echo '7 - Install firefox from the Mozilla repo'
    echo '8 - Install vanilla GNOME session'
    echo '9 - Install adw-gtk3 and morewaita'
    echo 'q - Exit'
    echo
}

main() {
    check_root_user
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
            disable_terminal_ads
            msg 'Done!'
            ;;
        6)
            update_system
            setup_flathub
            msg 'Done!'
            ask_reboot
            ;;
        7)
            restore_firefox
            msg 'Done!'
            ;;
        8)
            update_system
            setup_vanilla_gnome
	    enable_appindicator
            msg 'Done!'
            ask_reboot
            ;;

        9)
            update_system
            install_adwgtk3
            install_icons
            msg 'Done!'
            ask_reboot
            ;;

        q)
            exit 0
            ;;

        *)
            error_msg 'Wrong input!'
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
    msg 'Removing terminal ads (if they are enabled)'
    disable_terminal_ads
    msg 'Deleting everything snap related'
    remove_snaps
    msg 'Setting up flathub'
    setup_flathub
    msg 'Restoring Firefox from mozilla repository'
    restore_firefox
    msg 'Installing vanilla Gnome session'
    setup_vanilla_gnome
    enable_appindicator
    msg 'Install adw-gtk3'
    install_adwgtk3
    msg 'Installing MoreWaita icons'
    install_icons
    msg 'Cleaning up'
    cleanup
}

(return 2> /dev/null) || main
