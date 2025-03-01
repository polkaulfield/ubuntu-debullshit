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

# Melhorando a performance do Ubuntu em computadores fracos e pode ser útil também para máquinas mais potentes.


# Changelog: /usr/share/doc/ubuntu-debullshit/CHANGELOG.md



# License: GPL - https://www.gnu.org/


# Desbostificando o Ubuntu!
#
# https://www.youtube.com/watch?v=psOrRNt8jKw


# Arquivo de log

log="/tmp/ubuntu-debullshit.log"



# Logotipo

ICON="/usr/share/icons/ubuntu-debullshit.png"


# Caminho do papel de parede

wallpaper="/usr/share/backgrounds/gnome/blobs-l.svg"



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



# Remover o pacote e as configurações:

# apt purge -y pacote

# O purge vai garantir que todos os arquivos de configuração do pacote também sejam removidos.


clear


# ----------------------------------------------------------------------------------------

# Cores para formatação da saída dos comandos

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # sem cor



# ----------------------------------------------------------------------------------------

# Introdução ao Shell Script 

intro(){



# Salva o texto em um arquivo temporário

echo "Hardware fraco para fazer a otimização:

Processador: Celeron 847 1.1GHz (2 núcleos)
RAM: 2GB DDR3
SSD: 128GB

Atenção: Você não precisa fazer todos os passos, escolha os que achar que ajudarão na sua necessidade.

Melhorando um pouco, mas perdendo recursos.

As mudanças servem para que o sistema fique mais responsivo, mas pode sacrificar algumas comodidades que o 
GNOME Shell traz por padrão. Use se sua máquina realmente precisar, ou se você realmente não usa os recursos.

O arquivo de log ficará em $log ao final dos processos para consulta de erros ou bugs." > /tmp/introducao.txt


introducao=$(cat /tmp/introducao.txt)







# Verifica se a variável DISPLAY está configurada (indicando que estamos em um ambiente gráfico)

if [ -n "$DISPLAY" ]; then

    # Se estiver em ambiente gráfico, usa o yad para exibir um aviso


    # yad --center --title="Aviso" --text="$introducao" --button="OK" --width=800 --height=500 --wrap 

    yad --center --title="$(gettext 'Notice')" --text-info --wrap --editable --width="900" --height="400"  --buttons-layout=center --button="$(gettext 'OK')":0  --filename=/dev/stdin << EOF 
$introducao 
EOF






else

    # Caso contrário, exibe um aviso no terminal (modo texto)

    # echo "Aviso: Modo Texto Detectado!"


dialog                                    \
   --title "$(gettext 'Notice')"          \
   --backtitle 'ubuntu-debullshit'        \
   --msgbox "$(cat /tmp/introducao.txt)"  \
   30 120

    clear



fi



rm -Rf /tmp/introducao.txt


}



# https://aurelio.net/shell/dialog/


# ----------------------------------------------------------------------------------------

    # Removendo pacotes desnecessários


cleanup() {


# O comando apt autoremove -y é utilizado para remover automaticamente pacotes e 
# dependências que foram instalados no sistema, mas que não são mais necessários.
# 
# O que ele faz:
# 
#  Remove pacotes não necessários: Durante a instalação de um software, pode ser que 
# algumas dependências extras (bibliotecas ou outros pacotes) sejam instaladas. Quando o 
# pacote principal é removido, essas dependências podem não ser mais necessárias. O comando 
# apt autoremove identifica esses pacotes e os remove.
# 
#  Limpeza de pacotes órfãos: Pacotes órfãos são aqueles que foram instalados para 
# satisfazer dependências de outros pacotes, mas que agora não têm mais nenhum pacote 
# dependente. O autoremove remove esses pacotes para liberar espaço.
# 
#  Uso do -y: A opção -y faz com que o comando execute a remoção sem pedir confirmação ao 
# usuário. Ou seja, ele remove os pacotes sem solicitar uma aprovação.
# 
# Exemplo de funcionamento:
# 
# Se você desinstalar um pacote, por exemplo, e ele tiver dependências que não são mais 
# usadas por nenhum outro pacote, você pode rodar o comando apt autoremove para removê-las 
# automaticamente e liberar espaço no sistema.
# 
# 
# Exemplo de uso:
# 
# apt autoremove -y
# 
# Isso vai:
# 
#     Identificar pacotes que não são mais necessários (dependências órfãs ou não utilizadas).
#     Remover esses pacotes.
#     Liberar espaço em disco, sem precisar de sua confirmação (graças ao -y).


# Esse comando é útil para manter seu sistema mais limpo e evitar o acúmulo de pacotes desnecessários.




    echo -e "${GREEN}\n$(gettext 'Removing residue from packages...')\n ${NC}"

    sleep 1

    apt autoremove -y 2>> "$log"


}


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




# ----------------------------------------------------------------------------------------

# Verifica a existência de cada comando listado e sai do script caso algum deles não seja 
# encontrado. O uso do loop elimina a necessidade de escrever o comando which repetidamente.


