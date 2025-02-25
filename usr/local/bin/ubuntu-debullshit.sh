#!/usr/bin/env bash
#
# Authors:
#
# polkaulfield   - https://github.com/polkaulfield
#
# Fernando Souza - https://www.youtube.com/@fernandosuporte/ | https://github.com/tuxslack/ubuntu-debullshit 
#
# Date:    19/04/2024 as 16:44
# Script:  ubuntu-debullshit.sh
# Version: 1.0.1

# Changelog: /usr/share/doc/ubuntu-debullshit/CHANGELOG.md



# License: GPL - https://www.gnu.org/


# Desbostificando o Ubuntu!
#
# https://www.youtube.com/watch?v=psOrRNt8jKw


# Logotipo

ICON="/usr/share/icons/ubuntu-debullshit.png"


# export DISPLAY=:0


export TEXTDOMAINDIR="/usr/share/locale"

export TEXTDOMAIN="ubuntu-debullshit"




clear


# ----------------------------------------------------------------------------------------

# Cores para formatação da saída dos comandos

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # sem cor

# ----------------------------------------------------------------------------------------

# Verifica se a distribuição Linux é o Ubuntu

check_distro(){

# Para verificar se a distribuição Linux é o Ubuntu, vamos consultar o conteúdo do arquivo 
# /etc/os-release ou podemos usar o comando lsb_release. Ambas as abordagens são confiáveis 
# para obter informações sobre a distribuição Linux.

if ! grep -i "ubuntu" /etc/os-release > /dev/null; then

  echo "$(gettext 'Your Linux distribution is NOT Ubuntu.')"

  yad --center --window-icon="$ICON" --image=dialog-error  --title="$(gettext 'ubuntu-debullshit!')" --text="$(gettext 'Your Linux distribution is NOT Ubuntu.')" --buttons-layout=center --button="$(gettext 'OK')":0 --width="650"

  exit

fi


}


check_distro

# ----------------------------------------------------------------------------------------

check_internet(){

echo "
$(gettext 'Testing if internet connection is active...')
"


# O site do Google, tem bem menos chance de estar fora do ar.


if ! ping -c 1 www.google.com.br -q &> /dev/null; then

              # Internet está PARADA !!!

              echo -e "${RED}$(gettext '[ERROR] - Your system does not have an internet connection. Check your cables and modem.') \n ${NC}"
              
              notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext '[ERROR] - Your system does not have an internet connection. Check your cables and modem.') \n"
              
              sleep 1

              exit 1
    
    else

             # Conexao ativa...
             
             echo -e "${GREEN}$(gettext '[VERIFIED] - Internet connection working normally.') ${NC}"

echo -e "\n------------------------------------------------------------------------"

              sleep 1

fi


}


check_internet

# ----------------------------------------------------------------------------------------

# Verifica a existência de cada comando listado e sai do script caso algum deles não seja 
# encontrado. O uso do loop elimina a necessidade de escrever o comando which repetidamente.


check_programs(){

# snap

for cmd in yad rm fc-list gettext gsettings notify-send gpg sed sudo curl dd tee wget reboot break flatpak dbus-launch apt systemctl ; do


    # O comando which pode falhar em alguns sistemas ou não estar presente por padrão.

    # which $cmd 1> /dev/null 2> /dev/null


    command -v $cmd 1> /dev/null 2> /dev/null


    if [ $? -ne 0 ]; then

        echo "$(gettext 'Error'): $(gettext 'Command '$cmd' not found.')"

        notify-send -i "/usr/share/icons/gnome/32x32/status/software-update-urgent.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'Command '$cmd' not found.')"

        sleep 1

        exit

    fi


done

}


# /usr/local/bin/ubuntu-debullshit.sh: line 108: gettext: command not found
# /usr/local/bin/ubuntu-debullshit.sh: line 108: gettext: command not found


# apt update

# apt install -y gettext

# apt install -y flatpak

# apt install -y snap


check_programs

# ----------------------------------------------------------------------------------------


disable_ubuntu_report() {

    rm -Rf ~/.cache/ubuntu-report/

    ubuntu-report send no

    apt remove -y ubuntu-report
}

# ----------------------------------------------------------------------------------------

