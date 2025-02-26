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


# Arquivo de log

log="/tmp/ubuntu-debullshit.log"



# Logotipo

ICON="/usr/share/icons/ubuntu-debullshit.png"


# export DISPLAY=:0



# Captura o nome do usuário comum

# Usando logname para obter o nome do usuário

# Se o script não está sendo executado com sudo, mas você ainda deseja capturar o nome do 
# usuário comum (o usuário que fez login na sessão), você pode usar o comando logname

SUDO_USER=$(logname)



# Nome da fonte a ser verificada Ex: Ubuntu Mono

FONT_NAME="Monospace"



export TEXTDOMAINDIR="/usr/share/locale"

export TEXTDOMAIN="ubuntu-debullshit"


# Remove o arquivo de log

rm "$log"



clear


# ----------------------------------------------------------------------------------------

# Cores para formatação da saída dos comandos

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # sem cor



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



# ----------------------------------------------------------------------------------------


for cmd in snap apt systemctl ; do


    command -v $cmd 1> /dev/null 2> /dev/null


    if [ $? -ne 0 ]; then


        echo -e "${RED}\n$(gettext 'Error'): $(gettext 'Command '$cmd' not found.') \n ${NC}"


sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/software-update-urgent.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "\n$(gettext 'Command '$cmd' not found.')\n"

        sleep 1

        continue

    fi


done


# ----------------------------------------------------------------------------------------


for cmd in yad rm fc-list gettext gsettings notify-send gpg sed sudo curl dd tee wget reboot break flatpak dbus-launch ; do


    # O comando which pode falhar em alguns sistemas ou não estar presente por padrão.

    # which $cmd 1> /dev/null 2> /dev/null


    command -v $cmd 1> /dev/null 2> /dev/null


    if [ $? -ne 0 ]; then


        echo -e "\n$(gettext 'Error'): $(gettext 'Command '$cmd' not found.') \n\n# apt install -y $cmd"


        notify-send -i "/usr/share/icons/gnome/32x32/status/software-update-urgent.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "\n$(gettext 'Command '$cmd' not found.') \n\n# apt install -y $cmd"


        sleep 1

        exit

    fi


done


# ----------------------------------------------------------------------------------------


}


# /usr/local/bin/ubuntu-debullshit.sh: line 108: gettext: command not found
# /usr/local/bin/ubuntu-debullshit.sh: line 108: gettext: command not found


# apt update

# apt install -y gettext

# apt install -y flatpak

# apt install -y snap


check_programs


# ----------------------------------------------------------------------------------------


# Verifica se a distribuição Linux é o Ubuntu

check_distro(){

# Para verificar se a distribuição Linux é o Ubuntu, vamos consultar o conteúdo do arquivo 
# /etc/os-release ou podemos usar o comando lsb_release. Ambas as abordagens são confiáveis 
# para obter informações sobre a distribuição Linux.


# Verifica se o arquivo /etc/os-release existe

if [ -e /etc/os-release ]; then


if ! grep -i "ubuntu" /etc/os-release > /dev/null 2> /dev/null ; then

  echo -e "${RED}\n$(gettext 'Your Linux distribution is NOT Ubuntu.') \n ${NC}"

  yad --center --window-icon="$ICON" --image=dialog-error  --title="$(gettext 'ubuntu-debullshit!')" --text="$(gettext 'Your Linux distribution is NOT Ubuntu.')" --buttons-layout=center --button="$(gettext 'OK')":0 --width="650"

  exit

fi


else


# distro=$(lsb_release -a | grep Distributor | cut -d: -f2 | sed 's/\t//g')

distro=$(lsb_release -a 2> /dev/null | grep Distributor | cut -d: -f2 | sed 's/\t//g' > /tmp/distro.txt)
# No LSB modules are available.


# cat /tmp/distro.txt 
# Ubuntu


# No Ubuntu 10.04 LTS (Lucid Lynx), o utilitário notify-send foi substituído pelo 
# notify-osd (Open Sound Design), que é a ferramenta responsável por exibir notificações 
# visuais no ambiente de desktop.
# 
# Embora o notify-osd esteja instalado, o notify-send faz parte do pacote libnotify-bin.
# 
# Instalar o pacote libnotify-bin, que contém o comando notify-send.


if [ "$distro" == "Ubuntu" ]; then

  echo -e "${RED}\n$(gettext 'Your Linux distribution is NOT Ubuntu.') \nA distribuição detectada é: $distro ${NC}"

  exit

else

  echo -e "${GREEN}$(gettext 'A distribuição é Ubuntu.') ${NC}"

fi




fi


}