check_programs(){



# ----------------------------------------------------------------------------------------


for cmd in snap apt dpkg systemctl ; do


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


for cmd in yad dialog rm fc-list gettext gsettings notify-send gpg sed sudo curl dd tee wget reboot break flatpak dbus-launch ; do


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

  message=$(gettext 'Your Linux distribution is NOT Ubuntu.

Detected: %s')

  echo -e "${RED}\n $(printf "$message" "$distro") \n ${NC}"

  yad --center --window-icon="$ICON" --image=dialog-error  --title="$(gettext 'ubuntu-debullshit!')" --text="$(gettext 'Your Linux distribution is NOT Ubuntu.')" --buttons-layout=center --button="$(gettext 'OK')":0 --width="650"

  exit

else

    message=$(gettext 'Your Linux distribution is: %s')

    echo -e "${GREEN}$(printf "$message" "$distro") ${NC}"

fi




fi


}




# ----------------------------------------------------------------------------------------


disable_ubuntu_report() {


    rm -Rf ~/.cache/ubuntu-report/         2>> "$log"

    ubuntu-report send no                  2>> "$log"


    echo -e "\n$(gettext 'Uninstalling package...')\n"

    apt purge -y ubuntu-report    2>> "$log"


    # Remova os resíduos.

    cleanup

}


# ----------------------------------------------------------------------------------------

remove_appcrash_popup() {

# Desativar a coleta de dados do apport


# O Apport é uma ferramenta usada para coletar relatórios de falhas e erros no Ubuntu. Você pode desativá-la, caso não queira que ela envie relatórios de falhas.


# Consome muito do hardware verificando os erros e gerando o report.


# Para desativar o Apport, execute o seguinte comando:

echo -e "\n$(gettext 'Stopping service...')\n"

systemctl stop apport     2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

systemctl disable apport  2>> "$log"


# Além disso, você pode editar o arquivo de configuração do Apport para desativá-lo permanentemente:

# sudo nano /etc/default/apport

# E altere a linha:

# enabled=1

# Para:

# enabled=0

# Depois, salve e feche o arquivo.


echo -e "\n$(gettext 'Uninstalling package...')\n"

apt purge -y  apport* apport-gtk  2>> "$log"


# Remova os resíduos.

cleanup


}


# ----------------------------------------------------------------------------------------

remove_snaps() {

    while [ "$(snap list | wc -l)" -gt 0 ]; do

        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do

            echo -e "\n$(gettext 'Uninstalling package...')\n"

            snap remove --purge "$snap" 2>> "$log"

        done

    done


    echo -e "\n$(gettext 'Stopping service...')\n"

    systemctl stop snapd          2>> "$log"


    echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

    systemctl disable snapd       2>> "$log"


    systemctl mask snapd          2>> "$log"


    echo -e "\n$(gettext 'Uninstalling package...')\n"

    apt purge -y snapd*  2>> "$log"


   # Remova os resíduos.

   cleanup


    rm -rf /snap /var/lib/snapd  2>> "$log"



# for userpath in /home/*; do:
# 
#   Esse comando inicia um loop for que percorre todos os diretórios dentro de /home/. O 
# asterisco (*) é um wildcard que representa todos os itens dentro de /home/, ou seja, 
# ele vai iterar sobre todos os diretórios e subdiretórios em /home/.
# 
# rm -rf $userpath/snap:
# 
#   O comando rm -rf é usado para remover recursivamente e de forma forçada arquivos ou 
# diretórios. O parâmetro -r faz com que o comando remova diretórios e seus conteúdos, e 
# o -f força a remoção sem pedir confirmação.
# 
# $userpath/snap é o caminho para o diretório snap dentro do diretório do usuário (por 
# exemplo, /home/usuario/snap). Ou seja, ele tenta apagar o diretório snap dentro do 
# diretório de cada usuário.
# 
#  2>> "$log":
# 
#  Esse comando redireciona qualquer mensagem de erro gerada pelo comando rm para um 
# arquivo de log. O 2>> significa que qualquer erro gerado (identificado pelo descritor 
# de erro 2) será anexado ao arquivo especificado pela variável $log.
# 
#  Isso é útil para registrar qualquer erro, como problemas de permissão ou se o diretório 
# snap não existir, para que o usuário ou administrador saiba o que deu errado.
# 
#  done:
#  Finaliza o loop for. O loop continuará até percorrer todos os diretórios dentro de /home/.
# 
# Resumo:
# 
# Essa parte do script vai iterar por todos os diretórios em /home/ e tentar remover o 
# diretório snap dentro de cada um. Caso ocorra algum erro ao tentar remover, o erro será 
# registrado no arquivo de log especificado pela variável $log.
# 
# Nota de segurança: O comando rm -rf pode ser muito perigoso, pois apaga dados de forma 
# irreversível. É importante ter certeza de que esse tipo de comando está sendo executado 
# de forma controlada e segura.


    for userpath in /home/*; do


        # Verifica se o diretório snap existe dentro do caminho $userpath. O comando -d retorna verdadeiro se o caminho especificado for um diretório existente.

        if [ -d "$userpath/snap" ]; then

           echo -e "\n$userpath/snap \n"  | tee -a "$log"

           # Se o diretório snap existir, ele será removido com o comando rm -rf, e qualquer erro gerado será redirecionado para o arquivo de log.

           rm -rf "$userpath/snap"     2>> "$log"

        fi


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

        apt install -y dbus-x11  2>> "$log"
    fi

    sudo -Hu $(logname) dbus-launch gsettings "$@"  2>> "$log"
}

# ----------------------------------------------------------------------------------------

set_fonts() {


# Para verificar se a fonte $FONT_NAME está instalada no sistema


# Verificar se a fonte está instalada

if fc-list | grep -i "$FONT_NAME"; then

  message=$(gettext 'The font %s is installed.')

  echo -e "${GREEN}\n$(printf "$message" "$FONT_NAME") \n ${NC}"



# O comando configura a fonte padrão de texto monospace (fonte de largura fixa, como a usada em terminais e editores de texto) para $FONT_NAME com o tamanho 10.


    # No Ubuntu, o gsettings_wrapper não é um comando padrão.

	gsettings_wrapper set org.gnome.desktop.interface monospace-font-name "$FONT_NAME 10"  2>> "$log"


    # gsettings set org.gnome.desktop.interface monospace-font-name "$FONT_NAME 10"


else

  message=$(gettext 'The font %s is not installed.')

  echo -e "${RED}\n$(printf "$message" "$FONT_NAME") \n${NC}"


fi




}

# ----------------------------------------------------------------------------------------


setup_vanilla_gnome() {


    apt install -y qgnomeplatform-qt5  2>> "$log"


    apt install -y gnome-session fonts-cantarell adwaita-icon-theme gnome-backgrounds gnome-tweaks vanilla-gnome-default-settings gnome-shell-extension-manager -y && apt purge -y ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound       2>> "$log"


# Remova os resíduos.

cleanup


    set_fonts 2>> "$log"

    restore_background   2>> "$log"

}

# ----------------------------------------------------------------------------------------


restore_background() {



# Verificar se o arquivo existe

if [ -f "$wallpaper" ]; then

  message=$(gettext 'The file %s exists.')

  echo -e "${GREEN}$(printf "$message" "$wallpaper")  ${NC}"


# Verificar se o usuário está utilizando o GNOME como ambiente de desktop


# Verificar o ambiente de desktop atual


# A variável de ambiente XDG_CURRENT_DESKTOP não funciona em gerenciadores de janelas

if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" || "$DESKTOP_SESSION" == "GNOME" ]]; then

  echo "$(gettext 'The user is using GNOME.')"


    # Este comando altera a imagem de fundo da área de trabalho no GNOME para a imagem localizada no caminho $FILE.


    gsettings_wrapper set org.gnome.desktop.background picture-uri      'file://'$wallpaper''  2>> "$log"

    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file://'$wallpaper''  2>> "$log"



    # gsettings set org.gnome.desktop.background picture-uri       'file://'$wallpaper''

    # gsettings set org.gnome.desktop.background picture-uri-dark  'file://'$wallpaper''


else

  echo "$(gettext 'The user is NOT using GNOME.')"

fi






else


    message=$(gettext 'The file %s does not exist.')

    echo -e "${RED}\n$(printf "$message" "$wallpaper") ${NC}"



# Nome do pacote

PACKAGE="gnome-backgrounds"


# Verifica se o pacote está instalado

dpkg -l | grep -q "^ii  $PACKAGE"

if [ $? -eq 0 ]; then

    message=$(gettext 'Package %s is already installed.')

    echo -e "${GREEN}$(printf "$message" "$PACKAGE")  ${NC}"


else

    message=$(gettext 'Package %s is not installed. Installing...')

    echo -e "${RED}\n$(printf "$message" "$PACKAGE") ${NC}"


    echo -e "${GREEN}$(gettext 'Updating package list...')  ${NC}"

    apt update

    apt install -y $PACKAGE

    if [ $? -eq 0 ]; then


    message=$(gettext 'Package %s installed successfully.')

    echo -e "${GREEN}$(printf "$message" "$PACKAGE")  ${NC}"


    else

    message=$(gettext 'Failed to install package %s.')

    echo -e "${RED}\n$(printf "$message" "$PACKAGE") ${NC}"

    fi

fi




fi




}

# ----------------------------------------------------------------------------------------

setup_julianfairfax_repo() {

    command -v curl || apt install -y curl 2>> "$log"


    # Verificar se a pasta /etc/apt/sources.list.d/ existe

    if [ ! -d "/etc/apt/sources.list.d/" ]; then

        echo -e "\n$(gettext 'The folder /etc/apt/sources.list.d/ does not exist.')\n"

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

    echo -e "\n$(printf "$message" "$URL" "$http_response")\n"

else

    message=$(gettext 'The website %s is online.')

    echo -e "\n$(printf "$message" "$URL")\n"


    curl -s https://julianfairfax.gitlab.io/package-repo/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/julians-package-repo.gpg   2>> "$log"

    echo 'deb [ signed-by=/usr/share/keyrings/julians-package-repo.gpg ] https://julianfairfax.gitlab.io/package-repo/debs packages main' | sudo tee /etc/apt/sources.list.d/julians-package-repo.list


    echo -e "${GREEN}$(gettext 'Updating package list...')  ${NC}"

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

    echo -e "\n$(printf "$message" "$URL" "$http_response")\n"

else

    message=$(gettext 'The website %s is online.')

    echo -e "\n$(printf "$message" "$URL")\n"



# URL base do repositório Debian

base_url="https://deb.debian.org/debian/pool/main/a/adwaita-icon-theme/"


# Use wget para listar os arquivos na URL e depois grep para pegar o nome do arquivo .deb mais recente

file_name=$(wget -q -O - "$base_url" | grep -o 'adwaita-icon-theme[^"]*all.deb' | sort -V | tail -n 1)


# URL completa do pacote

file_url="${base_url}${file_name}"


# Baixando o pacote

echo -e "\n$(gettext 'Downloading the package'): $file_url \n"

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

    echo -e "\n$(printf "$message" "$URL" "$http_response")\n"


else


    message=$(gettext 'The website %s is online.')

    echo -e "\n$(printf "$message" "$URL")\n"


    apt purge -y firefox         2>> "$log"

    snap remove --purge firefox  2>> "$log"



# Verificar se a pasta /etc/apt/keyrings/ existe

# Crie um diretório para armazenar chaves do repositório APT, se ainda não existir

if [ ! -d "/etc/apt/keyrings/" ]; then


  echo -e "\n$(gettext 'The /etc/apt/keyrings/ folder does not exist.')\n"


  mkdir -p /etc/apt/keyrings/      2>> "$log"

  chmod -R 755 /etc/apt/keyrings/  2>> "$log"


fi


# Verificar se a pasta /etc/apt/sources.list.d/ existe

if [ ! -d "/etc/apt/sources.list.d/" ]; then

  echo -e "\n$(gettext 'The folder /etc/apt/sources.list.d/ does not exist.')\n"

  # Se a pasta não existir, o comando mkdir -p cria a pasta. O -p garante que, se a pasta pai não existir, ela também será criada.

  mkdir -p /etc/apt/sources.list.d/  2>> "$log"


fi


# Verificar se a pasta /etc/apt/preferences.d/ existe

if [ ! -d "/etc/apt/preferences.d/" ]; then

  echo -e "\n$(gettext 'The /etc/apt/preferences.d/ folder does not exist.')\n"

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

        echo -e "\n$(gettext 'Please run the script as Root!\nWe need to do administrative tasks')\n"

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


sed -i 's/Enabled=1/Enabled=0/' /etc/default/ubuntu-report 2>> "$log"

# Para verificar se o comando foi executado corretamente


if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)


echo -e "${RED}\n$(gettext 'An error occurred while disabling ubuntu-report telemetry collection.') \n${NC}"

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

    echo -e "\n$(gettext 'Stopping service...')\n"

    systemctl stop pop-con     2>> "$log"


    echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

    systemctl disable pop-con  2>> "$log"


    echo -e "\n$(gettext 'Pop-con service stopped and disabled.')\n"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-information.png" -t "$((DELAY * 1000))" "$(gettext 'pop-con')" "$(gettext 'Pop-con service stopped and disabled.')"

else

    echo -e "${GREEN}\n$(gettext 'Pop-con service is not running.') \n${NC}"

fi




# Desativar a coleta de dados de telemetria no Ubuntu Snap

# O Snap (o sistema de pacotes universal do Ubuntu) coleta dados sobre o uso de pacotes 
# instalados. Você pode desativar esse comportamento no Snap da seguinte maneira:

snap set system telemetry=off 2>> "$log"

# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)


echo -e "${RED}\n$(gettext 'An error occurred while disabling telemetry collection for Snap packages.') \n${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'An error occurred while disabling telemetry collection for Snap packages.')"


fi


# Explicação:

#     $?: Armazena o código de saída do último comando executado.
#     -ne 0: A opção -ne significa "não é igual" (not equal). Ou seja, a condição será verdadeira se o código de saída não for 0, o que indica erro.
#     notify-send: Exibe uma notificação para o usuário, com o ícone de erro e a mensagem.




# Desativar a coleta de dados do whoopsie

# O Whoopsie é um serviço do Ubuntu que envia dados sobre falhas para a Canonical. Para desativá-lo, execute:

echo -e "\n$(gettext 'Stopping service...')\n"

systemctl stop whoopsie     2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

systemctl disable whoopsie  2>> "$log"



# Você também pode remover o pacote whoopsie se preferir:

echo -e "\n$(gettext 'Uninstalling package...')\n"

apt purge -y whoopsie 2>> "$log"


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

echo -e "\n$(gettext 'Stopping service...')\n"

systemctl stop canonical-livepatch 2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

systemctl disable canonical-livepatch    2>> "$log"


# Para remover:

echo -e "\n$(gettext 'Uninstalling package...')\n"

apt purge -y canonical-livepatch  2>> "$log"



# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)

echo -e "${RED}\n$(gettext 'An error occurred while removing canonical-livepatch.') \n${NC}"

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


echo -e "${RED}\n$(gettext 'An error occurred while disabling Amazon online search in Dash') \n${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Notice')" "$(gettext 'An error occurred while disabling Amazon online search in Dash')"

fi


# Alternativa: Desabilitar a pesquisa online via configurações do sistema

# Se preferir, você também pode manualmente desmarcar a opção "Incluir resultados online nas buscas" nas configurações de privacidade do Ubuntu:

#    Vá em Configurações > Privacidade > Pesquisa Online.
#    Desmarque a opção "Incluir resultados online nas buscas".

# O método via script automatiza essa configuração, desativando a pesquisa online e evitando o envio de consultas para serviços como a Amazon.


echo -e "${GREEN}\n$(gettext "Dash's search data collection has been disabled.") \n${NC}"


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

echo "Reverter pacotes instalados via PPAs


Warning

Se você é do tipo winuser dependente químico do Baixaki e instala tudo que é lixo de 
terceiros no seu sistema Linux como PPA, .deb, roda scripts e compilações sem saber se 
é para comer ou beber, nem tente usa essa opção, seu sistema muito provavelmente ira 
quebrar.

"



echo -e "${GREEN}\n$(gettext 'Starting to clean up packages installed via PPAs...')  \n${NC}"


# Passo 1: Remover todos os PPAs adicionados

echo "$(gettext 'Removing .list files from PPAs...')"

for ppa in /etc/apt/sources.list.d/*; do

    if [[ "$ppa" == *"ppa:"* ]]; then

        message=$(gettext 'Removing PPA: %s')

        echo -e "${GREEN}$(printf "$message" "$ppa")  ${NC}"


        rm -f "$ppa" 2>> "$log"
    fi

done


# Passo 2: Atualizar a lista de pacotes


echo -e "${GREEN}$(gettext 'Updating package list...')  ${NC}"

apt update 2>> "$log"

sleep 1


# Passo 3: Remover pacotes instalados via PPAs

echo -e "${GREEN}$(gettext 'Checking packages installed via PPAs...')  ${NC}"



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


# Essa parte do código percorre os pacotes instalados no sistema e remove (purge) aqueles 
# que estão relacionados a PPA (Personal Package Archives).

for package in $(apt list --installed 2>/dev/null | grep -E 'ppa' | cut -d/ -f1); do


    message=$(gettext 'Removing package: %s')

    echo -e "${GREEN}\n$(printf "$message" "$package")  \n${NC}"


    # EM FACE DE TESTE

    # apt purge -y "$package" 2>> "$log"


done



# Para remover o comando add-apt-repository do Ubuntu, você precisa desinstalar o 
# pacote software-properties-common, pois esse comando é fornecido por esse pacote.

# Desinstalar o pacote software-properties-common:

apt purge -y software-properties-common 2>> "$log"  && which add-apt-repository



# Nota: Remover o software-properties-common também vai remover ferramentas relacionadas 
# ao gerenciamento de repositórios, o que pode afetar sua capacidade de adicionar PPAs 
# (Personal Package Archives) no futuro. Certifique-se de que não precisa mais dessa 
# funcionalidade antes de prosseguir.


# Passo 4: Limpar pacotes desnecessários e dependências

cleanup


apt clean 2>> "$log"


    echo -e "${GREEN}\n$(gettext 'Removal of packages installed by PPAs has been completed.')\n${NC}"


}


# https://linuxdicasesuporte.blogspot.com/2022/06/ubuntu-2204-extra-lite.html


# ----------------------------------------------------------------------------------------

remove_gnome-online-accounts() {

echo "
Desinstale o GNOME Online Accounts

Integração com contas online (montagem de pastas do Google Drive, e-mail, calendário).

Isso vai remover o suporte às Contas Online e também o serviço (daemon) que fica rodando no sistema.

"

apt purge -y gnome-online-accounts 2>> "$log"


# Remova os resíduos.

cleanup

}


# ----------------------------------------------------------------------------------------

remove_software_stores() {

echo "
Removendo lojas de software e atualizador


Desinstale as 'Lojas de Software' (somente se você sabe lidar com o APT)

Se você costuma gerenciar seus software pela linha de comando, desinstale os 
programas gerenciadores que também mantém serviços (daemons) rodando o tempo todo 
no sistema. Novamente: eu mostro, mas não recomendo, é por sua conta lidar com os 
programas pelo terminal.

O comando abaixo remove as lojinhas, o gerenciador de repositórios e o gerenciador de atualizações, bem como o notificador de atualizações.

"

sleep 5

apt purge -y ubuntu-software gnome-software software-properties-gtk update-manager  2>> "$log"


# Remova os resíduos.

cleanup


}

# ----------------------------------------------------------------------------------------


remove_location_service() {


# O Geoclue é uma biblioteca e serviço no Ubuntu (e em outros sistemas Linux) que fornece 
# informações de localização geográfica para aplicações. Ele permite que aplicativos 
# obtenham dados sobre a localização do dispositivo, como a posição atual (latitude, 
# longitude), usando diversas fontes, como GPS, redes Wi-Fi, torres de celular e outros 
# métodos.
# 
# O Geoclue é comumente usado em sistemas onde o acesso à localização é necessário, como 
# em aplicativos de mapas ou de previsão do tempo. Ele oferece uma maneira fácil de obter 
# essas informações sem que o desenvolvedor precise se preocupar com os detalhes da 
# implementação de diferentes tecnologias de localização.
# 
# Por exemplo, se você usar um aplicativo que solicita permissão para saber sua 
# localização em um computador com Ubuntu, o Geoclue pode ser o serviço que fornece essas 
# informações, dependendo das configurações de rede ou dispositivos disponíveis no sistema.
# 
# Ele também pode ser utilizado em conjunto com outras ferramentas de geolocalização no 
# Ubuntu para tornar o processo de determinar a localização mais preciso e eficiente.
# 
# Se você não precisar dessa funcionalidade, pode desativá-lo ou removê-lo do sistema.



echo -e "${GREEN}\n\n$(gettext "Disable location services

Do this if you don't use programs that rely on location being enabled.") ;) \n${NC}"

sleep 2

# Para desativar o serviço de localização no Ubuntu

# Desativar o serviço de localização (Geoclue2):

# O Ubuntu usa o geoclue2 para obter a localização, então o primeiro passo é parar e desabilitar esse serviço.

echo -e "\n$(gettext 'Stopping service...')\n"

systemctl stop geoclue 2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

# Desabilitar o serviço de localização para que ele não seja iniciado automaticamente:

# Após parar o serviço, para garantir que ele não inicie automaticamente na próxima vez que você reiniciar o computador, execute:

systemctl disable geoclue 2>> "$log"


echo -e "\n$(gettext 'Uninstalling package...')\n"

# (Opcional) Remover o pacote de localização:

# Se você quiser remover completamente o serviço de localização do seu sistema, pode desinstalar o pacote geoclue.

apt purge -y geoclue* 2>> "$log"

# Isso irá desinstalar o serviço de localização.

# Após esses passos, o serviço de localização no Ubuntu estará desativado.



# Remova os resíduos.

cleanup


}



# ----------------------------------------------------------------------------------------


# Desativar o Histórico de Arquivos


disable_file_history() {


# A pesquisa no GNOME Shell é uma funcionalidade central no ambiente de desktop GNOME, que 
# permite aos usuários buscar rapidamente aplicativos, arquivos, configurações e outros 
# itens diretamente pela interface do usuário.
# 
# Quando você pressiona a tecla Super (geralmente a tecla do Windows ou Command em Macs) 
# e começa a digitar no GNOME Shell, o sistema inicia uma pesquisa, permitindo que você 
# encontre diversos itens no seu sistema, como:
# 
#  Aplicativos: Você pode buscar e abrir rapidamente qualquer aplicativo instalado no 
# seu sistema.
# 
#  Arquivos e pastas: Você pode procurar por documentos, imagens, vídeos, entre outros 
# arquivos armazenados no sistema.
# 
#  Configurações: É possível buscar por configurações de sistema específicas, como rede, 
# som, dispositivos, entre outras opções.
# 
#  Ações rápidas: A pesquisa também pode exibir ações rápidas, como abrir o terminal ou 
# outras ferramentas de sistema.
# 
# Funcionalidade
# 
#   Busca inteligente: O GNOME Shell utiliza o Tracker, um sistema de indexação de 
# arquivos, para fornecer resultados rápidos e relevantes.
# 
#   Extensões: O GNOME Shell permite instalar extensões que podem modificar ou melhorar a 
# funcionalidade da pesquisa. Algumas extensões podem adicionar resultados extras, como a 
# integração com serviços online ou fontes externas de dados.
# 
#   Filtros de pesquisa: O sistema pode categorizar os resultados (aplicativos, arquivos, 
# configurações) para tornar a busca mais organizada e intuitiva.
# 
#   Resultados online: Se configurado para tal, o GNOME pode exibir resultados de busca 
# online, como sites ou outros serviços de busca, diretamente no painel de pesquisa.
# 
# Personalização
# 
# A pesquisa no GNOME Shell é altamente configurável. Você pode alterar o comportamento da 
# pesquisa, adicionar ou remover fontes de dados (como fontes online), e até mesmo configurar 
# quais tipos de conteúdo aparecerão nos resultados. As configurações podem ser ajustadas 
# no GNOME Settings (configurações do GNOME) ou por meio de extensões.
# 
# Como Usar
# 
#  Abrir a pesquisa: Pressione a tecla Super ou clique na parte central do painel superior 
# (onde fica o menu de atividades).
# 
#  Digitar: Comece a digitar o nome do aplicativo, arquivo ou configuração que você está 
# procurando.
# 
#  Resultados: O sistema começará a mostrar sugestões enquanto você digita, e você pode 
# clicar ou pressionar Enter para abrir o item desejado.
# 
# Desempenho
# 
# Em versões mais recentes do GNOME, o desempenho da pesquisa foi bastante otimizado, 
# embora a velocidade possa depender de fatores como o número de arquivos no sistema e o 
# uso do Tracker para indexação.
# 
# Se você quiser modificar a forma como a pesquisa funciona ou ajustar o que é indexado, 
# pode acessar a configuração do Tracker ou instalar outras ferramentas para personalizar 
# a pesquisa de acordo com suas necessidades.
# 
# Se precisar de mais detalhes sobre como configurar ou ajustar a pesquisa no GNOME Shell, 
# posso fornecer instruções mais específicas!




echo "

Desative a pesquisa

O GNOME Shell faz pesquisas por arquivos, eventos no calendário, programas na GNOME Software (ou Ubuntu Software), no terminal, além da busca padrão pelos programas instalados.


Desativar a pesquisa vai deixar o sistema bem mais leve, respondendo mais rapidamente. Avalie suas necessidades e decida se vale a pena (eu só faço porque minha máquina é muito, muito fraca).



Desative o Histórico de Arquivos

O GNOME Shell armazena o histórico dos arquivos utilizados para colocar nos itens recentes, em buscas. É um recurso que eu não uso. Se não for importante, desative.

"

# Para desativar o Histórico de Arquivos no Ubuntu, é necessário focar no gnome-initial-setup e no próprio serviço de rastreamento de arquivos.

# Desabilitar o Histórico de Arquivos no GNOME (tracker3 e gnome-shell): No Ubuntu, o GNOME usa o tracker3 para indexar arquivos e criar o histórico de arquivos acessados.

echo "Desabilitando o serviço de rastreamento de arquivos (tracker3)..."

# Para parar o serviço de rastreamento de arquivos:

tracker3 daemon -t 2>> "$log"

# Isso irá parar o serviço tracker3 temporariamente. Para garantir que o serviço não inicie automaticamente, execute o seguinte comando:

systemctl --user mask tracker3-miner-fs.service 2>> "$log"

# Isso irá impedir que o serviço de rastreamento de arquivos seja iniciado automaticamente ao reiniciar o sistema.


# Desabilitar outros serviços relacionados à pesquisa e indexação:

systemctl --user mask tracker3-miner-rss.service  2>> "$log"

systemctl --user mask tracker3-miner-text.service 2>> "$log"




# Desabilitar a pesquisa do GNOME (na interface gráfica e menu de atividades):

# O GNOME Shell também usa o Tracker para realizar a busca de arquivos no sistema, além 
# de permitir que você busque aplicativos e outros itens. Para desabilitar a pesquisa do 
# GNOME, execute o seguinte comando para desativar a busca de arquivos:


# gsettings set org.gnome.desktop.search-providers disabled "['file']"

# Esse comando desabilita a pesquisa de arquivos no GNOME Shell.



# (Opcional) Desabilitar a pesquisa de aplicativos:

# Se você também deseja desabilitar a pesquisa de aplicativos no GNOME, pode configurar isso diretamente:


# gsettings set org.gnome.desktop.search-providers disabled "['application']"

# Esse comando desabilita a pesquisa de aplicativos dentro do GNOME.




echo "Desabilitar o Histórico de Arquivos no GNOME"

# Se você também quiser desabilitar o histórico de arquivos do GNOME, que armazena informações sobre arquivos abertos recentemente:

# Desabilitar o histórico de arquivos no Nautilus: O Nautilus usa uma configuração específica para armazenar o histórico de arquivos acessados. Para desativá-lo, execute:

gsettings set org.gnome.nautilus.history enabled false 2>> "$log"

# Isso irá desabilitar o registro de arquivos acessados no Nautilus e também os itens recentes mostrados no menu "Recentes".


echo "Limpar o histórico de arquivos recentes"

# (Opcional) Apagar o histórico de arquivos armazenado:

# Para limpar os arquivos históricos que já foram gravados, você pode executar este comando:

rm -rf ~/.local/share/recently-used.xbel 2>> "$log"

# Este comando remove o arquivo que contém o histórico de arquivos recentemente acessados.

# Esses passos irão desabilitar o histórico de arquivos e impedir que o Ubuntu rastreie ou armazene arquivos acessados no futuro.


# Após esses passos, o GNOME Shell não armazenará mais o histórico de arquivos acessados, e as buscas e menus não exibirão mais itens recentes.


# O GNOME Shell armazena o histórico dos arquivos utilizados para exibir nos itens recentes e para ajudar nas buscas feitas no sistema. Esse histórico é usado principalmente pelo Nautilus (o gerenciador de arquivos do GNOME) e pelo próprio GNOME Shell, para melhorar a experiência de uso.

# Esse histórico pode ser utilizado para mostrar arquivos recentemente acessados tanto no menu "Atividades" (quando você faz uma busca rápida) quanto nos itens recentes no Nautilus, entre outras partes do sistema.


echo "

Após realizar esses passos, você terá desativado a pesquisa no Ubuntu, incluindo a indexação 
de arquivos, o histórico de arquivos recentes e a pesquisa no GNOME Shell. Isso pode melhorar 
o desempenho, mas também significa que você não poderá mais usar a pesquisa rápida do sistema 
para encontrar arquivos ou aplicativos.

"

}

# ----------------------------------------------------------------------------------------


# Desative as animações [desligar os efeitos visuais da interface]


disable_animations() {

echo -e "\n$(gettext 'Disable GNOME GUI animations')\n"

# Para desativar as animações no Ubuntu, você pode alterar as configurações do GNOME para 
# desativar as animações da interface gráfica. Isso pode ser feito com o comando gsettings, 
# que permite modificar as configurações do GNOME diretamente.


# Para desabilitar as animações no GNOME:

gsettings set org.gnome.desktop.interface enable-animations false 2>> "$log"


# Verifica se houve erro durante a execução

if [ $? -eq 0 ]; then

    # Se o comando for bem-sucedido

    echo -e "${GREEN}$(gettext "Animations have been successfully disabled.") ${NC}"

else

    # Se houver algum erro

    message=$(gettext 'An error occurred while trying to disable animations. Check the log for more details.\n\nError logged in: %s')

    echo -e "${RED}\n$(printf "$message" "$log") ${NC}"

fi


# Esse comando desativa as animações em toda a interface gráfica do GNOME, incluindo 
# animações de transições de janelas, menus, etc.

echo -e "\n$(gettext 'Disable animations when minimizing and restoring windows.')\n"

# Embora o comando acima já desative as animações principais, se você quiser garantir 
# que as animações ao minimizar e restaurar janelas também sejam desativadas, pode usar:

gsettings set org.gnome.desktop.wm.preferences minimize-animations false 2>> "$log"

# Isso desativa as animações ao minimizar janelas.


# Verifica se houve erro durante a execução

if [ $? -eq 0 ]; then

    # Se o comando for bem-sucedido

    echo -e "${GREEN}$(gettext "Window minimize and restore animations have been successfully disabled.") ${NC}"

else

    # Se houver algum erro

    message=$(gettext 'An error occurred while trying to disable window minimize and restore animations. Check the log for more details.\n\nError logged in: %s')

    echo -e "${RED}\n$(printf "$message" "$log") ${NC}"
fi


# (Opcional) Desativar as animações de abertura e fechamento de aplicativos:

# Se você deseja desativar animações específicas de abertura e fechamento de aplicativos, 
# você pode alterar as configurações do GNOME Shell. No entanto, o comando anterior já 
# lida com a maioria das animações da interface, incluindo as de aplicativos.

# Após esses passos, você terá desativado a maioria das animações no Ubuntu, o que pode 
# resultar em uma experiência mais rápida, especialmente em sistemas com hardware mais 
# limitado.



}


# https://diolinux.com.br/gnome/como-desativar-efeitos-do-gnome-shell.html
# https://www.youtube.com/watch?v=nhFOu8Levtc&t=467s


# ----------------------------------------------------------------------------------------

# Desative as atualizações automáticas

disable_automatic_updates() {

echo "
Se você se lembra de atualizar o sistema de vez em quando, desative a atualização automática.

As atualizações automáticas serão desativadas, incluindo a desativação do serviço unattended-upgrades e a verificação de novas versões do Ubuntu.
"


# Desativar atualizações automáticas no Ubuntu

echo "Desativando atualizações automáticas de pacotes e segurança...

O Ubuntu gerencia as atualizações automáticas por meio do unattended-upgrades, que é 
responsável por instalar automaticamente atualizações de segurança e outras atualizações 
importantes.
"

# Editando o arquivo 20auto-upgrades para desabilitar as atualizações automáticas

# Dentro desse arquivo, você verá duas linhas semelhantes a estas:

# APT::Periodic::Update-Package-Lists "1";
# APT::Periodic::Unattended-Upgrade "1";

# Altere o valor "1" para "0" para desativar as atualizações automáticas. O arquivo ficará assim:

# APT::Periodic::Update-Package-Lists "0";
# APT::Periodic::Unattended-Upgrade "0";




# Este comando altera a configuração que controla a frequência com que o Ubuntu verifica 
# pacotes de atualização. O valor "0" significa desabilitar a atualização automática da 
# lista de pacotes. Essa configuração originalmente pode ser 1, que significa que a 
# verificação de pacotes ocorre periodicamente, mas ao definir "0", você está desabilitando 
# essa verificação automática.


echo "APT::Periodic::Update-Package-Lists \"0\";" | sudo tee /etc/apt/apt.conf.d/20auto-upgrades > /dev/null


# Esse comando altera a configuração que controla as atualizações automáticas de pacotes, 
# ou seja, a atualização automática de pacotes de segurança e outros pacotes importantes. 
# Da mesma forma que o primeiro comando, o valor "0" desativa o processo de atualizações 
# automáticas (unattended-upgrades). O valor padrão seria "1", que significa que o sistema 
# tenta fazer as atualizações automaticamente.

echo "APT::Periodic::Unattended-Upgrade \"0\";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades > /dev/null


# O que acontece quando você executa esses comandos?

#     APT::Periodic::Update-Package-Lists "0";: Desabilita a verificação automática de atualizações de pacotes.
#     APT::Periodic::Unattended-Upgrade "0";: Desabilita a instalação automática de atualizações de segurança e outros pacotes.



# Parar e desabilitar o serviço unattended-upgrades

echo "
Desabilitar o serviço unattended-upgrades:

Além de desabilitar a configuração para atualizações automáticas, podemos garantir que o 
serviço que gerencia essas atualizações automáticas não seja executado.
"

# Parando o serviço unattended-upgrades...

echo -e "\n$(gettext 'Stopping service...')\n"

systemctl stop unattended-upgrades     2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

systemctl disable unattended-upgrades  2>> "$log"

# Isso desativa o serviço que gerencia as atualizações automáticas no Ubuntu, evitando 
# que ele seja executado após reiniciar o sistema.




# Desabilitar atualizações automáticas no Update Manager

echo "Desabilitando a verificação automática de novas versões..."

# Desativar atualizações automáticas no update-manager:

# Se você usar o Atualizador de Software (Update Manager) e ele verificar por atualizações 
# automaticamente, você pode também desativar isso, editando o arquivo de configurações 
# do update-manager


# Caminho do arquivo
FILE="/etc/update-manager/release-upgrades"

# Verificar se o arquivo existe

if [ -e "$FILE" ]; then

  echo "O arquivo $FILE existe."

#  Editar o arquivo de configurações

# Encontre a linha Prompt=lts e altere o valor para Prompt=never, para desabilitar a verificação automática de novas versões do Ubuntu:

sed -i 's/Prompt=lts/Prompt=never/' /etc/update-manager/release-upgrades

# Isso evita que o Ubuntu faça verificações automáticas por novas versões do sistema operacional.

echo "Atualizações automáticas desativadas com sucesso.

Esses passos garantirão que o Ubuntu não realize atualizações automáticas, dando a você controle total sobre quando as atualizações serão feitas.
"


else

  echo "O arquivo $FILE não existe."

fi


}


# ----------------------------------------------------------------------------------------


disable_GNOME_extensions() {


# * Desative as extensões (pelo menos as que não usa)


# O comando gnome-extensions disable é utilizado para desativar uma extensão do GNOME 
# (um ambiente de desktop para Linux). O GNOME permite que você adicione funcionalidades 
# extras ao sistema por meio de "extensões". Quando você executa o comando 
# gnome-extensions disable, você está desabilitando uma extensão específica sem removê-la 
# do sistema. Isso pode ser útil quando você deseja temporariamente desativar uma extensão 
# para testar ou resolver problemas sem precisar desinstalá-la.


echo -e "${GREEN}$(gettext "Disable all GNOME extensions at once") ${NC}"


echo -e "\n$(gettext 'Extensions that are active on your system:')\n" | tee -a "$log"

gnome-extensions list | tee -a "$log"

# Isso irá retornar uma lista das extensões instaladas e ativas no GNOME.


# Para desativar uma extensão, use o comando abaixo, substituindo <nome_da_extensao> pelo nome da extensão que você deseja desativar (obtido com o comando gnome-extensions list):

# gnome-extensions disable <nome_da_extensao>


# Desativar todas as extensões de uma vez

for ext in $(gnome-extensions list); do


    message=$(gettext 'Disabling extension: %s')

    echo -e "\n$(printf "$message" "$ext")\n" >> "$log"

    echo -e "${RED}\n$(printf "$message" "$ext") ${NC}"


    gnome-extensions disable $ext  2>> "$log"


done

# Esse comando percorre todas as extensões ativas e as desativa uma por uma.


# Verificar se as extensões foram desativadas:

# Para verificar se as extensões foram desativadas, basta executar novamente o comando gnome-extensions list e verificar se as extensões estão listadas como desativadas.


echo -e "\n$(gettext 'Extensions that are active on your system now:')\n" | tee -a "$log"

gnome-extensions list | tee -a "$log"


}

# ----------------------------------------------------------------------------------------

# Para desativar os espaços de trabalho dinâmicos no GNOME


Static_Workspaces() {


echo "
* Espaços de trabalho estáticos (fixar o número de espaços de trabalho e deixar como estáticos.)

Para configurar os Espaços de Trabalho Estáticos no Ubuntu (ou seja, fixar o número de 
espaços de trabalho e torná-los estáticos), você precisará alterar as configurações do 
GNOME Shell.

Por padrão, o GNOME Shell permite que os espaços de trabalho se ajustem dinamicamente — ou 
seja, o número de espaços de trabalho aumenta conforme você abre mais janelas e diminui 
quando você fecha algumas delas. Para configurar isso para um número fixo de espaços de 
trabalho.

"

echo -e "${GREEN}$(gettext "Disable dynamic workspaces (make them static)") ${NC}"


# Para garantir que os Espaços de Trabalho sejam fixos e não se ajustem dinamicamente:

gsettings set org.gnome.desktop.wm.preferences dynamic-workspaces false  2>> "$log"

# Esse comando desabilita a opção de "espaços de trabalho dinâmicos", garantindo que o 
# número de espaços de trabalho seja fixo.


echo -e "\n$(gettext 'Set the fixed number of workspaces to two.')\n"


#  Definir o número de espaços de trabalho fixos:

# Agora que você desativou a criação dinâmica de espaços de trabalho, você pode definir 
# quantos espaços de trabalho fixos deseja. O número padrão é 4, mas você pode definir 
# um número diferente.

# Por exemplo, para definir 2 espaços de trabalho fixos, execute o seguinte comando:

gsettings set org.gnome.desktop.wm.preferences num-workspaces 2  2>> "$log"

# Você pode substituir o número 2 pelo número de espaços de trabalho que você desejar.

    
echo -e "${RED}\n$(gettext 'This will ensure that the number of workspaces is fixed, and will not change 
automatically based on the number of open windows.') \n\n${NC}"


}



# ----------------------------------------------------------------------------------------


startup_programs() {


# Desativar programas que iniciam com o sistema.


echo "

* Aplicativos de Inicialização

Alguns programas são configurados para iniciarem junto com o sistema. Se você quiser, remova os que não são necessários na inicialização.



* Desinstale o suporte a Bluetooth e impressão

Eu não tenho impressora e meu notebook não possui adaptador Bluetooth. Veja se isso se aplica ao seu uso.
Obs.: O unnatended-upgrades foi de brinde no comando, me perdoem por colocar fora do tópico. Ele deveria estar no anterior, sobre os atualizadores automáticos.

sudo apt purge cups bluez unattended-upgrades




No Ubuntu, existem vários programas que são configurados para iniciar automaticamente 
quando o sistema é inicializado. Esses programas são geralmente definidos no Gerenciador 
de Inicialização ou em arquivos de configuração de aplicativos específicos.


    Verificando no terminal (usando gnome-session-properties)

    Para listar as aplicações que estão configuradas para iniciar automaticamente, você pode usar o seguinte comando:

    gnome-session-properties

    Isso abrirá a mesma interface gráfica mencionada anteriormente.

    Verificando os arquivos de configuração no diretório ~/.config/autostart/

    As aplicações que iniciam automaticamente podem ter arquivos de configuração localizados no diretório ~/.config/autostart/. Você pode listar esses arquivos de configuração com o seguinte comando:

ls ~/.config/autostart/

Esse diretório contém arquivos .desktop que definem programas que serão executados na inicialização. Você pode verificar os conteúdos desses arquivos com o seguinte comando:

    cat ~/.config/autostart/nome-do-programa.desktop

    Verificando com o systemd (para serviços de sistema)

    

Como desabilitar programas de inicialização:

Se você deseja desabilitar algum programa da inicialização, pode fazê-lo de duas maneiras principais:

    Usando a interface gráfica (gnome-session-properties):
        Abra o aplicativo Aplicativos de Sessão e desmarque os programas que você não deseja iniciar automaticamente.

    Usando o terminal:

        Para desabilitar um programa de inicialização manualmente, remova ou mova o arquivo .desktop correspondente de ~/.config/autostart/. Por exemplo:

        mv ~/.config/autostart/nome-do-programa.desktop ~/.config/autostart/nome-do-programa.desktop.bak

    Isso desabilitará o programa da inicialização sem apagá-lo completamente.

Essas são as principais formas de visualizar e controlar os programas que iniciam automaticamente no Ubuntu.
Você disse:
cria uma script para desativar serviços do ubuntu
O ChatGPT disse:

Aqui está um script simples para desativar serviços no Ubuntu usando o systemctl. Esse script pode ser usado para desativar vários serviços que são carregados automaticamente durante a inicialização do sistema. Lembre-se de que desativar serviços pode afetar o funcionamento de certos recursos, então certifique-se de que você sabe o que cada serviço faz antes de desativá-lo.
Script para desativar serviços no Ubuntu:






O que o faz:

    Desativa serviços específicos: A lista no script inclui serviços como o Bluetooth, Apache2, firewalld, Snapd, NetworkManager, entre outros.
    Para e desabilita os serviços: O script para o serviço imediatamente (systemctl stop) e depois o desabilita para que não seja iniciado automaticamente na próxima vez que o sistema for reiniciado (systemctl disable).




Personalizando:

Você pode adicionar ou remover serviços da lista conforme necessário. Para verificar quais serviços estão ativos no seu sistema, execute:

systemctl list-units --type=service --state=running

Esse comando irá listar todos os serviços ativos no seu sistema.

Atenção:

    Desabilitar certos serviços pode causar problemas, especialmente serviços críticos como NetworkManager (que gerencia a rede) ou udisks2 (que gerencia dispositivos de armazenamento). Verifique com cuidado o que cada serviço faz antes de desativá-lo.

    Caso queira reativar qualquer serviço desabilitado, você pode fazer isso com os seguintes comandos:

    sudo systemctl enable nome-do-serviço
    sudo systemctl start nome-do-serviço

Esse script oferece uma maneira simples de desativar serviços que você não precisa em seu sistema, o que pode ajudar a melhorar o desempenho ou reduzir o consumo de recursos.


"


echo -e "${GREEN}$(gettext "Disable programs that start with the system") ${NC}"


# Como verificar os programas que iniciam automaticamente no Ubuntu:
# 
#  Usando a ferramenta "Aplicativos de Sessão" (Startup Applications)
# 
#  Você pode visualizar e gerenciar programas de inicialização através da interface gráfica. Para fazer isso:
#
#   Abra o menu Atividades e digite "Aplicativos de Sessão" ou "Startup Applications".
#   Isso abrirá uma janela com a lista de programas configurados para iniciar automaticamente.



# Para desativar serviços no Ubuntu

echo -e "\n$(gettext 'Programs that start automatically with the system:')\n" | tee -a "$log"

# O systemd é o sistema de inicialização que o Ubuntu usa para gerenciar os serviços do 
# sistema. Alguns programas podem ser configurados para iniciar como serviços do sistema, 
# e você pode listar esses serviços com o seguinte comando:

message=$(gettext 'Files in folder %s: ')

echo -e "\n$(printf "$message" "$HOME/.config/autostart")\n" | tee -a "$log"


ls -lh ~/.config/autostart/ | tee -a "$log"


echo "" | tee -a "$log"


message=$(gettext 'Files in folder %s: ')

echo -e "\n$(printf "$message" "/etc/xdg/autostart")\n" | tee -a "$log"

ls -lh /etc/xdg/autostart/  | tee -a "$log"


systemctl list-unit-files --type=service | grep enabled  | tee -a "$log"

# Esse comando lista os serviços do sistema que estão configurados para iniciar automaticamente.

# Exemplos de programas que geralmente estão na inicialização do Ubuntu:

#     NetworkManager: Gerencia as conexões de rede.
#     gnome-keyring-daemon: Responsável pelo gerenciamento de senhas e chaves de criptografia.
#     bluetooth: Gerencia dispositivos Bluetooth.
#     gnome-shell: O próprio GNOME Shell, que é o ambiente de desktop.
#     seahorse: O gerenciador de chaves GNOME.
#     gnome-settings-daemon: Daemon para gerenciar as configurações do GNOME (como temas, resolução de tela, etc.).
#     zeitgeist-daemon: Armazena e pesquisa histórico de atividades.
#    upowerd: Gerencia o consumo de energia.



# Lista de serviços para desativar

services=(
  "bluetooth.service"          # Desativa o serviço Bluetooth
  "cups.service"               # Desativa o serviço de impressão
  "apache2.service"            # Desativa o serviço Apache (se não precisar de servidor web)
  "snapd.service"              # Desativa o serviço Snap   (caso queira desabilitar o uso de pacotes Snap)
)

#  "firewalld.service"          # Desativa o firewall, caso não queira usar
#  "udisks2.service"            # Desativa o gerenciamento de discos
#  "ModemManager.service"       # Desativa o serviço de gerenciamento de modem
#  "NetworkManager.service"     # Desativa o gerenciador de rede (cuidado, pode afetar a conectividade)






# Desativando os serviços

for service in "${services[@]}"; do

  message=$(gettext 'Disabling service: %s')

  echo -e "\n$(printf "$message" "$service") \n" | tee -a "$log"


  echo -e "\n$(gettext 'Stopping service...')\n"

  systemctl stop "$service"      2>> "$log"     # Para o serviço imediatamente


# Verifica se houve erro durante a execução

if [ $? -eq 0 ]; then

    # Se o comando for bem-sucedido

    message=$(gettext "Service %s has been stopped successfully.")

    echo -e "${GREEN}\n$(printf "$message" "$service") \n${NC}"

else

    # Se houver algum erro

    message=$(gettext "An error occurred while trying to stop service %s. Check the log for more details.\n\nError logged: %s")

    echo -e "${RED}\n$(printf "$message" "$service" "$log") ${NC}"

fi




  echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

  systemctl disable "$service"   2>> "$log"     # Desabilita o serviço para não iniciar automaticamente na inicialização



# Verifica se houve erro durante a execução

if [ $? -eq 0 ]; then

    # Se o comando for bem-sucedido

    message=$(gettext "The %s service has been successfully disabled.")

    echo -e "${GREEN}\n$(printf "$message" "$service") \n${NC}"

else

    # Se houver algum erro

    message=$(gettext "An error occurred while trying to disable service %s. Check the log for more details.\n\nError logged: %s")

    echo -e "${RED}\n$(printf "$message" "$service" "$log") ${NC}"
fi



done


# O tee é um comando que lê a entrada e a escreve tanto na saída padrão (no terminal) quanto em um arquivo especificado.
# A opção -a (append) faz com que o tee adicione a mensagem ao final de um arquivo de log existente (especificado pela variável $log), em vez de sobrescrevê-lo.


# Services disabled successfully!

# echo "Serviços desativados com sucesso!"



}



# https://medium.com/@leandroembu/melhorando-a-performance-do-ubuntu-em-computadores-fracos-6b60c1a2678#:~:text=Desinstale%20o%20GNOME%20Online%20Accounts&text=Isso%20vai%20remover%20o%20suporte%20%C3%A0s%20Contas,servi%C3%A7o%20(daemon)%20que%20fica%20rodando%20no%20sistema.


# ----------------------------------------------------------------------------------------


# Redefinir o ambiente de desktop GNOME


reset_GNOME(){


# Verifica o nome de usuário

user=$(whoami)


# Verifica se o usuário é Root

if [ "$user" == "root" ]; then

    echo -e "${RED}\n$(gettext 'The user is Root.') \n${NC}"

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-error.png" -t "$((DELAY * 1000))" "$(gettext 'Restore Gnome Interface')" "\n$(gettext 'The user is Root.')\n"

    exit 1

fi



# No Linux, o grupo wheel e o grupo sudo podem ter funções semelhantes, mas não são 
# exatamente a mesma coisa. Ambos os grupos geralmente concedem permissões para que o 
# usuário execute comandos como superusuário (ou seja, usando sudo), mas o comportamento 
# depende da distribuição e da configuração do sistema.


# Verifica se o usuário está no grupo sudo ou wheel

if groups "$user" | grep -q '\bsudo\b' || groups "$user" | grep -q '\bwheel\b'; then

sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-error.png" -t "$((DELAY * 1000))" "$(gettext 'Restore Gnome Interface')" "\n$(gettext 'The user has sudo permissions.')\n"

    exit 1

fi


    echo -e "${GREEN}$(gettext 'The user is common and does not have Root or sudo permissions.')  ${NC}"



# Como redefinir o ambiente Gnome Desktop no Ubuntu

# Primeiro acessei o terminal tty1: (Ctrl+Alt+F1)

# 
# Para restaurar as configurações padrão. Isso pode ser útil se você estiver enfrentando 
# problemas ou se deseja começar do zero com o GNOME.
# 
# 
# Método 1: Usando o comando dconf
# 
# O GNOME armazena a maioria das configurações no banco de dados dconf. Redefinir o dconf 
# para os padrões pode corrigir configurações problemáticas.

dconf reset -f /org/gnome/

# Isso irá resetar as configurações do GNOME para o estado padrão.


sudo -u $SUDO_USER DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-warning.png" -t "$((DELAY * 1000))" "$(gettext 'Restore Gnome Interface')" "\n$(gettext 'Restart GNOME (or reboot your system) for the changes to take effect. You can restart GNOME with the command:\n\n# killall -3 gnome-shell')\n"



# Método 2: Redefinindo as configurações do GNOME usando gnome-tweaks
# 
# Se você tem o GNOME Tweaks instalado, pode redefinir algumas configurações específicas 
# através dessa ferramenta:
# 
#     Abra GNOME Tweaks (Você pode procurar por "Ajustes" ou "Tweaks" no menu de aplicativos).
#     Vá para a aba que você deseja resetar (por exemplo, "Extensões", "Aparência" ou "Comportamento").
#     Dependendo da configuração, você pode manualmente voltar às configurações padrão.



# Método 3: Remover e reinstalar o GNOME (mais drástico)
# 
# Se você quiser uma reinstalação completa do GNOME, incluindo a interface e as configurações, 
# você pode remover e reinstalar o GNOME. Este método apagará as configurações pessoais, 
# portanto, tenha cuidado!
# 
#     Abra o Terminal e remova o GNOME:
# 
# apt purge -y gnome-shell
# 
# Reinstale o GNOME:
# 
# apt install --reinstall -y gnome-shell
# 
# Após a reinstalação, reinicie o computador.

# Esses métodos ajudam a redefinir ou restaurar o ambiente GNOME para o estado padrão. O 
# primeiro método é o mais seguro, pois não apaga seus arquivos, apenas as configurações 
# do sistema.


# https://www.edivaldobrito.com.br/redefinir-o-ambiente-gnome-desktop-no-ubuntu/
# https://lerlinux.blogspot.com/2019/10/restaurar-interface-gnome.html
# https://sempreupdate.com.br/linux/tutoriais/como-reiniciar-uma-sessao-congelada-ou-travada-no-gnome/
# https://diolinux.com.br/gnome/como-resetar-o-ubuntu-com-gnome-shell.html

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
    echo "13 - $(gettext 'Uninstall GNOME Online Accounts - Online Accounts Integration')"
    echo "14 - $(gettext 'Uninstall Software Stores')"
    echo "15 - $(gettext 'Disable location service')"
    echo "16 - $(gettext 'Disable File History')"
    echo "17 - $(gettext 'Disable GNOME GUI animations')"
    echo "18 - $(gettext 'Disable all GNOME extensions at once')"
    echo "19 - $(gettext 'Disable dynamic workspaces (make them static)')"
    echo "20 - $(gettext 'Disable programs that start with the system')"
    echo "21 - $(gettext 'Remove PPA (Personal Package Archive) from the system')"
    echo "22 - $(gettext 'Restore Gnome Interface')"
    echo "50 - $(gettext 'Exit')"
    echo

read choice


}


YAD_OFF2(){

choice=$(dialog \
--backtitle 'ubuntu-debullshit' \
--title "$(gettext 'Menu')" \
--menu "$(gettext 'Choose what to do:')" 30 80 30 \
2  "$(gettext 'Disable Ubuntu report')" \
3  "$(gettext 'Remove app crash popup')" \
4  "$(gettext 'Remove snaps and snapd')" \
5  "$(gettext 'Disable terminal ads (LTS versions)')" \
6  "$(gettext 'Install flathub and gnome-software')" \
7  "$(gettext 'Install firefox from the Mozilla repo')" \
8  "$(gettext 'Install vanilla GNOME session')" \
9  "$(gettext 'Install adw-gtk3, morewaita and latest adwaita icons')" \
10 "$(gettext 'Apply everything (RECOMMENDED)')" \
11 "$(gettext 'Help')" \
12 "$(gettext 'Disable Telemetry')" \
13 "$(gettext 'Uninstall GNOME Online Accounts - Online Accounts Integration')" \
14 "$(gettext 'Uninstall Software Stores')" \
15 "$(gettext 'Disable location service')" \
16 "$(gettext 'Disable File History')" \
17 "$(gettext 'Disable GNOME GUI animations')" \
18 "$(gettext 'Disable all GNOME extensions at once')" \
19 "$(gettext 'Disable dynamic workspaces (make them static)')" \
20 "$(gettext 'Disable programs that start with the system')" \
21 "$(gettext 'Remove PPA (Personal Package Archive) from the system')" \
22 "$(gettext 'Restore Gnome Interface')" \
50 "$(gettext 'Exit')" --stdout)

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
false 13 "$(gettext 'Uninstall GNOME Online Accounts - Online Accounts Integration')" \
false 14 "$(gettext 'Uninstall Software Stores')" \
false 15 "$(gettext 'Disable location service')" \
false 16 "$(gettext 'Disable File History')" \
false 17 "$(gettext 'Disable GNOME GUI animations')" \
false 18 "$(gettext 'Disable all GNOME extensions at once')" \
false 19 "$(gettext 'Disable dynamic workspaces (make them static)')" \
false 20 "$(gettext 'Disable programs that start with the system')" \
false 21 "$(gettext 'Remove PPA (Personal Package Archive) from the system')" \
false 22 "$(gettext 'Restore Gnome Interface')" \
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


# Verifica se o dialog está instalado

if command -v dialog &> /dev/null
then

    sleep 2

    YAD_OFF2

else

    YAD_OFF

fi




fi



# https://www.bosontreinamentos.com.br/shell-script/shell-scripting-criando-caixas-de-dialogo-tui-com-dialog/

}



# ----------------------------------------------------------------------------------------


main() {


    check_root_user

    check_internet
    check_programs
    check_distro

    intro


    # Inicio do loop

    while true; do

        print_banner

        show_menu

        # echo "$choice"


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

        13)

            # Desinstale o GNOME Online Accounts - Integração com contas online

            remove_gnome-online-accounts

            msg "$(gettext 'Done!')"

            ;;

        14)

            # Remove lojas de software e atualizador

            remove_software_stores

            msg "$(gettext 'Done!')"

            ;;

        15)

            # Desativar o serviço de localização

            remove_location_service

            msg "$(gettext 'Done!')"

            ;;

        16)

            # Desativar o Histórico de Arquivos

            disable_file_history

            msg "$(gettext 'Done!')"

            ;;

        17)

            # Desativar as animações da interface gráfica GNOME

            disable_animations

            msg "$(gettext 'Done!')"

            ;;

        18)
            
            # Desativar todas as extensões de uma vez do GNOME

            disable_GNOME_extensions

            msg "$(gettext 'Done!')"

            ;;

        19)

            # Desabilitar espaços de trabalho dinâmicos (torná-los estáticos)

            Static_Workspaces

            msg "$(gettext 'Done!')"

            ;;

        20)

            # Desativar programas que iniciam com o sistema.

            startup_programs            

            msg "$(gettext 'Done!')"

            ;;

        21)

            # Remover PPA (Personal Package Archive) do sistema

            remover_PPA
            
            msg "$(gettext 'Done!')"

            ;;

        22)

            # Redefinir o ambiente de desktop GNOME

            reset_GNOME            

            msg "$(gettext 'Done!')"

            ;;

        23)

            # 
       

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

    # Fim do loop

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


    msg $(gettext 'Uninstall GNOME Online Accounts - Online Accounts Integration')

    remove_gnome-online-accounts


    # Remove lojas de software e atualizador

    msg "$(gettext 'Uninstall Software Stores')"

    remove_software_stores


    # Desativar o serviço de localização

    msg "$(gettext 'Disable location service')"

    remove_location_service


    # Desativar o Histórico de Arquivos

    msg "$(gettext 'Disable File History')"

    disable_file_history


    # Desativar as animações da interface gráfica GNOME

    msg "$(gettext 'Disable GNOME GUI animations')"

    disable_animations


    # Desativar todas as extensões de uma vez do GNOME

    msg "$(gettext 'Disable all GNOME extensions at once')"

    disable_GNOME_extensions


    # Desabilitar espaços de trabalho dinâmicos (torná-los estáticos)

    msg "$(gettext "Disable dynamic workspaces (make them static)")"

    Static_Workspaces



    # Desativar programas que iniciam com o sistema.

    msg "$(gettext "Disable programs that start with the system")"

    startup_programs            


    # Remover PPA (Personal Package Archive) do sistema

    msg "$(gettext "Remove PPA (Personal Package Archive) from the system")"

    remover_PPA


    # Redefinir o ambiente de desktop GNOME

    msg $(gettext 'Restore Gnome Interface')

    reset_GNOME




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