remove_appcrash_popup() {

# Desativar a coleta de dados do apport

# O Apport é uma ferramenta usada para coletar relatórios de falhas e erros no Ubuntu. Você pode desativá-la, caso não queira que ela envie relatórios de falhas.

# Para desativar o Apport, execute o seguinte comando:

sudo systemctl stop apport

sudo systemctl disable apport

# Além disso, você pode editar o arquivo de configuração do Apport para desativá-lo permanentemente:

# sudo nano /etc/default/apport

# E altere a linha:

# enabled=1

# Para:

# enabled=0

# Depois, salve e feche o arquivo.


    apt remove -y apport apport-gtk
}

# ----------------------------------------------------------------------------------------

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

    rm -rf /snap /var/lib/snapd


    for userpath in /home/*; do

        rm -rf $userpath/snap

    done




    # Cria um arquivo de configuração que impede a instalação do snapd via APT 

    cat <<-EOF | tee /etc/apt/preferences.d/nosnap.pref
	Package: snapd
	Pin: release a=*
	Pin-Priority: -10
	EOF

    # Conteúdo do arquivo /etc/apt/preferences.d/nosnap.pref:

# Package: snapd: Indica que a configuração se aplica ao pacote snapd, que é o serviço 
# responsável por gerenciar os pacotes Snap.

# Pin: release a=*: Define que a prioridade de pinning se aplica a todas as versões do 
# pacote snapd, independentemente da origem ou versão.
# Pin-Priority: -10: Define a prioridade do pacote snapd como -10. No APT, quando um 
# pacote tem uma prioridade negativa, ele é efetivamente bloqueado, o que significa que 
# não será instalado ou atualizado.





}

# ----------------------------------------------------------------------------------------

disable_terminal_ads() {


# Verifica se o arquivo /etc/default/motd-news existe

if [ -e /etc/default/motd-news ]; then

    echo "$(gettext 'The file /etc/default/motd-news exists.')"

    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news

    pro config set apt_news=false

else

    echo "$(gettext 'The file /etc/default/motd-news does not exist.')"

fi


}

# ----------------------------------------------------------------------------------------

update_system() {

    apt update && apt upgrade -y
}

# ----------------------------------------------------------------------------------------

cleanup() {

    # Limpando pacotes desnecessários

    apt autoremove -y

}

# ----------------------------------------------------------------------------------------

setup_flathub() {


# Para verificar se um site está fora do ar

# URL do site que deseja verificar
URL="https://flathub.org"

# Verificar se o site está acessível
http_response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

# Se o código de resposta HTTP for diferente de 200, o site está fora do ar
if [ "$http_response" -ne 200 ]; then

  echo "$(gettext 'O site '$URL' está fora do ar. Código de resposta: '$http_response'')"

else

  echo "$(gettext 'O site '$URL' está online.')"

  apt install -y flatpak

  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

fi

    apt install --install-suggests -y gnome-software

}

# ----------------------------------------------------------------------------------------

gsettings_wrapper() {

    if ! command -v dbus-launch; then

        sudo apt install -y dbus-x11
    fi

    sudo -Hu $(logname) dbus-launch gsettings "$@"
}

# ----------------------------------------------------------------------------------------

set_fonts() {


# Para verificar se a fonte Monospace está instalada no sistema



# Nome da fonte a ser verificada
FONT_NAME="Monospace"

# Verificar se a fonte está instalada

if fc-list | grep -i "$FONT_NAME"; then

  echo "$(gettext 'A fonte '$FONT_NAME' está instalada.')"


# O comando configura a fonte padrão de texto monospace (fonte de largura fixa, como a usada em terminais e editores de texto) para Monospace com o tamanho 10.


    # No Ubuntu, o gsettings_wrapper não é um comando padrão.

	gsettings_wrapper set org.gnome.desktop.interface monospace-font-name "Monospace 10"


    # gsettings set org.gnome.desktop.interface monospace-font-name "Monospace 10"


else

  echo "$(gettext 'A fonte '$FONT_NAME' não está instalada.')"

fi




}

# ----------------------------------------------------------------------------------------

setup_vanilla_gnome() {

    apt install -y qgnomeplatform-qt5

    apt install -y gnome-session fonts-cantarell adwaita-icon-theme gnome-backgrounds gnome-tweaks vanilla-gnome-default-settings gnome-shell-extension-manager -y && apt remove ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound

    set_fonts

    restore_background

}

# ----------------------------------------------------------------------------------------

restore_background() {



# Caminho do arquivo

FILE="/usr/share/backgrounds/gnome/blobs-l.svg"


# Verificar se o arquivo existe

if [ -f "$FILE" ]; then

  echo "$(gettext 'O arquivo '$FILE' existe.')"




# Verificar se o usuário está utilizando o GNOME como ambiente de desktop


# Verificar o ambiente de desktop atual


# A variável de ambiente XDG_CURRENT_DESKTOP não funciona em gerenciadores de janelas

if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" || "$DESKTOP_SESSION" == "GNOME" ]]; then

  echo "$(gettext 'The user is using GNOME.')"


    # Este comando altera a imagem de fundo da área de trabalho no GNOME para a imagem localizada no caminho $FILE.


    gsettings_wrapper set org.gnome.desktop.background picture-uri      'file://'$FILE''

    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file://'$FILE''



    # gsettings set org.gnome.desktop.background picture-uri       'file://'$FILE''

    # gsettings set org.gnome.desktop.background picture-uri-dark  'file://'$FILE''


else

  echo "$(gettext 'The user is NOT using GNOME.')"

fi






else

  echo "$(gettext 'O arquivo '$FILE' não existe.')"

fi




}

# ----------------------------------------------------------------------------------------

setup_julianfairfax_repo() {

    command -v curl || apt install -y curl


    # Verificar se a pasta /etc/apt/sources.list.d/ existe

    if [ ! -d "/etc/apt/sources.list.d/" ]; then

        echo "$(gettext 'The folder /etc/apt/sources.list.d/ does not exist.')"

        # Se a pasta não existir, o comando mkdir -p cria a pasta. O -p garante que, se a pasta pai não existir, ela também será criada.

        mkdir -p /etc/apt/sources.list.d

    fi



# Para verificar se um site está fora do ar.

# URL do site que deseja verificar
URL="https://julianfairfax.gitlab.io"

# Verificar se o site está acessível
http_response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

# Se o código de resposta HTTP for diferente de 200, o site está fora do ar

if [ "$http_response" -ne 200 ]; then

  echo "$(gettext 'O site '$URL' está fora do ar. Código de resposta: '$http_response'')"

else

  echo "$(gettext 'O site '$URL' está online.')"


    curl -s https://julianfairfax.gitlab.io/package-repo/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/julians-package-repo.gpg

    echo 'deb [ signed-by=/usr/share/keyrings/julians-package-repo.gpg ] https://julianfairfax.gitlab.io/package-repo/debs packages main' | sudo tee /etc/apt/sources.list.d/julians-package-repo.list

    apt update

fi




}

# ----------------------------------------------------------------------------------------

install_adwgtk3() {  
  
    apt install -y adw-gtk3

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

# ----------------------------------------------------------------------------------------

install_icons() {


# Para verificar se um site está fora do ar

# URL do site que deseja verificar
URL="https://deb.debian.org"

# Verificar se o site está acessível
http_response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

# Se o código de resposta HTTP for diferente de 200, o site está fora do ar
if [ "$http_response" -ne 200 ]; then

  echo "$(gettext 'O site '$URL' está fora do ar. Código de resposta: '$http_response'')"

else

    echo "$(gettext 'O site '$URL' está online.')"

    wget -O /tmp/adwaita-icon-theme.deb -c https://deb.debian.org/debian/pool/main/a/adwaita-icon-theme/adwaita-icon-theme_46.0-1_all.deb

    apt install -y /tmp/adwaita-icon-theme.deb

fi


    apt install -y morewaita
 
}

# ----------------------------------------------------------------------------------------

restore_firefox() {


# Para verificar se um site está fora do ar.

# URL do site que deseja verificar
URL="https://packages.mozilla.org"

# Verificar se o site está acessível
http_response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

# Se o código de resposta HTTP for diferente de 200, o site está fora do ar

if [ "$http_response" -ne 200 ]; then

  echo "$(gettext 'O site '$URL' está fora do ar. Código de resposta: '$http_response'')"

else


    echo "$(gettext 'O site '$URL' está online.')"


    apt purge -y firefox 

    snap remove --purge firefox



# Verificar se a pasta /etc/apt/keyrings/ existe

if [ ! -d "/etc/apt/keyrings/" ]; then

  echo "$(gettext 'The /etc/apt/keyrings/ folder does not exist.')"

  mkdir -p /etc/apt/keyrings/


fi


# Verificar se a pasta /etc/apt/sources.list.d/ existe

if [ ! -d "/etc/apt/sources.list.d/" ]; then

  echo "$(gettext 'The folder /etc/apt/sources.list.d/ does not exist.')"

  mkdir -p /etc/apt/sources.list.d/


fi


# Verificar se a pasta /etc/apt/preferences.d/ existe

if [ ! -d "/etc/apt/preferences.d/" ]; then

  echo "$(gettext 'The /etc/apt/preferences.d/ folder does not exist.')"

  mkdir -p /etc/apt/preferences.d/


fi


    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- > /etc/apt/keyrings/packages.mozilla.org.asc

    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list

    echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' > /etc/apt/preferences.d/mozilla

    apt update

    apt install -y firefox


fi



}

# ----------------------------------------------------------------------------------------

ask_reboot() {


# Exibe a caixa de diálogo de confirmação usando yad e captura o código do botão pressionado

choice=$(yad --center --window-icon="$ICON" --title="$(gettext 'Reboot')" --question --text="$(gettext 'Reboot now?')" --button="$(gettext 'Yes')":0 --button="$(gettext 'No')":1)

# Verifica o código retornado pelo yad

if [[ "$choice" == "0" ]]; then

    reboot

    exit 1

elif [[ "$choice" == "1" ]]; then

    exit 2

fi




}

# ----------------------------------------------------------------------------------------

msg() {

    tput setaf 2
    echo "[*] $1"
    tput sgr0

}

# ----------------------------------------------------------------------------------------

error_msg() {

    tput setaf 1
    echo "[!] $1"
    tput sgr0

}

# ----------------------------------------------------------------------------------------

check_root_user() {

    if [ "$(id -u)" != 0 ]; then

        echo -e "$(gettext 'Please run the script as Root!\nWe need to do administrative tasks')"

        yad --center --window-icon="$ICON" --image=dialog-error  --title="$(gettext 'ubuntu-debullshit!')" --text="$(gettext 'Please run the script as Root!\nWe need to do administrative tasks')" --buttons-layout=center --button="$(gettext 'OK')":0 --width="650"

        exit 3

    fi

}

# ----------------------------------------------------------------------------------------

print_banner() {

    echo '                                                                                                                                   
    ▐            ▗            ▐     ▐       ▝▜  ▝▜      ▐    ▝   ▗   ▗  
▗ ▗ ▐▄▖ ▗ ▗ ▗▗▖ ▗▟▄ ▗ ▗      ▄▟  ▄▖ ▐▄▖ ▗ ▗  ▐   ▐   ▄▖ ▐▗▖ ▗▄  ▗▟▄  ▐  
▐ ▐ ▐▘▜ ▐ ▐ ▐▘▐  ▐  ▐ ▐     ▐▘▜ ▐▘▐ ▐▘▜ ▐ ▐  ▐   ▐  ▐ ▝ ▐▘▐  ▐   ▐   ▐  
▐ ▐ ▐ ▐ ▐ ▐ ▐ ▐  ▐  ▐ ▐  ▀▘ ▐ ▐ ▐▀▀ ▐ ▐ ▐ ▐  ▐   ▐   ▀▚ ▐ ▐  ▐   ▐   ▝  
▝▄▜ ▐▙▛ ▝▄▜ ▐ ▐  ▝▄ ▝▄▜     ▝▙█ ▝▙▞ ▐▙▛ ▝▄▜  ▝▄  ▝▄ ▝▄▞ ▐ ▐ ▗▟▄  ▝▄  ▐  
                                                                                                      

 '

}

# ----------------------------------------------------------------------------------------

show_menu() {

choice=$(yad --center --window-icon="$ICON" --title="$(gettext 'ubuntu-debullshit!')"  --list --radiolist \
--column=$(gettext 'Option')  --column=$(gettext ' ') --column="$(gettext 'Choose what to do:')" \
false  2 "$(gettext 'Disable Ubuntu report')" \
false  3 "$(gettext 'Remove app crash popup')" \
false  4 "$(gettext 'Remove snaps and snapd')" \
false  5 "$(gettext 'Disable terminal ads (LTS versions)')" \
false  6 "$(gettext 'Install flathub and gnome-software')" \
false  7 "$(gettext 'Install firefox from the Mozilla repo')" \
false  8 "$(gettext 'Install vanilla GNOME session')" \
false  9 "$(gettext 'Install adw-gtk3, morewaita and latest adwaita icons')" \
false 10 "$(gettext 'Apply everything (RECOMMENDED)')" \
false 11 "$(gettext 'Help')" \
false 12 "$(gettext 'Disable Telemetry')" \
true  50 "$(gettext 'Exit')" \
--buttons-layout=center  --button="$(gettext 'OK')":0 \
--width="700" --height="700")


# --button="$(gettext 'Cancel')":1

choice=$(echo "$choice" | cut -d'|' -f2)


}



# ----------------------------------------------------------------------------------------


main() {


    check_root_user


    while true; do

        print_banner

        show_menu

        echo "$choice"


# Verifica se o botão "Cancel" ou "Exit" foi pressionado e sai do script

if [[ "$choice" == "1" ]] || [[ "$choice" == "50" ]]; then

    clear

    exit 4

fi


        case $choice in

        2)
            disable_ubuntu_report

            msg "$(gettext 'Done!')"

            ;;
        3)
            remove_appcrash_popup

            msg "$(gettext 'Done!')"

            ;;
        4)
            remove_snaps

            msg "$(gettext 'Done!')"

            ask_reboot

            ;;
        5)
            disable_terminal_ads

            msg "$(gettext 'Done!')"

            ;;
        6)
            update_system

            setup_flathub

            msg "$(gettext 'Done!')"

            ask_reboot

            ;;
        7)
            restore_firefox

            msg "$(gettext 'Done!')"

            ;;
        8)
            update_system

            setup_vanilla_gnome

            msg "$(gettext 'Done!')"

            ask_reboot

            ;;

        9)
            update_system

            setup_julianfairfax_repo

            install_adwgtk3

            install_icons

            msg "$(gettext 'Done!')"

            ask_reboot

            ;;

        10)
            auto

            msg "$(gettext 'Done!')"

            ask_reboot

            ;;

        11) 
            # Ajuda

            yad --center --window-icon="$ICON" --text-info --title="ubuntu-debullshit - $(gettext 'Help')" --filename="/usr/share/doc/ubuntu-debullshit/README-$(echo $LANG | cut -d. -f1).md" --width="1200" --height="800" --buttons-layout=center  --button="$(gettext 'OK')":0

            ;;

        12)

# Desativar a Telemetria do Ubuntu

# O Ubuntu coleta informações de telemetria para ajudar a melhorar a distribuição e oferecer 
# uma melhor experiência para os usuários. A telemetria do Ubuntu pode incluir dados sobre 
# o hardware, software, e como você interage com o sistema. Se você deseja desativar ou 
# remover a coleta de dados de telemetria, há algumas configurações que você pode ajustar 
# para desativar esse processo.

# O Ubuntu tem um serviço chamado ubuntu-report que coleta informações sobre o sistema, 
# como a versão do Ubuntu, pacotes instalados e mais. Para desativar esse serviço, você 
# pode fazer isso através de uma configuração de terminal:

sudo sed -i 's/Enabled=1/Enabled=0/' /etc/default/ubuntu-report

# Isso desativa a coleta de telemetria do ubuntu-report.


# Desativar a Telemetria do pop-con (para distribuições derivadas, como Pop!_OS)

# Caso esteja usando uma distribuição baseada no Ubuntu, como o Pop!_OS, você pode querer 
# desativar o serviço pop-con que coleta dados de uso. No Ubuntu, isso não é aplicável 
# diretamente, mas se você estiver usando uma versão baseada no Ubuntu (como o Pop!_OS), 
# pode desativar a coleta com o comando:

# sudo systemctl stop pop-con
# sudo systemctl disable pop-con


# Desativar a coleta de dados de telemetria no Ubuntu Snap

# O Snap (o sistema de pacotes universal do Ubuntu) coleta dados sobre o uso de pacotes 
# instalados. Você pode desativar esse comportamento no Snap da seguinte maneira:

sudo snap set system telemetry=off

# Isso desativa a coleta de telemetria para pacotes Snap.


# Desativar a coleta de dados do whoopsie

# O Whoopsie é um serviço do Ubuntu que envia dados sobre falhas para a Canonical. Para desativá-lo, execute:

sudo systemctl stop whoopsie

sudo systemctl disable whoopsie


# Você também pode remover o pacote whoopsie se preferir:

sudo apt-get purge -y whoopsie


# Remover o canonical-livepatch (se ativado)

# O Canonical Livepatch é um serviço pago que aplica correções de segurança em tempo real 
# no Ubuntu. Ele coleta dados, embora de forma limitada. Para desativá-lo ou removê-lo:

# Para desativar:

sudo systemctl stop canonical-livepatch

sudo canonical-livepatch disable

# Para remover:

sudo apt-get purge -y canonical-livepatch


# Desativar a coleta de dados de pesquisa da Dash:


# Verificar as fontes de pesquisa online ativas:

# Use o seguinte comando para listar as fontes de pesquisa atualmente habilitadas no seu sistema:

gsettings get org.gnome.desktop.search-providers


# No passado, o Ubuntu enviava consultas de pesquisa para a Amazon, mas isso foi desativado 
# por padrão em versões mais recentes. Para garantir que a coleta de dados de pesquisa 
# esteja desativada, verifique se a opção "Incluir resultados online nas buscas" está 
# desmarcada em "Configurações" > "Privacidade" > "Pesquisa online".


# Para desativar a coleta de dados de pesquisa da Dash no Ubuntu, você pode impedir que o 
# sistema envie consultas de pesquisa para fontes online, como a Amazon. Isso pode ser 
# feito via configurações do sistema ou através de scripts.

# Para desativar a coleta de dados da Dash (Pesquisa Online):

# Desativa a pesquisa online na Dash do Ubuntu

# Este comando habilita a pesquisa para todas as fontes, mas as fontes online podem ser 
# desabilitadas em seguida.

gsettings set org.gnome.desktop.search-providers show-all true

 
# Desabilita todas as fontes de pesquisa online (incluindo Amazon, eBay, Wikipedia, etc.)

gsettings set org.gnome.desktop.search-providers disabled "['ebay.com', 'wikipedia.org', 'flickr.com']"


# Este comando desabilita especificamente a pesquisa online da Amazon na Dash, que é uma 
# das fontes de dados online mais comuns que o Ubuntu utiliza.

gsettings set org.gnome.desktop.search-providers disabled "['amazon.com']"


# Alternativa: Desabilitar a pesquisa online via configurações do sistema

# Se preferir, você também pode manualmente desmarcar a opção "Incluir resultados online nas buscas" nas configurações de privacidade do Ubuntu:

#    Vá em Configurações > Privacidade > Pesquisa Online.
#    Desmarque a opção "Incluir resultados online nas buscas".

# O método via script automatiza essa configuração, desativando a pesquisa online e evitando o envio de consultas para serviços como a Amazon.


echo "A coleta de dados de pesquisa da Dash foi desativada."


# https://www.gnu.org/philosophy/ubuntu-spyware.pt-br.html


            ;;

        q)
            exit 0

            ;;

        *)
            error_msg "$(gettext 'Wrong input!')"

            ;;

        esac

    done

}


# ----------------------------------------------------------------------------------------


auto() {

    msg "$(gettext 'Updating system')"

    update_system


    msg "$(gettext 'Disabling ubuntu report')"

    disable_ubuntu_report


    msg "$(gettext 'Removing annoying appcrash popup')"

    remove_appcrash_popup


    msg "$(gettext 'Removing terminal ads (if they are enabled)')"

    disable_terminal_ads


    msg "$(gettext 'Deleting everything snap related')"

    remove_snaps


    msg "$(gettext 'Setting up flathub')"

    setup_flathub


    msg "$(gettext 'Restoring Firefox from mozilla repository')"

    restore_firefox


    msg "$(gettext 'Installing vanilla Gnome session')"

    setup_vanilla_gnome


    msg "$(gettext 'Adding julianfairfax repo')"

    setup_julianfairfax_repo


    msg "$(gettext 'Install adw-gtk3 and set dark theme')"

    install_adwgtk3


    msg "$(gettext 'Installing GNOME 46 and morewaita icons')"

    install_icons


    msg "$(gettext 'Cleaning up')"

    cleanup
}

# ----------------------------------------------------------------------------------------


(return 2> /dev/null) || main



