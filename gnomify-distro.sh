#!/usr/bin/env bash

remove_ubuntu_default_apps() {
    ubuntu-report send no
    apt remove ubuntu-report apport apport-gtk gnome-clocks gnome-calculator gnome-characters gnome-font-viewer gnome-keyring gnome-keyring-pkcs11 gnome-logs gnome-text-editor gnome-power-manager eog baobab evince -y
}

remove_snaps() {
    while [ "$(snap list | wc -l)" -gt 0 ]; do
        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do
            snap remove --purge "$snap"
        done
    done

    systemctl stop snapd
    systemctl disable snapd
    systemctl mask snapd
    apt purge snapd -y
    rm -rf /snap /var/snap /var/lib/snapd
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
    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
    pro config set apt_news=false
}

update_system() {
    apt update & apt upgrade --auto-remove -y
}

cleanup() {
    apt autoremove -y
}

setup_flathub() {
    apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    apt install --no-install-recommends gnome-software gnome-software-plugin-flatpak -y
}

setup_vanilla_gnome() {
    apt install qgnomeplatform-qt5 -y
    # Ubuntu 24.04 - vanilla-gnome-desktop will give "pipewire-alsa : Conflicts: pulseaudio" 
    apt install gnome-session fonts-cantarell papirus-icon-theme gnome-backgrounds gnome-shell-extension-manager gnome-tweaks vanilla-gnome-default-settings -y && apt remove ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound -y
    
	gsettings_wrapper set org.gnome.desktop.interface monospace-font-name "Monospace 10"
    gsettings_wrapper set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
}

setup_gnome_apps() {
    # Please create a PR with missing gnome apps
    flatpak install flathub org.gnome.TextEditor -y
    flatpak install flathub org.gnome.clocks -y
    flatpak install flathub org.gnome.Logs -y
    flatpak install flathub org.gnome.Calculator -y
    flatpak install flathub org.gnome.Calendar -y
    flatpak install flathub org.gnome.Contacts -y
    flatpak install flathub org.gnome.Epiphany -y
    flatpak install flathub org.gnome.Loupe -y
    flatpak install flathub org.gnome.Music -y
    flatpak install flathub org.gnome.Papers -y
    flatpak install flathub org.gnome.Photos -y
    flatpak install flathub org.gnome.Showtime -y
    flatpak install flathub org.gnome.Snapshot -y
    flatpak install flathub org.gnome.Weather -y
    flatpak install flathub org.gnome.Maps -y
    flatpak install flathub org.gnome.seahorse.Application -y
    flatpak install flathub org.gnome.baobab -y
    flatpak install flathub org.gnome.SimpleScan -y
    flatpak install flathub org.gnome.Contacts -y
}

setup_julianfairfax_repo() {
    command -v curl || apt install curl -y
    curl -s https://julianfairfax.gitlab.io/package-repo/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/julians-package-repo.gpg
    echo 'deb [ signed-by=/usr/share/keyrings/julians-package-repo.gpg ] https://julianfairfax.gitlab.io/package-repo/debs packages main' | sudo tee /etc/apt/sources.list.d/julians-package-repo.list
    apt update
}

install_adwgtk3() {    
    apt install adw-gtk3 -y
    if command -v flatpak; then
        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3-dark
        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3
    fi
    if [ "$(gsettings_wrapper get org.gnome.desktop.interface color-scheme | tail -n 1)" == ''\''prefer-dark'\''' ]; then
        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
        gsettings_wrapper set org.gnome.desktop.interface color-scheme prefer-dark
	    gsettings_wrapper set org.gnome.desktop.interface icon-theme Papirus
    else
        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3
	    gsettings_wrapper set org.gnome.desktop.interface icon-theme Papirus
    fi
}

install_icons() {
    apt install adwaita-icon-theme -y 
    # Source: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
    add-apt-repository -y ppa:papirus/papirus
    apt-get update
    apt-get install papirus-icon-theme -y  # Papirus, Papirus-Dark, and Papirus-Light
}

restore_firefox() {
    apt purge firefox -y
    snap remove --purge firefox
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

gsettings_wrapper() {
    if ! command -v dbus-launch; then
        sudo apt install dbus-x11 -y
    fi
    sudo -Hu $(logname) dbus-launch gsettings "$@"
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

print_banner() {
    echo '
  ██████  ███    ██  ██████  ███    ███ ██ ███████ ██    ██     ██████  ██ ███████ ████████ ██████   ██████  
 ██       ████   ██ ██    ██ ████  ████ ██ ██       ██  ██      ██   ██ ██ ██         ██    ██   ██ ██    ██ 
 ██   ███ ██ ██  ██ ██    ██ ██ ████ ██ ██ █████     ████       ██   ██ ██ ███████    ██    ██████  ██    ██ 
 ██    ██ ██  ██ ██ ██    ██ ██  ██  ██ ██ ██         ██        ██   ██ ██      ██    ██    ██   ██ ██    ██ 
  ██████  ██   ████  ██████  ██      ██ ██ ██         ██        ██████  ██ ███████    ██    ██   ██  ██████  
                                                                                                            
 By: @SirBisgaard | Forked from: @polkaulfield               
    '                                                                                                       
}

show_menu() {
    echo ' Menu: '
    echo '   1 - Gnomify Distro'
    echo '   q - Exit' 
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
    msg 'Removing Ubuntu default apps'
    remove_ubuntu_default_apps
    msg 'Removing terminal ads (if they are enabled)'
    disable_terminal_ads
    msg 'Installing Firefox from mozilla repository'
    restore_firefox
    msg 'Installing vanilla icons and Papirus icons'
    install_icons
    msg 'Installing vanilla Gnome session'
    setup_vanilla_gnome
    msg 'Removing snap'
    remove_snaps
    msg 'Installing flatpak and flathub'
    setup_flathub
    msg 'Adding julianfairfax repo'
    setup_julianfairfax_repo
    msg 'Install adw-gtk3 and set dark theme'
    install_adwgtk3
    msg 'Installing Gnome apps from flathub'
    setup_gnome_apps
    msg 'Cleaning up'
    cleanup
}

(return 2> /dev/null) || main