check_distro


# ----------------------------------------------------------------------------------------


disable_ubuntu_report() {

    rm -Rf ~/.cache/ubuntu-report/ 2>> "$log"

    ubuntu-report send no          2>> "$log"

    apt remove -y ubuntu-report    2>> "$log"
}

# ----------------------------------------------------------------------------------------

remove_appcrash_popup() {

# Desativar a coleta de dados do apport

# O Apport é uma ferramenta usada para coletar relatórios de falhas e erros no Ubuntu. Você pode desativá-la, caso não queira que ela envie relatórios de falhas.

# Para desativar o Apport, execute o seguinte comando:

sudo systemctl stop apport     2>> "$log"

sudo systemctl disable apport  2>> "$log"

# Além disso, você pode editar o arquivo de configuração do Apport para desativá-lo permanentemente:

# sudo nano /etc/default/apport

# E altere a linha:

# enabled=1

# Para:

# enabled=0

# Depois, salve e feche o arquivo.


    apt remove -y apport apport-gtk  2>> "$log"
}

# ----------------------------------------------------------------------------------------

remove_snaps() {

    while [ "$(snap list | wc -l)" -gt 0 ]; do

        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do

            snap remove --purge "$snap" 2>> "$log"

        done

    done

    systemctl stop snapd         2>> "$log"

    systemctl disable snapd      2>> "$log"

    systemctl mask snapd         2>> "$log"

    apt purge -y snapd           2>> "$log"

    rm -rf /snap /var/lib/snapd  2>> "$log"


    for userpath in /home/*; do

        rm -rf $userpath/snap    2>> "$log"

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


# sed: can't read /etc/default/motd-news: No such file or directory

# sed: não é possível ler /etc/default/motd-news: arquivo ou diretório inexistente


# Verifica se o arquivo /etc/default/motd-news existe

if [ -e /etc/default/motd-news ]; then

    echo "$(gettext 'The file /etc/default/motd-news exists.')"

    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news   2>> "$log"

    pro config set apt_news=false  2>> "$log"

else

    echo "$(gettext 'The file /etc/default/motd-news does not exist.')"

fi


}

# ----------------------------------------------------------------------------------------

update_system() {

    apt update 2>> "$log" && apt upgrade -y   2>> "$log"
}

# ----------------------------------------------------------------------------------------

cleanup() {

    # Limpando pacotes desnecessários

    apt autoremove -y  2>> "$log"

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

    message=$(gettext 'The website %s is down. Response code: %s')

    echo "$(printf "$message" "$URL" "$http_response")"

else

  message=$(gettext 'The website %s is online.')

  echo "$(printf "$message" "$URL")"

  apt install -y flatpak  2>> "$log"

  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo  2>> "$log"


fi

    apt install --install-suggests -y gnome-software  2>> "$log"

}

# ----------------------------------------------------------------------------------------

gsettings_wrapper() {

    if ! command -v dbus-launch; then

        sudo apt install -y dbus-x11  2>> "$log"
    fi

    sudo -Hu $(logname) dbus-launch gsettings "$@"  2>> "$log"
}

# ----------------------------------------------------------------------------------------

set_fonts() {


# Para verificar se a fonte $FONT_NAME está instalada no sistema


# Verificar se a fonte está instalada

if fc-list | grep -i "$FONT_NAME"; then

  echo "$(gettext 'A fonte '$FONT_NAME' está instalada.')"


# O comando configura a fonte padrão de texto monospace (fonte de largura fixa, como a usada em terminais e editores de texto) para $FONT_NAME com o tamanho 10.


    # No Ubuntu, o gsettings_wrapper não é um comando padrão.

	gsettings_wrapper set org.gnome.desktop.interface monospace-font-name "$FONT_NAME 10"  2>> "$log"


    # gsettings set org.gnome.desktop.interface monospace-font-name "$FONT_NAME 10"


else

  echo "$(gettext 'A fonte '$FONT_NAME' não está instalada.')"

fi




}

# ----------------------------------------------------------------------------------------

setup_vanilla_gnome() {

    apt install -y qgnomeplatform-qt5  2>> "$log"

    apt install -y gnome-session fonts-cantarell adwaita-icon-theme gnome-backgrounds gnome-tweaks vanilla-gnome-default-settings gnome-shell-extension-manager -y && apt remove ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound  2>> "$log"

    set_fonts 2>> "$log"

    restore_background   2>> "$log"

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


    gsettings_wrapper set org.gnome.desktop.background picture-uri      'file://'$FILE''  2>> "$log"

    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file://'$FILE''  2>> "$log"



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

    command -v curl || apt install -y curl 2>> "$log"


    # Verificar se a pasta /etc/apt/sources.list.d/ existe

    if [ ! -d "/etc/apt/sources.list.d/" ]; then

        echo "$(gettext 'The folder /etc/apt/sources.list.d/ does not exist.')"

        # Se a pasta não existir, o comando mkdir -p cria a pasta. O -p garante que, se a pasta pai não existir, ela também será criada.

        mkdir -p /etc/apt/sources.list.d  2>> "$log"

    fi



# Para verificar se um site está fora do ar.

# URL do site que deseja verificar
URL="https://julianfairfax.gitlab.io"

# Verificar se o site está acessível
http_response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

# Se o código de resposta HTTP for diferente de 200, o site está fora do ar

if [ "$http_response" -ne 200 ]; then


    message=$(gettext 'The website %s is down. Response code: %s')

    echo "$(printf "$message" "$URL" "$http_response")"

else

    message=$(gettext 'The website %s is online.')

    echo "$(printf "$message" "$URL")"


    curl -s https://julianfairfax.gitlab.io/package-repo/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/julians-package-repo.gpg   2>> "$log"

    echo 'deb [ signed-by=/usr/share/keyrings/julians-package-repo.gpg ] https://julianfairfax.gitlab.io/package-repo/debs packages main' | sudo tee /etc/apt/sources.list.d/julians-package-repo.list

    apt update 2>> "$log"

fi




}

# ----------------------------------------------------------------------------------------

install_adwgtk3() {  
  
    apt install -y adw-gtk3 2>> "$log"

    if command -v flatpak; then

        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3-dark  2>> "$log"

        flatpak install -y runtime/org.gtk.Gtk3theme.adw-gtk3       2>> "$log"

    fi

    if [ "$(gsettings_wrapper get org.gnome.desktop.interface color-scheme | tail -n 1)" == ''\''prefer-dark'\''' ]; then

        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3-dark   2>> "$log"

        gsettings_wrapper set org.gnome.desktop.interface color-scheme prefer-dark  2>> "$log"

    else

        gsettings_wrapper set org.gnome.desktop.interface gtk-theme adw-gtk3  2>> "$log"

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


    message=$(gettext 'The website %s is down. Response code: %s')

    echo "$(printf "$message" "$URL" "$http_response")"

else

    message=$(gettext 'The website %s is online.')

    echo "$(printf "$message" "$URL")"



# URL base do repositório Debian

base_url="https://deb.debian.org/debian/pool/main/a/adwaita-icon-theme/"


# Use wget para listar os arquivos na URL e depois grep para pegar o nome do arquivo .deb mais recente

file_name=$(wget -q -O - "$base_url" | grep -o 'adwaita-icon-theme[^"]*all.deb' | sort -V | tail -n 1)


# URL completa do pacote

file_url="${base_url}${file_name}"


# Baixando o pacote

echo "$(gettext 'Downloading the package'): $file_url"

# adwaita-icon-theme_48~beta-3_all.deb

wget -O /tmp/adwaita-icon-theme.deb -c "$file_url"  2>> "$log"



    apt install -y /tmp/adwaita-icon-theme.deb   2>> "$log"

fi


    apt install -y morewaita  2>> "$log"
 
}

# ----------------------------------------------------------------------------------------

restore_firefox() {


# Atualizar repositório Mozilla


# Para verificar se um site está fora do ar.

# URL do site que deseja verificar
URL="https://packages.mozilla.org"

# Verificar se o site está acessível
http_response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")

# Se o código de resposta HTTP for diferente de 200, o site está fora do ar

if [ "$http_response" -ne 200 ]; then


    message=$(gettext 'The website %s is down. Response code: %s')

    echo "$(printf "$message" "$URL" "$http_response")"


else


    message=$(gettext 'The website %s is online.')

    echo "$(printf "$message" "$URL")"


    apt purge -y firefox         2>> "$log"

    snap remove --purge firefox  2>> "$log"



# Verificar se a pasta /etc/apt/keyrings/ existe

# Crie um diretório para armazenar chaves do repositório APT, se ainda não existir

if [ ! -d "/etc/apt/keyrings/" ]; then

  echo "$(gettext 'The /etc/apt/keyrings/ folder does not exist.')"

  mkdir -p /etc/apt/keyrings/      2>> "$log"

  chmod -R 755 /etc/apt/keyrings/  2>> "$log"


fi


# Verificar se a pasta /etc/apt/sources.list.d/ existe

if [ ! -d "/etc/apt/sources.list.d/" ]; then

  echo "$(gettext 'The folder /etc/apt/sources.list.d/ does not exist.')"

  # Se a pasta não existir, o comando mkdir -p cria a pasta. O -p garante que, se a pasta pai não existir, ela também será criada.

  mkdir -p /etc/apt/sources.list.d/  2>> "$log"


fi


# Verificar se a pasta /etc/apt/preferences.d/ existe

if [ ! -d "/etc/apt/preferences.d/" ]; then

  echo "$(gettext 'The /etc/apt/preferences.d/ folder does not exist.')"

  mkdir -p /etc/apt/preferences.d/ 2>> "$log"


fi



    # Importe a chave de assinatura do repositório APT da Mozilla:

    # wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null


    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- > /etc/apt/keyrings/packages.mozilla.org.asc 2>> "$log"



    # Depois adicione o repositório APT da Mozilla à sua lista de origens:

    # echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null 


    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list



# Configure o APT para dar prioridade a pacotes do repositório da Mozilla:

# echo '
# Package: *
# Pin: origin packages.mozilla.org
# Pin-Priority: 1000
# ' | sudo tee /etc/apt/preferences.d/mozilla 


    echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' > /etc/apt/preferences.d/mozilla


# Atualize a lista de pacotes e instale o pacote .deb do Firefox:

apt update  2>> "$log" && apt install -y firefox  2>> "$log"




# Configure outros idiomas no Firefox com arquivos .deb

# Para quem quiser usar o Firefox em um idioma diferente de inglês americano, também 
# criamos pacotes .deb com pacotes de idiomas do Firefox. Use o comando a seguir para 
# instalar o pacote do idioma português brasileiro (se quiser outro, substitua pt-br 
# pelo código de idioma):

# apt-get install -y firefox-l10n-pt-br

# Para listar todos os pacotes de idioma disponíveis, você pode usar este comando após 
# adicionar o repositório APT da Mozilla e executar sudo apt-get update: 
# apt-cache search firefox-l10n 



fi


# https://support.mozilla.org/pt-BR/kb/instale-o-firefox-no-linux


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

remove_telemetry(){


# Desativar a Telemetria do Ubuntu

# O Ubuntu coleta informações de telemetria para ajudar a melhorar a distribuição e oferecer 
# uma melhor experiência para os usuários. A telemetria do Ubuntu pode incluir dados sobre 
# o hardware, software, e como você interage com o sistema. Se você deseja desativar ou 
# remover a coleta de dados de telemetria, há algumas configurações que você pode ajustar 
# para desativar esse processo.

# O Ubuntu tem um serviço chamado ubuntu-report que coleta informações sobre o sistema, 
# como a versão do Ubuntu, pacotes instalados e mais. Para desativar esse serviço, você 
# pode fazer isso através de uma configuração de terminal:



# Verifica se o arquivo /etc/default/ubuntu-report existe

if [ -e /etc/default/ubuntu-report ]; then


sudo sed -i 's/Enabled=1/Enabled=0/' /etc/default/ubuntu-report 2>> "$log"

# Para verificar se o comando foi executado corretamente


if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)


echo -e "${RED}\n$(gettext 'An error occurred while disabling ubuntu-report telemetry collection.') ${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'An error occurred while disabling ubuntu-report telemetry collection.')"

fi



fi


# Desativar a Telemetria do pop-con (para distribuições derivadas, como Pop!_OS)

# Caso esteja usando uma distribuição baseada no Ubuntu, como o Pop!_OS, você pode querer 
# desativar o serviço pop-con que coleta dados de uso. No Ubuntu, isso não é aplicável 
# diretamente, mas se você estiver usando uma versão baseada no Ubuntu (como o Pop!_OS), 
# pode desativar a coleta com o comando:



# Verifica se o serviço pop-con está ativo

if systemctl is-active --quiet pop-con; then

    # Se o serviço estiver ativo, parar e desabilitar o serviço

    sudo systemctl stop pop-con     2>> "$log"

    sudo systemctl disable pop-con  2>> "$log"


    echo "$(gettext 'Pop-con service stopped and disabled.')"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-information.png" -t "$((DELAY * 1000))" "$(gettext 'pop-con')" "$(gettext 'Pop-con service stopped and disabled.')"

else

    echo -e "${GREEN}$(gettext 'Pop-con service is not running.') ${NC}"

fi




# Desativar a coleta de dados de telemetria no Ubuntu Snap

# O Snap (o sistema de pacotes universal do Ubuntu) coleta dados sobre o uso de pacotes 
# instalados. Você pode desativar esse comportamento no Snap da seguinte maneira:

sudo snap set system telemetry=off 2>> "$log"

# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)


echo -e "${RED}\n$(gettext 'An error occurred while disabling telemetry collection for Snap packages.') ${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'An error occurred while disabling telemetry collection for Snap packages.')"


fi


# Explicação:

#     $?: Armazena o código de saída do último comando executado.
#     -ne 0: A opção -ne significa "não é igual" (not equal). Ou seja, a condição será verdadeira se o código de saída não for 0, o que indica erro.
#     notify-send: Exibe uma notificação para o usuário, com o ícone de erro e a mensagem.




# Desativar a coleta de dados do whoopsie

# O Whoopsie é um serviço do Ubuntu que envia dados sobre falhas para a Canonical. Para desativá-lo, execute:

sudo systemctl stop whoopsie     2>> "$log"

sudo systemctl disable whoopsie  2>> "$log"


# Você também pode remover o pacote whoopsie se preferir:

sudo apt-get purge -y whoopsie 2>> "$log"

# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)

echo -e "${RED}\n$(gettext 'An error occurred while removing whoopsie.') ${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'An error occurred while removing whoopsie.')"

fi


# Remover o canonical-livepatch

# O Canonical Livepatch é um serviço pago que aplica correções de segurança em tempo real 
# no Ubuntu. Ele coleta dados, embora de forma limitada. Para desativá-lo ou removê-lo:

# Para desativar:

sudo systemctl stop canonical-livepatch 2>> "$log"

sudo canonical-livepatch disable        2>> "$log"

# Para remover:

sudo apt-get purge -y canonical-livepatch  2>> "$log"



# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)

echo -e "${RED}\n$(gettext 'An error occurred while removing canonical-livepatch.') ${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'An error occurred while removing canonical-livepatch.')"

fi


# Desativar a coleta de dados de pesquisa da Dash:


# Verificar as fontes de pesquisa online ativas:

# Use o seguinte comando para listar as fontes de pesquisa atualmente habilitadas no seu sistema:

gsettings get org.gnome.desktop.search-providers 2>> "$log"


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

gsettings set org.gnome.desktop.search-providers show-all true 2>> "$log"

 
# Desabilita todas as fontes de pesquisa online (incluindo Amazon, eBay, Wikipedia, etc.)

gsettings set org.gnome.desktop.search-providers disabled "['ebay.com', 'wikipedia.org', 'flickr.com']" 2>> "$log"


# Para verificar se o comando foi executado corretamente


if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)

echo -e "${RED}\n$(gettext 'An error occurred while disabling online search sources (eBay, Wikipedia, flickr, etc.)') ${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Notice')" "$(gettext 'An error occurred while disabling online search sources (eBay, Wikipedia, flickr, etc.)')"

fi


# Este comando desabilita especificamente a pesquisa online da Amazon na Dash, que é uma 
# das fontes de dados online mais comuns que o Ubuntu utiliza.

gsettings set org.gnome.desktop.search-providers disabled "['amazon.com']" 2>> "$log"


# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)


echo -e "${RED}\n$(gettext 'An error occurred while disabling Amazon online search in Dash') ${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Notice')" "$(gettext 'An error occurred while disabling Amazon online search in Dash')"

fi


# Alternativa: Desabilitar a pesquisa online via configurações do sistema

# Se preferir, você também pode manualmente desmarcar a opção "Incluir resultados online nas buscas" nas configurações de privacidade do Ubuntu:

#    Vá em Configurações > Privacidade > Pesquisa Online.
#    Desmarque a opção "Incluir resultados online nas buscas".

# O método via script automatiza essa configuração, desativando a pesquisa online e evitando o envio de consultas para serviços como a Amazon.


echo -e "${GREEN}$(gettext "Dash's search data collection has been disabled.") ${NC}"


# https://www.gnu.org/philosophy/ubuntu-spyware.pt-br.html



}

# ----------------------------------------------------------------------------------------


# Para remover PPA (Personal Package Archive) do seu sistema


# Os pacotes instalados via PPAs (Personal Package Archives) geralmente não possuem uma 
# indicação explícita de "PPA" diretamente na lista de pacotes. No entanto, a origem dos 
# pacotes pode ser identificada com base no repositório de onde eles foram instalados. 
# Quando um pacote é instalado de um PPA, ele pode aparecer no formato de origem no 
# comando apt list --installed ou na saída de dpkg -l.


remover_PPA() {

echo "Reverter pacotes instalados via PPAs"




echo "Iniciando a limpeza de pacotes instalados via PPAs..."

# Passo 1: Remover todos os PPAs adicionados

echo "Removendo arquivos .list dos PPAs..."

for ppa in /etc/apt/sources.list.d/*; do
    if [[ "$ppa" == *"ppa:"* ]]; then
        echo "Removendo o PPA: $ppa"
        rm -f "$ppa" 2>> "$log"
    fi
done

# Passo 2: Atualizar a lista de pacotes

echo "Atualizando a lista de pacotes..."
apt update 2>> "$log"


# Passo 3: Remover pacotes instalados via PPAs

echo "Verificando pacotes instalados via PPAs..."

# Embora não seja tão direto, o comando apt list --installed exibe a origem dos pacotes. 
# Para identificar pacotes provenientes de um PPA, procure pela URL do repositório ou 
# pela string "ppa" na origem do pacote.
# 
# Para ver de onde o pacote foi instalado (incluindo PPAs), você pode usar o comando 
# apt-cache showpkg ou apt-cache policy para examinar a origem de um pacote específico. 
# Por exemplo:
# 
# Se o pacote tiver sido instalado de um PPA, a saída vai mostrar a URL do PPA, como 
# no exemplo abaixo:
# 
# $ apt-cache policy vlc
# vlc:
#   Installed: 3.0.11.1-0ubuntu1
#   Candidate: 3.0.11.1-0ubuntu1
#   Version table:
#  *** 3.0.11.1-0ubuntu1 500
#         500 ppa.launchpad.net:~videolan/stable-daily/ubuntu focal/main amd64 Packages
#         100 /var/lib/dpkg/status
# 
# A linha com ppa.launchpad.net indica que o pacote vlc foi instalado de um PPA.
# 
# 
# Conclusão
# 
# Em resumo, você pode identificar pacotes instalados via PPAs verificando a origem de 
# cada pacote com os comandos apt-cache policy, apt list --installed ou dpkg -l. Se o 
# pacote foi instalado a partir de um PPA, a origem do pacote na saída do comando mostrará 
# a URL do PPA (geralmente contendo launchpad.net). Você pode usar essa informação para 
# realizar ações, como remover pacotes que vieram de PPAs específicos.


for package in $(apt list --installed 2>/dev/null | grep -E 'ppa' | cut -d/ -f1); do

    echo "Removendo o pacote: $package"

    # apt-get purge -y "$package" 2>> "$log"

done



# Para remover o comando add-apt-repository do Ubuntu, você precisa desinstalar o 
# pacote software-properties-common, pois esse comando é fornecido por esse pacote.

# Desinstalar o pacote software-properties-common:

sudo apt remove --purge -y software-properties-common 2>> "$log"  && which add-apt-repository



# Nota: Remover o software-properties-common também vai remover ferramentas relacionadas 
# ao gerenciamento de repositórios, o que pode afetar sua capacidade de adicionar PPAs 
# (Personal Package Archives) no futuro. Certifique-se de que não precisa mais dessa 
# funcionalidade antes de prosseguir.


# Passo 4: Limpar pacotes desnecessários e dependências

echo "Removendo pacotes desnecessários..."

apt -y autoremove 2>> "$log"

apt clean 2>> "$log"

echo "A remoção de pacotes instalados por PPAs foi concluída."


}


# ----------------------------------------------------------------------------------------

print_banner() {

clear

    echo "                                                                                                                                   
    ▐            ▗            ▐     ▐       ▝▜  ▝▜      ▐    ▝   ▗   ▗  
▗ ▗ ▐▄▖ ▗ ▗ ▗▗▖ ▗▟▄ ▗ ▗      ▄▟  ▄▖ ▐▄▖ ▗ ▗  ▐   ▐   ▄▖ ▐▗▖ ▗▄  ▗▟▄  ▐  
▐ ▐ ▐▘▜ ▐ ▐ ▐▘▐  ▐  ▐ ▐     ▐▘▜ ▐▘▐ ▐▘▜ ▐ ▐  ▐   ▐  ▐ ▝ ▐▘▐  ▐   ▐   ▐  
▐ ▐ ▐ ▐ ▐ ▐ ▐ ▐  ▐  ▐ ▐  ▀▘ ▐ ▐ ▐▀▀ ▐ ▐ ▐ ▐  ▐   ▐   ▀▚ ▐ ▐  ▐   ▐   ▝  
▝▄▜ ▐▙▛ ▝▄▜ ▐ ▐  ▝▄ ▝▄▜     ▝▙█ ▝▙▞ ▐▙▛ ▝▄▜  ▝▄  ▝▄ ▝▄▞ ▐ ▐ ▗▟▄  ▝▄  ▐  
                                                                                                      


$(gettext 'Download Ubuntu'): https://ubuntu.com/download

$(gettext 'kernel'): `uname -r`

$(gettext 'Processor architecture'): `uname -m`


 "

}

# ----------------------------------------------------------------------------------------

show_menu() {



YAD_OFF(){

echo -e "\n$(gettext 'Choose what to do:') \n"

    echo " 2 - $(gettext 'Disable Ubuntu report')"
    echo " 3 - $(gettext 'Remove app crash popup')"
    echo " 4 - $(gettext 'Remove snaps and snapd')"
    echo " 5 - $(gettext 'Disable terminal ads (LTS versions)')"
    echo " 6 - $(gettext 'Install flathub and gnome-software')" 
    echo " 7 - $(gettext 'Install firefox from the Mozilla repo')"
    echo " 8 - $(gettext 'Install vanilla GNOME session')"
    echo " 9 - $(gettext 'Install adw-gtk3, morewaita and latest adwaita icons')"
    echo "10 - $(gettext 'Apply everything (RECOMMENDED)')"
    echo "11 - $(gettext 'Help')"
    echo "12 - $(gettext 'Disable Telemetry')"
    echo "50 - $(gettext 'Exit')"
    echo

read choice


}


YAD_ON(){

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



# Verifica se o yad está instalado
if command -v yad &> /dev/null
then
    # Se o yad estiver instalado, chama a função

    YAD_ON

else

    # Se o yad não estiver instalado, exibe uma mensagem
    # echo "O YAD não está instalado. Instale o YAD para usar a funcionalidade."

    YAD_OFF
fi


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


# Verifica se o arquivo $log existe

if [ -e "$log" ]; then


    message=$(gettext 'The log file was generated at: %s')


    echo -e "${GREEN}\n$(printf "$message" "$log") \n${NC}"


    # A conexão está fechada

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/software-update-urgent.png" -t "$((DELAY * 1000))" "$(gettext 'Notice')" "$(printf "$message" "$log")"


 
    cat "$log"

fi

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


# Define o caminho do arquivo com base na variável $LANG

file_path="/usr/share/doc/ubuntu-debullshit/README-$(echo $LANG | cut -d. -f1).md"


# Verifica se o arquivo existe

if [ -f "$file_path" ]; then

    # O arquivo $file_path existe.

    yad --center --window-icon="$ICON" --text-info --title="ubuntu-debullshit - $(gettext 'Help')" --filename="$file_path" --buttons-layout=center  --button="$(gettext 'OK')":0 --width="1200" --height="800"

else
    
    # Se o arquivo não existir, exibe a notificação

    message=$(gettext 'The file %s does not exist.')


    # A conexão está fechada

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/software-update-urgent.png" -t "$((DELAY * 1000))" "$(gettext 'Notice')" "$(printf "$message" "$file_path")"


fi




            ;;

        12)

            # Desativar a Telemetria do Ubuntu

            remove_telemetry

            msg "$(gettext 'Done!')"

            ;;

        50)
            # Sair
 
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


    msg "$(gettext 'Disable Telemetry')"

    remove_telemetry


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



