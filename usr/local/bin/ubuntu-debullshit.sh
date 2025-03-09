#!/usr/bin/env bash

##########################################################################################
#                                                                                        #
# O Shell Script pode usar o dialog ou Yad.                                              #
#                                                                                        #
# Obs: Não esqueca que para funcionar o comando gettext, notify-send, pacote             #
# gnome-icon-theme e Yad ou dialog tem que estar instalado no seu Linux.                 #
#                                                                                        #
# Melhorando o desempenho do Ubuntu em computadores de baixa potência, também útil para  #
# máquinas mais potentes.                                                                #
#                                                                                        #
# Suporte a idiomas: Português (Brasil) e Inglês (Estados Unidos)                        #
#                                                                                        #
# Authors:                                                                               #
#                                                                                        #
# polkaulfield   - https://github.com/polkaulfield                                       #
#                                                                                        #
# Fernando Souza - https://www.youtube.com/@fernandosuporte/                             #
#                  https://github.com/tuxslack/ubuntu-debullshit                         #
#                                                                                        #
# Version: 1.0.1                                                                         #
# Date:    19/04/2024 as 16:44                                                           #
# Script:  ubuntu-debullshit.sh                                                          #
#                                                                                        #
# Licenca: GNU/GPL - https://www.gnu.org/                                                #
#                                                                                        #
#                                                                                        #
# Dê permissão para executar o script:                                                   #
#                                                                                        #
# chmod +x ubuntu-debullshit.sh                                                          #
#                                                                                        #
# Execute o script:                                                                      #
#                                                                                        #
# ./ubuntu-debullshit.sh                                                                 #
#                                                                                        #
# ou                                                                                     #
#                                                                                        #
# mv -i ~/Downloads/ubuntu-debullshit.sh  /usr/local/bin/                                #
#                                                                                        #
#                                                                                        #
# Changelog: /usr/share/doc/ubuntu-debullshit/CHANGELOG.md                               #
#                                                                                        #
##########################################################################################



# Bug: Problema com o comando notify-send para enviar notificação do usuário Root para um 
# usuário comum. Cada distribuição tem um parâmetro diferente para chamar o notify-send 
# (testado no Void Linux, BigLinux, SystemRescue 11.00).



# Desativar extensões desnecessárias
# Desativar animações
# Desativar o tracker (índices de arquivos)
# Desabilitar o pré-carregamento de programas
# Desabilitar a verificação de atualizações automáticas
# Usar o modo de sessão "GNOME Classic"
# Usar o "LightDM" em vez do "GDM"
# Certifique-se de que você está usando os drivers gráficos mais recentes para o seu hardware
# 
# ...
# 



# Desbostificando o Ubuntu!
#
# https://www.youtube.com/watch?v=psOrRNt8jKw




# Remover o pacote e as configurações:

# apt purge -y pacote

# O purge vai garantir que todos os arquivos de configuração do pacote também sejam removidos.



# https://www.bosontreinamentos.com.br/shell-script/shell-scripting-criando-caixas-de-dialogo-tui-com-dialog/
# https://aurelio.net/shell/dialog/
# http://www.bosontreinamentos.com.br/shell-script/shell-scripting-criando-caixas-de-dialogo-tui-com-whiptail-no-linux-27/
# https://www.bosontreinamentos.com.br/shell-script/formatar-e-exibir-texto-com-o-comando-printf-no-terminal-e-em-scripts/
# https://www.bosontreinamentos.com.br/shell-script/ler-entrada-de-dados-com-comando-read-em-shell-scripting/
# https://www.bosontreinamentos.com.br/shell-script/curso-de-shell-scripting-retornando-valores-em-funcoes-e-status-de-saida/
# https://statplace.com.br/blog/internacionalizacao-i18n/
# https://pt.wikipedia.org/wiki/Internacionaliza%C3%A7%C3%A3o_(inform%C3%A1tica)
# https://poeditor.com/


# ----------------------------------------------------------------------------------------


# Declaração de variáveis:


version="1.0.1"


# time="date '+%d-%m-%Y %H:%M:%S'"

# time="date '+%d/%m/%Y %H:%M:%S'"


# Arquivo de log

log="/tmp/ubuntu-debullshit.log"



# Logotipo

ICON="/usr/share/icons/ubuntu-debullshit.png"


# Caminho do papel de parede

wallpaper="/usr/share/backgrounds/gnome/blobs-l.svg"


time="sleep 1"

# ----------------------------------------------------------------------------------------

# Sessão do DBus: Quando você executa o comando como root (sudo), a variável 
# DBUS_SESSION_BUS_ADDRESS geralmente não é configurada corretamente. O DBus é usado para 
# comunicação entre processos no ambiente gráfico, e ele é crítico para a exibição de 
# notificações.
# 
# 
# Permissões X11 (XAUTHORITY): Você está tentando definir a variável XAUTHORITY, mas a 
# forma como está configurada pode não ser suficiente ou válida no contexto do sudo. O 
# usuário root precisa de permissões adequadas para interagir com o servidor X11 do 
# usuário comum.



# Captura o nome do usuário comum

# Usando logname para obter o nome do usuário

# Se o script não está sendo executado com sudo, mas você ainda deseja capturar o nome do 
# usuário comum (o usuário que fez login na sessão), você pode usar o comando logname

# SUDO_USER=$(logname)


# export DISPLAY=:0
# export DISPLAY=:0.0


# ----------------------------------------------------------------------------------------



# Nome da fonte a ser verificada Ex: Ubuntu Mono

FONT_NAME="Monospace"



# Cores para formatação da saída dos comandos

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
NC='\e[0m' # sem cor


# ----------------------------------------------------------------------------------------





export TEXTDOMAINDIR="/usr/share/locale"

export TEXTDOMAIN="ubuntu-debullshit"




# Remove o arquivo de log

rm "$log"




clear


# ----------------------------------------------------------------------------------------


# Função para identificar a distribuição


# Ubuntu 10.04 não tem o arquivo /etc/os-release

identificar_distro() {


    # Verifica se pelo menos um dos arquivos (/etc/os-release ou /etc/lsb-release) existe.

    if [[ -f /etc/os-release || -f /etc/lsb-release ]]; then

        # Lê os arquivos /etc/os-release ou /etc/lsb-release

if [[ -f /etc/os-release ]]; then

    . /etc/os-release

    DISTRIB_ID="$ID"  # Se você preferir usar o valor de $ID de /etc/os-release

elif [[ -f /etc/lsb-release ]]; then

    . /etc/lsb-release

    DISTRIB_ID="$DISTRIB_ID"  # Use o valor de $DISTRIB_ID de /etc/lsb-release

else


    echo -e "${RED}\n$(gettext "None of the system files (/etc/os-release or /etc/lsb-release) were found.") \n ${NC}"

    exit 1

fi



# Após carregar o arquivo e definir a variável, podemos usar a estrutura case para 
# verificar o valor de $DISTRIB_ID.

        case "$DISTRIB_ID" in

            void)

                echo -e "${GREEN}\n$(gettext "Distribution"): Void Linux \n ${NC}"

                
# No Void Linux / SystemRescue 11.00

# sudo: usuário desconhecido DISPLAY=:0.0
# sudo: erro ao inicializar o plug-in de auditoria sudoers_audit


# notify_users="sudo -u $(who | awk '{print $1}' | head -n 1) DISPLAY=$DISPLAY "

# notify_users=$(sudo -u $(logname) DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY)

# Exemplo:

# sudo -u $(logname) DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY \
# notify-send -i "/usr/share/icons/gnome/32x32/status/security-medium.png" -t "$((DELAY * 1000))" "$(gettext 'Firewall for Total Privacy Protection')" "\n$(gettext 'Firewall configured for maximum privacy!')\n"


# Funciona no Void Linux (Parece que o problema esta relacionado a variavel $DBUS_SESSION_BUS_ADDRESS no BigLinux em modo live usando o Root)

notify_users="sudo -u $(logname) DISPLAY=$DISPLAY $DBUS_SESSION_BUS_ADDRESS"


# notify_users="sudo -u $(logname) DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS"

                
                ;;

            ubuntu|Ubuntu)

                echo -e "${GREEN}\n$(gettext "Distribution"): Ubuntu \n ${NC}"
                ;;

            Debian)

                echo -e "${GREEN}\n$(gettext "Distribution"): Debian \n ${NC}"
                ;;

            slackware)

                echo -e "${GREEN}\n$(gettext "Distribution"): Slackware \n ${NC}"

                ;;

            *)
                if [[ "$NAME" == *"BigLinux"* ]]; then


                    echo -e "${GREEN}\n$(gettext "Distribution"): BigLinux \n ${NC}"
 
 
# Problema no BigLinux

# A opção acima no BigLinux gera o erro:

# Erro ao chamar a linha de comandos “dbus-launch --autolaunch=26a6e81a4245d54d88fd143067c6b17d --binary-syntax --close-stderr”: Processo filho concluiu com código 1


# Funciona no BigLinux

notify_users="sudo -u $(who | grep '('$DISPLAY')' | awk '{print $1}' | head -n 1) DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $(who | grep '('$DISPLAY')' | awk '{print $1}' | head -n 1))/bus"

                    
                    
                elif [[ "$NAME" == *"SystemRescue"* ]]; then


                     echo -e "${GREEN}\n$(gettext "Distribution"): SystemRescue \n ${NC}"


# Funciona no SystemRescue 11.00

notify_users="sudo -u $(who | awk '{print $1}' | head -n 1) DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $(who | grep '('$DISPLAY')' | awk '{print $1}' | head -n 1))/bus"

                    
                    
                    
                else

                    echo -e "${RED}\n$(gettext "Distribution unknown or not listed.") \n ${NC}"
                 
                    exit
                    
                fi

                ;;

        esac
        
        
    else
    
        echo -e "${RED}\n$(gettext "Unable to identify distribution.") \n ${NC}"
        
        exit
        
    fi
}



# sudo: usuário desconhecido DISPLAY=:0.0:

#     Isso indica que o comando sudo não consegue encontrar o usuário associado ao display gráfico. O DISPLAY=:0.0 é uma variável de ambiente usada em sistemas gráficos Linux (geralmente relacionados a ambientes X11 ou Wayland) para especificar a tela onde o gráfico deve ser exibido. Quando você tenta rodar um comando gráfico com sudo, ele pode não estar configurado corretamente para passar esse display.

# sudo: erro ao inicializar o plug-in de auditoria sudoers_audit:

#     Isso significa que há um problema relacionado ao plugin de auditoria no sudo, que é responsável por registrar os comandos executados com privilégios de superusuário. O erro pode ser causado por uma configuração incorreta ou um problema de permissões.


# ----------------------------------------------------------------------------------------

# Introdução ao Shell Script 

function intro(){



# Salva o texto em um arquivo temporário

# echo "$(gettext "Hardware where the optimization was performed:

# Processor: Celeron 847 1.1GHz (2 cores)
# RAM: 2GB DDR3
# SSD: 128GB

# Note: You don't need to do all the steps, choose the ones you think will help you with your needs.

# Slightly improved, but losing resources.

# The changes are intended to make the system more responsive, but may sacrifice some of the features that \nGNOME Shell brings by default. Use it if your machine really needs it, or if you don't really use the resources.

# The log file will be in $log at the end of the processes for checking errors or bugs.")"







message=$(gettext 'The log file will be in %s at the end of the processes for checking errors or bugs.')



echo -e "$(gettext "Hardware where the optimization was performed:")

" > /tmp/introducao.txt

echo "$(gettext "Processor: Celeron 847 1.1GHz (2 cores)")" >> /tmp/introducao.txt

echo "$(gettext "RAM: 2GB DDR3")" >> /tmp/introducao.txt

echo -e "$(gettext "SSD: 128GB")
" >> /tmp/introducao.txt

echo -e "$(gettext "Note: You don't need to do all the steps, choose the ones you think will help you with your needs.")
" >> /tmp/introducao.txt

echo -e "$(gettext "Slightly improved, but losing resources.")
" >> /tmp/introducao.txt

echo -e "$(gettext "The changes are intended to make the system more responsive, but may sacrifice some of the features that 
GNOME Shell brings by default. Use it if your machine really needs it, or if you don't really use the resources.")
" >> /tmp/introducao.txt

echo "$(printf "$message"  "$log")" >> /tmp/introducao.txt


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



# Verifica se o dialog está instalado

if  command -v dialog &> /dev/null; then



dialog                                    \
   --title "$(gettext 'Notice')"          \
   --backtitle 'ubuntu-debullshit'        \
   --msgbox "$(cat /tmp/introducao.txt)"  \
   30 120

    clear


else


clear

        
cat /tmp/introducao.txt


fi





fi



rm -Rf /tmp/introducao.txt


}


# ----------------------------------------------------------------------------------------

    # Removendo pacotes desnecessários do sistema.


function cleanup() {


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

    $time


# No Ubuntu, tanto o apt quanto o apt-get são ferramentas usadas para gerenciar pacotes, 
# mas o apt é uma versão mais recente e consolidada, com comandos que visam ser mais 
# amigáveis ao usuário. Ambas as ferramentas estão disponíveis na maioria das versões do 
# Ubuntu, mas o apt foi projetado para ser uma interface de usuário mais simplificada e 
# moderna em comparação com o apt-get, que ainda é amplamente utilizado e muito eficaz.


# O -y faz com que o comando aceite automaticamente qualquer pergunta de confirmação 
# durante o processo.

# O --purge remove também arquivos de configuração associados aos pacotes removidos, além 
# de não manter pacotes antigos ou desnecessários.


# ----------------------------------------------------------------------------------------

# Função para verificar a presença de um comando

verificar_comando() {
    comando=$1
    if command -v "$comando" &> /dev/null; then

    #    echo "$comando está instalado."

    apt_1="$1"

    # else

    #    echo "$comando NÃO está instalado."

    fi
}

# Verificar presença dos comandos

verificar_comando "apt"
verificar_comando "apt-get"

# ----------------------------------------------------------------------------------------


    $apt_1 autoremove --purge  -y 2>> "$log"



# apt-get autoremove --purge -y 
# Lendo listas de pacotes... Pronto
# Construindo árvore de dependências       
# Lendo informação de estado... Pronto
# 0 pacotes atualizados, 0 pacotes novos instalados, 0 a serem removidos e 0 não atualizados.



# apt vs. apt-get:
# 
# apt é uma ferramenta mais recente e consolidada que foi projetada para fornecer uma 
# interface mais amigável e simplificada para o gerenciamento de pacotes. Ela combina 
# funcionalidades de vários comandos antigos, como apt-get e apt-cache, em um único comando.
# 
# apt-get é uma ferramenta mais antiga, que ainda é amplamente utilizada, especialmente 
# em scripts, mas sua interface é um pouco mais "bruta" em comparação com o apt.


}


# ----------------------------------------------------------------------------------------

function check_internet(){

echo "
$(gettext 'Testing if internet connection is active...')
"


# O site do Google, tem bem menos chance de estar fora do ar.


if ! ping -c 1 www.google.com.br -q &> /dev/null; then

              # Internet está PARADA !!!

              echo -e "${RED}$(gettext '[ERROR] - Your system does not have an internet connection. Check your cables and modem.') \n ${NC}"
 
              $notify_users  \
              notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext '[ERROR] - Your system does not have an internet connection. Check your cables and modem.') \n"
              
              # Big Linux: Erro ao chamar a linha de comandos “dbus-launch --autolaunch=f662f1a5f2682f2556553c8d67c319f5 --binary-syntax --close-stderr”: Processo filho concluiu com código 1
              
              $time

              exit 1
    
    else

             # Conexao ativa...
             
             echo -e "${GREEN}$(gettext '[VERIFIED] - Internet connection working normally.') ${NC}"

echo -e "\n------------------------------------------------------------------------"

            $time

fi


}


# ----------------------------------------------------------------------------------------

# Verifique se os programas estao instalados no sistema.


# Verifica a existência de cada comando listado e sai do script caso algum deles não seja 
# encontrado. O uso do loop elimina a necessidade de escrever o comando which repetidamente.


function check_programs(){



# apt install -y preload

# ----------------------------------------------------------------------------------------


# Requer: gettext, yad, dialog e notify-send


# O comando "yad"  é necessario quando o script precisa ser executado em um ambiente gráfico (por exemplo, GNOME, KDE, XFCE, Mate, OpenBox, Fluxbox, i3WM...).

# which yad                 1> /dev/null 2> /dev/null || { echo "Programa Yad não esta instalado."           ; exit ; }


# O comando "dialog"  é necessario quando o script precisa ser executado somente em "modo texto"

# which dialog              1> /dev/null 2> /dev/null || { echo "Programa dialog não esta instalado."        ; exit ; }


# O comando "notify-send"  é necessario quando o script precisa ser executado em um ambiente gráfico (por exemplo, GNOME, KDE, XFCE, Mate, OpenBox, Fluxbox, i3WM...).

# which notify-send         1> /dev/null 2> /dev/null || { echo "Programa notify-send não esta instalado."   ; exit ; }


which gettext             1> /dev/null 2> /dev/null || { echo "Programa gettext não esta instalado."       ; exit ; }


# ----------------------------------------------------------------------------------------


for cmd in snap apt dpkg systemctl ; do


    command -v $cmd 1> /dev/null 2> /dev/null


    if [ $? -ne 0 ]; then

        message=$(gettext 'Command %s not found.')

        echo -e "${RED}\n$(printf "$message" "$cmd") \n ${NC}"
        

        $notify_users  \
        notify-send -i "/usr/share/icons/gnome/32x32/status/software-update-urgent.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "\n$(printf "$message"  "$cmd") \n"

        $time

        continue

#       exit

    fi


done


# ----------------------------------------------------------------------------------------



for cmd in  sysctl pgrep rm fc-list gsettings gpg sed sudo curl dd tee wget reboot break flatpak dbus-launch dconf ; do


    # O comando which pode falhar em alguns sistemas ou não estar presente por padrão.

    # which $cmd 1> /dev/null 2> /dev/null


    command -v $cmd 1> /dev/null 2> /dev/null


    if [ $? -ne 0 ]; then

        message=$(gettext 'Command %s not found.


# apt install -y %s')

        echo -e "${RED}\n$(printf "$message" "$cmd" "$cmd") \n ${NC}"
  

        $notify_users  \
        notify-send -i "/usr/share/icons/gnome/32x32/status/software-update-urgent.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "\n$(printf "$message" "$cmd" "$cmd") \n"


        $time

        exit

    fi


done


# ----------------------------------------------------------------------------------------



# Tema de icone do gnome usado no script


# No Ubuntu, o nome do tema de ícones padrão usado no GNOME é "Yaru".

# O tema Yaru foi introduzido no Ubuntu 18.10 e se tornou o tema padrão de ícones e tema de 
# interface para o ambiente GNOME no Ubuntu. Ele tem um visual moderno e é mantido pela 
# comunidade do Ubuntu.


# Onde encontrar:

# Os arquivos de ícones do tema Yaru estão geralmente localizados em /usr/share/icons/Yaru/.

# Se você quiser ver ou alterar o tema de ícones no GNOME, pode acessar as configurações do 
# GNOME, na seção Aparência, ou usar ferramentas como gnome-tweaks (Ajustes GNOME), onde 
# você pode modificar o tema de ícones, o tema GTK, entre outros.



# Verifica se o diretório /usr/share/icons/gnome/ não existe.

# Podemos usar o comando test ou a sintaxe -d para verificar.

# O -d é utilizado para verificar se um diretório existe, e o ! inverte a verificação 
# (verifica se o diretório não existe).




if [ ! -d "/usr/share/icons/gnome/" ]; then

    # Exibe a mensagem informando que o diretório não foi encontrado.

    echo -e "${RED}$(gettext 'The folder /usr/share/icons/gnome/ does not exist.') \n ${NC}"

    $time
    
    # Enviar notificação
    
    $notify_users  \
    notify-send -i "" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'The folder /usr/share/icons/gnome/ does not exist.') \n"


 

    
# A pasta /usr/share/icons/gnome/ é criada pelo pacote gnome-icon-theme. Este pacote contém 
# o conjunto de ícones padrão do GNOME, incluindo os ícones que são usados em várias partes 
# do ambiente de desktop GNOME.

# Se você não tiver esse pacote instalado, pode instalá-lo utilizando o seguinte comando no terminal:

# sudo apt install -y gnome-icon-theme

# Este comando instalará o pacote que cria a pasta /usr/share/icons/gnome/ e seus respectivos ícones.


# Para verificar se tem o pacote gnome-icon-theme instalado no Ubuntu e caso falso instala.


# Verificar se o pacote gnome-icon-theme está instalado

# if dpkg -l | grep -q gnome-icon-theme; then

#     echo "O pacote gnome-icon-theme já está instalado."
    
# else

  #  echo "O pacote gnome-icon-theme não está instalado. Instalando agora..."
    
  #  apt update
    
  #  apt install -y gnome-icon-theme
    
  #  echo "Pacote gnome-icon-theme instalado com sucesso."

 #   $time

  #  $notify_users  \
  #  notify-send -i "" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'Pacote gnome-icon-theme instalado com sucesso.') \n"
    
# fi



    # exit 1  # Saída com código de erro 1

fi



}


# /usr/local/bin/ubuntu-debullshit.sh: line 108: gettext: command not found
# /usr/local/bin/ubuntu-debullshit.sh: line 108: gettext: command not found


# apt update

# apt install -y gettext

# apt install -y flatpak

# apt install -y snap



# ----------------------------------------------------------------------------------------


# Verifica se a distribuição Linux é o Ubuntu

function check_distro(){

# Para verificar se a distribuição Linux é o Ubuntu, vamos consultar o conteúdo do arquivo 
# /etc/os-release ou podemos usar o comando lsb_release. Ambas as abordagens são confiáveis 
# para obter informações sobre a distribuição Linux.


# Verifica se o arquivo /etc/os-release existe

if [ -e /etc/os-release ]; then


if ! grep -i "ubuntu" /etc/os-release > /dev/null 2> /dev/null ; then



# Verifica se o yad está instalado

if command -v yad &> /dev/null
then


  yad --center --window-icon="$ICON" --image=dialog-error  --title="$(gettext 'ubuntu-debullshit!')" --text="$(gettext 'Your Linux distribution is NOT Ubuntu.')" --buttons-layout=center --button="$(gettext 'OK')":0 --width="650"


# Verifica se o dialog está instalado

elif command -v dialog &> /dev/null; then



# dialog --backtitle 'ubuntu-debullshit' --msgbox "\n$(gettext 'Your Linux distribution is NOT Ubuntu.')\n" 8 50

dialog --backtitle 'ubuntu-debullshit' --title "$(gettext 'Error')" --infobox "\n$(gettext 'Your Linux distribution is NOT Ubuntu.')\n" 8 50; sleep 5


clear



else


clear

  echo -e "${RED}\n$(gettext 'Your Linux distribution is NOT Ubuntu.') \n ${NC}"


fi




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


    message=$(gettext 'Your Linux distribution is: %s')

    echo -e "${GREEN}$(printf "$message" "$distro") ${NC}"

else


# Verifica se o yad está instalado

if command -v yad &> /dev/null
then


  yad --center --window-icon="$ICON" --image=dialog-error  --title="$(gettext 'ubuntu-debullshit!')" --text="$(gettext 'Your Linux distribution is NOT Ubuntu.')" --buttons-layout=center --button="$(gettext 'OK')":0 --width="650"


# Verifica se o dialog está instalado

elif command -v dialog &> /dev/null; then



dialog --backtitle 'ubuntu-debullshit' --msgbox "\n$(gettext 'Your Linux distribution is NOT Ubuntu.')\n" 8 50


clear



else


clear


    message=$(gettext 'Your Linux distribution is NOT Ubuntu.

Detected: %s')

  echo -e "${RED}\n$(printf "$message" "$distro") \n ${NC}"


fi




  exit

fi




fi


}


# ----------------------------------------------------------------------------------------

# Remove muitos pacotes deb pré-instalados


function remove_ubuntu_default_apps() {


# Martin Erik Rieland Bindslev Bisgaard  <https://github.com/SirBisgaard>


    echo -e "${GREEN}\n$(gettext 'Removing Ubuntu default apps') \n ${NC}"

    apt remove -y \
gnome-clocks gnome-calculator gnome-characters gnome-font-viewer gnome-keyring gnome-keyring-pkcs11 gnome-logs gnome-text-editor gnome-power-manager eog baobab evince evolution* empathy empathy-common software-center


# apt-get remove --purge -y pacote


    # Remova os resíduos.

    cleanup


}



# ----------------------------------------------------------------------------------------


function disable_ubuntu_report() {


    rm -Rf ~/.cache/ubuntu-report/         2>> "$log"

    ubuntu-report send no                  2>> "$log"


    echo -e "\n$(gettext 'Uninstalling package...')\n"

    $time

    apt purge -y ubuntu-report    2>> "$log"


    # Remova os resíduos.

    cleanup

}


# ----------------------------------------------------------------------------------------


function remove_appcrash_popup() {

# Desativar a coleta de dados do apport


# O Apport é uma ferramenta usada para coletar relatórios de falhas e erros no Ubuntu. Você pode desativá-la, caso não queira que ela envie relatórios de falhas.


# Consome muito do hardware verificando os erros e gerando o report.


# Para desativar o Apport, execute o seguinte comando:

echo -e "\n$(gettext 'Stopping service...')\n"

$time

systemctl stop apport     2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

$time

systemctl disable apport  2>> "$log"


# Além disso, você pode editar o arquivo de configuração do Apport para desativá-lo permanentemente:

# sudo nano /etc/default/apport

# E altere a linha:

# enabled=1

# Para:

# enabled=0

# Depois, salve e feche o arquivo.


echo -e "\n$(gettext 'Uninstalling package...')\n"

$time

apt purge -y  apport* apport-gtk apport-symptoms 2>> "$log"


# Remova os resíduos.

cleanup


# https://launchpad.net/ubuntu/+source/apport-symptoms


}


# ----------------------------------------------------------------------------------------

function remove_snaps() {


# Verifica se o comando snap está disponível

if command -v snap &> /dev/null
then

    # Se o Snap estiver instalado, ele exibirá a versão do Snap.

    echo "$(gettext 'Snap is installed. Version:')" >> "$log"

    echo -e "${GREEN}\n$(gettext 'Snap is installed. Version:') \n ${NC}"

    snap --version | tee -a "$log"

    $time

# O comando tee lê a entrada do fluxo e a grava tanto na saída padrão (geralmente o terminal) 
# quanto em um arquivo especificado. A opção -a faz com que o tee anexe a saída ao arquivo, 
# em vez de sobrescrevê-lo.



# O comando snap list é utilizado no terminal de sistemas Linux que utilizam o sistema de 
# pacotes Snap. Quando você executa esse comando, ele exibe uma lista de todos os pacotes 
# Snap instalados no sistema.
#
# A saída mostrará informações como o nome do pacote, a versão instalada, o canal de 
# distribuição (por exemplo, stable, candidate, edge) e o desenvolvedor do pacote. É útil 
# para gerenciar e verificar os pacotes Snap no seu sistema.

    echo -e "\nsnap list | wc -l ...\n"

    while [ "$(snap list | wc -l)" -gt 0 ]; do

        for snap in $(snap list | tail -n +2 | cut -d ' ' -f 1); do

            echo -e "\n$(gettext 'Uninstalling package...')\n"

            $time

            snap remove --purge "$snap" 2>> "$log"

        done

    done


# snap list
# error: cannot list snaps: cannot communicate with server: Get "http://localhost/v2/snaps": dial unix /run/snapd.socket: connect: no such file or directory



    echo -e "\n$(gettext 'Stopping service...')\n"

    $time

    systemctl stop snapd          2>> "$log"


    echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

    $time

    systemctl disable snapd       2>> "$log"


    systemctl mask snapd          2>> "$log"


    echo -e "\n$(gettext 'Uninstalling package...')\n"

    $time

    apt purge -y snapd*  2>> "$log"


    apt remove --purge -y gnome-software-plugin-snap  2>> "$log"



   # Remova os resíduos.

   cleanup


    rm -rf /snap /var/lib/snapd  2>> "$log"


    rm -rf /var/cache/snapd      2>> "$log"



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

           $time

           # Se o diretório snap existir, ele será removido com o comando rm -rf, e qualquer erro gerado será redirecionado para o arquivo de log.

           rm -rf "$userpath/snap"     2>> "$log"

        fi


    done

    
# Verificar se a pasta /etc/apt/preferences.d existe

if [ -d /etc/apt/preferences.d/ ]; then

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


fi



else


# Se o comando snap não estiver instalado, você verá uma mensagem de erro indicando que o 
# comando não foi encontrado, algo como:

# bash: snap: command not found


  echo -e "${RED}\n$(gettext 'Snap is not installed on your system.

To install Snap, use the command: # apt install -y snapd') \n\n${NC}"

  $time


fi



}

# ----------------------------------------------------------------------------------------

function disable_terminal_ads() {


# sed: can't read /etc/default/motd-news: No such file or directory

# sed: não é possível ler /etc/default/motd-news: arquivo ou diretório inexistente


# Verifica se o arquivo /etc/default/motd-news existe

if [ -e /etc/default/motd-news ]; then

    echo "$(gettext 'The file /etc/default/motd-news exists.')"

    $time

    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news   2>> "$log"

    pro config set apt_news=false  2>> "$log"

else

    echo "$(gettext 'The file /etc/default/motd-news does not exist.')"

    $time

fi


}

# ----------------------------------------------------------------------------------------

# Para atualizar o sistema

function update_system() {

    check_internet

    apt update 2>> "$log" && apt upgrade -y   2>> "$log"

    $time

}

# ----------------------------------------------------------------------------------------

# Instalando flatpak e flathub

function setup_flathub() {

    check_internet

# Para verificar se um site está fora do ar

# URL do site que deseja verificar

URL="https://flathub.org"


# Verificar se o site está acessível

http_response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")


# Se o código de resposta HTTP for diferente de 200, o site está fora do ar

if [ "$http_response" -ne 200 ]; then

    message=$(gettext 'The website %s is down. Response code: %s')

    echo "$(printf "$message" "$URL" "$http_response")"

    $time

else

  message=$(gettext 'The website %s is online.')

  echo "$(printf "$message" "$URL")"

  $time

  apt install -y flatpak  2>> "$log"

  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo  2>> "$log"


fi


# No Ubuntu, os pacotes gnome-software e gnome-software-plugin-flatpak estão relacionados 
# ao GNOME Software, que é a ferramenta gráfica de gerenciamento de software utilizada no 
# ambiente de desktop GNOME. Cada um desses pacotes tem uma função específica:
# 
#     gnome-software:
# 
#         Este pacote é o principal para o GNOME Software, que fornece uma interface 
# gráfica para instalar, atualizar e gerenciar aplicativos no Ubuntu. Ele oferece uma 
# maneira simples de procurar e instalar programas, além de permitir a gestão de atualizações 
# do sistema e software. Funciona como uma loja de aplicativos no ambiente GNOME, similar 
# a outras lojas de aplicativos em diferentes sistemas operacionais.
#         Ele permite a instalação de programas a partir de repositórios do Ubuntu, pacotes 
# Snap, Flatpak, entre outros.
# 
#     gnome-software-plugin-flatpak:
# 
#         Este pacote é um plugin adicional para o GNOME Software, permitindo que ele 
# suporte e gerencie pacotes Flatpak. Flatpak é uma tecnologia de empacotamento de software 
# que permite a distribuição de aplicativos de forma independente da distribuição Linux, 
# o que facilita o uso de aplicativos em diferentes distros.
# 
#         Com o gnome-software-plugin-flatpak instalado, o GNOME Software pode exibir, 
# instalar e atualizar aplicativos distribuídos como Flatpaks, diretamente pela interface 
# gráfica.
# 
# Resumindo: gnome-software é a ferramenta principal de gerenciamento de aplicativos no 
# GNOME, e gnome-software-plugin-flatpak adiciona suporte para instalação e gerenciamento 
# de pacotes Flatpak através dessa ferramenta.


    apt install --no-install-recommends -y gnome-software  gnome-software-plugin-flatpak 2>> "$log"


}




    




# ----------------------------------------------------------------------------------------

function gsettings_wrapper() {

    check_internet

    if ! command -v dbus-launch; then

        apt install -y dbus-x11  2>> "$log"
    fi

    sudo -Hu $(logname) dbus-launch gsettings "$@"  2>> "$log"

}


# ----------------------------------------------------------------------------------------


function gnome_extensions_wrapper() {

    check_internet

    if ! command -v dbus-launch; then

        apt install -y dbus-x11 2>> "$log"

    fi

    sudo -Hu $(logname) dbus-launch gnome-extensions "$@"  2>> "$log"

}


# ----------------------------------------------------------------------------------------


function set_fonts() {


# Para verificar se a fonte $FONT_NAME está instalada no sistema


# Verificar se a fonte está instalada

if fc-list | grep -i "$FONT_NAME"; then

  message=$(gettext 'The font %s is installed.')

  echo -e "${GREEN}\n$(printf "$message" "$FONT_NAME") \n ${NC}"

  $time


# O comando configura a fonte padrão de texto monospace (fonte de largura fixa, como a usada em terminais e editores de texto) para $FONT_NAME com o tamanho 10.


    # No Ubuntu, o gsettings_wrapper não é um comando padrão.

	gsettings_wrapper set org.gnome.desktop.interface monospace-font-name "$FONT_NAME 10"  2>> "$log"


    # gsettings set org.gnome.desktop.interface monospace-font-name "$FONT_NAME 10"


else

  message=$(gettext 'The font %s is not installed.')

  echo -e "${RED}\n$(printf "$message" "$FONT_NAME") \n${NC}"

  $time

fi




}

# ----------------------------------------------------------------------------------------


function setup_vanilla_gnome() {

    check_internet

    apt install -y qgnomeplatform-qt5  2>> "$log"


# Ajustes com o GNOME Tweaks


 # Ubuntu 24.04 - vanilla-gnome-desktop will give "pipewire-alsa : Conflicts: pulseaudio" 


# Por que o conflito acontece
# 
#  PipeWire e PulseAudio são ambos sistemas de servidor de áudio, mas o PipeWire foi 
# projetado para substituir o PulseAudio em muitos cenários. Quando o pacote pipewire-alsa 
# é instalado, ele fornece a interface ALSA (Advanced Linux Sound Architecture) para o 
# PipeWire, que tem como objetivo substituir o servidor de áudio PulseAudio.
# 
#  Pulseaudio é o servidor de áudio mais antigo e amplamente utilizado em muitas 
# distribuições Linux, incluindo o Ubuntu. Porém, o PipeWire tem como objetivo gerenciar o 
# áudio de maneira mais moderna, especialmente com suporte aprimorado para recursos de 
# áudio modernos, como Bluetooth e áudio de alta definição.
# 
# O Conflito:
# 
# Quando você tenta instalar ou configurar o pacote vanilla-gnome-desktop, o pacote 
# pipewire-alsa entra em conflito com pulseaudio, ou seja, ambos não podem ser instalados 
# simultaneamente. No Ubuntu 24.04, com o GNOME, o sistema pode estar configurado para usar 
# PulseAudio por padrão, a menos que você o configure para usar PipeWire explicitamente.
# 
# 
# Como resolver o conflito
# 
#     Se você deseja usar o PipeWire (recomendado para setups mais novos):
# 
#         Remova o PulseAudio e instale o PipeWire para resolver o conflito.
#         Você pode fazer isso rodando os seguintes comandos:
# 
# sudo apt remove -y pulseaudio
# 
# sudo apt install -y pipewire pipewire-alsa pipewire-pulse
# 
# Isso vai remover o PulseAudio e instalar o PipeWire, configurando o PipeWire para assumir 
# as funções do PulseAudio (pipewire-pulse).
# 
# 
# 
# Se você preferir continuar com o PulseAudio (para setups mais antigos ou por questões de compatibilidade):
# 
#     Basta não instalar o pipewire-alsa. Se ele já estiver instalado, você pode removê-lo com o comando:
# 
# sudo apt remove -y pipewire-alsa
# 
# Isso vai manter o PulseAudio em uso e evitar qualquer conflito.
# 
# 
# Para garantir que o PipeWire esteja gerenciando corretamente o áudio após a mudança:
# 
#     Depois de instalar o PipeWire, você pode querer reiniciar o sistema ou reiniciar os serviços de áudio:
# 
# systemctl --user restart pipewire
# systemctl --user restart pipewire-pulse
# 
# 
# Verifique se tudo está funcionando corretamente:
# 
#     Você pode verificar se o PipeWire está gerenciando o áudio corretamente utilizando o 
# pavucontrol (PulseAudio Volume Control) ou pw-top (para PipeWire). Se tudo estiver 
# configurado corretamente, você verá o PipeWire gerenciando os dispositivos e fluxos de 
# áudio.
# 
# 
# Conclusão:
# 
#     Se você deseja migrar para um setup com PipeWire, certifique-se de remover o PulseAudio 
# e instalar os pacotes relevantes do PipeWire, incluindo pipewire-alsa e pipewire-pulse, 
# para evitar o conflito.
# 
#     Se você prefere continuar com o PulseAudio, apenas evite instalar o pipewire-alsa, e 
# tudo continuará funcionando normalmente.
# 


#   apt install -y fonts-inter papirus-icon-theme gnome-sushi

    apt install -y gnome-session fonts-cantarell adwaita-icon-theme gnome-backgrounds gnome-tweaks vanilla-gnome-default-settings gnome-shell-extension-manager && apt remove purge -y ubuntu-session yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon yaru-theme-sound   2>> "$log"

  


# Remova os resíduos.

cleanup



    set_fonts            2>> "$log"

    restore_background   2>> "$log"

}


# ----------------------------------------------------------------------------------------


# Essa função configura várias preferências e extensões do ambiente de trabalho GNOME.
# 
# 
# Resumo
# 
# A função configura o GNOME com um tema escuro, usa o tema de ícones Papirus, ajusta a 
# fonte e o plano de fundo da área de trabalho, e habilita/desativa várias extensões para 
# personalizar a interface e a experiência de uso.


function setup_desktop() { 


# Temas e Aparência:
# 
# gtk-theme:    Define o tema GTK (interface gráfica) para adw-gtk3-dark, que é um 
# tema escuro.
# 
# color-scheme: Define o esquema de cores preferido como prefer-dark, o que faz o GNOME 
# usar um tema escuro por padrão.
# 
# icon-theme:   Define o tema de ícones para Papirus, um conjunto de ícones populares 
# para ambientes GNOME.


    gsettings_wrapper set org.gnome.desktop.interface gtk-theme    adw-gtk3-dark
    gsettings_wrapper set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings_wrapper set org.gnome.desktop.interface icon-theme   Papirus



# Fonte e Plano de Fundo:
# 
# font-name: Altera a fonte padrão para 'Inter Variable' com tamanho 11.
# 
# picture-uri: Define o fundo da área de trabalho para um arquivo específico de imagem (no caso, blobs-l.svg).
# 
# picture-uri-dark: Define a mesma imagem de fundo para o modo escuro.

    gsettings_wrapper set org.gnome.desktop.interface  font-name        'Inter Variable 11'
    gsettings_wrapper set org.gnome.desktop.background picture-uri      'file:///usr/share/backgrounds/gnome/blobs-l.svg'
    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/gnome/blobs-l.svg'



# Extensões GNOME:
# 
# ding@rastersoft.com: Habilita a extensão ding, que provavelmente adiciona algum recurso ou funcionalidade extra ao GNOME.
# 
# ubuntu-appindicators@ubuntu.com: Desativa a extensão relacionada aos indicadores de aplicativos do Ubuntu.
# 
# ubuntu-dock@ubuntu.com: Desativa a extensão que fornece o dock (barra de ícones) do Ubuntu.
# 
# tiling-assistant@ubuntu.com: Desativa a extensão que facilita o gerenciamento de janelas em mosaico no Ubuntu.

    gnome_extensions_wrapper enable  ding@rastersoft.com
    gnome_extensions_wrapper disable ubuntu-appindicators@ubuntu.com 
    gnome_extensions_wrapper disable ubuntu-dock@ubuntu.com
    gnome_extensions_wrapper disable tiling-assistant@ubuntu.com

}


# ----------------------------------------------------------------------------------------


function restore_background() {



# Verificar se o arquivo existe

if [ -f "$wallpaper" ]; then

  message=$(gettext 'The file %s exists.')

  echo -e "${GREEN}$(printf "$message" "$wallpaper")  ${NC}"

  $time

# Verificar se o usuário está utilizando o GNOME como ambiente de desktop


# Verificar o ambiente de desktop atual


# A variável de ambiente XDG_CURRENT_DESKTOP não funciona em gerenciadores de janelas

if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" || "$DESKTOP_SESSION" == "GNOME" ]]; then

  echo "$(gettext 'The user is using GNOME.')"

  $time

    # Este comando altera a imagem de fundo da área de trabalho no GNOME para a imagem localizada no caminho $FILE.


    gsettings_wrapper set org.gnome.desktop.background picture-uri      'file://'$wallpaper''  2>> "$log"

    gsettings_wrapper set org.gnome.desktop.background picture-uri-dark 'file://'$wallpaper''  2>> "$log"



    # gsettings set org.gnome.desktop.background picture-uri       'file://'$wallpaper''

    # gsettings set org.gnome.desktop.background picture-uri-dark  'file://'$wallpaper''


else

  echo "$(gettext 'The user is NOT using GNOME.')"

  $time

fi






else


    message=$(gettext 'The file %s does not exist.')

    echo -e "${RED}\n$(printf "$message" "$wallpaper") ${NC}"

    $time


# Nome do pacote

PACKAGE="gnome-backgrounds"


# Verifica se o pacote está instalado

dpkg -l | grep -q "^ii  $PACKAGE"

if [ $? -eq 0 ]; then

    message=$(gettext 'Package %s is already installed.')

    echo -e "${GREEN}$(printf "$message" "$PACKAGE")  ${NC}"

    $time

else

    check_internet


    message=$(gettext 'Package %s is not installed. Installing...')

    echo -e "${RED}\n$(printf "$message" "$PACKAGE") ${NC}"


    echo -e "${GREEN}$(gettext 'Updating package list...')  ${NC}"

    $time

    apt update

    apt install -y $PACKAGE

    if [ $? -eq 0 ]; then


    message=$(gettext 'Package %s installed successfully.')

    echo -e "${GREEN}$(printf "$message" "$PACKAGE")  ${NC}"

    $time

    else

    message=$(gettext 'Failed to install package %s.')

    echo -e "${RED}\n$(printf "$message" "$PACKAGE") ${NC}"

    $time


    fi

fi




fi




}

# ----------------------------------------------------------------------------------------


# Adicionando o repositório julianfairfax


function setup_julianfairfax_repo() {

    check_internet

    command -v curl || apt install -y curl 2>> "$log"


    # Verificar se a pasta /etc/apt/sources.list.d/ existe

    if [ ! -d "/etc/apt/sources.list.d/" ]; then

        echo -e "\n$(gettext 'The folder /etc/apt/sources.list.d/ does not exist.')\n"

        $time

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

    $time

else

    message=$(gettext 'The website %s is online.')

    echo -e "\n$(printf "$message" "$URL")\n"

    $time

    curl -s https://julianfairfax.gitlab.io/package-repo/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/julians-package-repo.gpg   2>> "$log"

    echo 'deb [ signed-by=/usr/share/keyrings/julians-package-repo.gpg ] https://julianfairfax.gitlab.io/package-repo/debs packages main' | sudo tee /etc/apt/sources.list.d/julians-package-repo.list


    echo -e "${GREEN}$(gettext 'Updating package list...')  ${NC}"

    $time

    apt update 2>> "$log"

fi



}


# ----------------------------------------------------------------------------------------


# Instalar adw-gtk3

function install_adwgtk3() {  
  
    check_internet


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



function install_icons() {

    check_internet


# Para verificar se um site está fora do ar

# URL do site que deseja verificar

URL="https://deb.debian.org"


# Verificar se o site está acessível

http_response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$URL")


# Se o código de resposta HTTP for diferente de 200, o site está fora do ar

if [ "$http_response" -ne 200 ]; then


    message=$(gettext 'The website %s is down. Response code: %s')

    echo -e "\n$(printf "$message" "$URL" "$http_response")\n"

    $time

else

    message=$(gettext 'The website %s is online.')

    echo -e "\n$(printf "$message" "$URL")\n"

    $time


# URL base do repositório Debian

base_url="https://deb.debian.org/debian/pool/main/a/adwaita-icon-theme/"


# Use wget para listar os arquivos na URL e depois grep para pegar o nome do arquivo .deb mais recente

file_name=$(wget -q -O - "$base_url" | grep -o 'adwaita-icon-theme[^"]*all.deb' | sort -V | tail -n 1)


# URL completa do pacote

file_url="${base_url}${file_name}"


# Baixando o pacote

echo -e "\n$(gettext 'Downloading the package'): $file_url \n"

$time

# adwaita-icon-theme_48~beta-3_all.deb

wget -O /tmp/adwaita-icon-theme.deb -c "$file_url"  2>> "$log"



    apt install -y /tmp/adwaita-icon-theme.deb   2>> "$log"

fi



# ou 

# apt install -y adwaita-icon-theme



# Papirus, Papirus-Dark, and Papirus-Light
# 
# Source: https://github.com/PapirusDevelopmentTeam/papirus-icon-theme
# 
#    apt-get update
#
#    apt-get install -y papirus-icon-theme



    apt install -y morewaita  2>> "$log"

 
}


# ----------------------------------------------------------------------------------------



function restore_firefox() {

    check_internet

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

    $time


else


    message=$(gettext 'The website %s is online.')

    echo -e "\n$(printf "$message" "$URL")\n"

    $time

    apt remove purge -y firefox   2>> "$log"

    snap remove --purge firefox   2>> "$log"



# Verificar se a pasta /etc/apt/keyrings/ existe

# Crie um diretório para armazenar chaves do repositório APT, se ainda não existir

if [ ! -d "/etc/apt/keyrings/" ]; then


  echo -e "\n$(gettext 'The /etc/apt/keyrings/ folder does not exist.')\n"

  $time

  mkdir -p /etc/apt/keyrings/      2>> "$log"

  chmod -R 755 /etc/apt/keyrings/  2>> "$log"


fi


# Verificar se a pasta /etc/apt/sources.list.d/ existe

if [ ! -d "/etc/apt/sources.list.d/" ]; then

  echo -e "\n$(gettext 'The folder /etc/apt/sources.list.d/ does not exist.')\n"

  $time

  # Se a pasta não existir, o comando mkdir -p cria a pasta. O -p garante que, se a pasta pai não existir, ela também será criada.

  mkdir -p /etc/apt/sources.list.d/  2>> "$log"


fi


# Verificar se a pasta /etc/apt/preferences.d/ existe

if [ ! -d "/etc/apt/preferences.d/" ]; then

  echo -e "\n$(gettext 'The /etc/apt/preferences.d/ folder does not exist.')\n"

  $time

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


# Para reiniciar o sistema


function ask_reboot() {



# Verifica se o yad está instalado

if command -v yad &> /dev/null
then

# Exibe a caixa de diálogo de confirmação usando yad e captura o código do botão pressionado

choice=$(yad --center --window-icon="$ICON" --title="$(gettext 'Reboot')" --question --text="$(gettext 'Reboot now?')" --button="$(gettext 'Yes')":0 --button="$(gettext 'No')":1)


choice=$?


elif command -v dialog &> /dev/null; then


dialog --backtitle 'ubuntu-debullshit' --yesno  "$(gettext 'Reboot now?')" 8 50

choice=$?

clear



else


clear

read -p "$(gettext 'Reboot now?') [y/n]:" yn

choice=$(echo $yn | tr '[:upper:]' '[:lower:]') # convert input to lowercase

if [ "$choice" = "y" ];then

choice=0

else

choice=1

fi



fi

  


# Verifica o código retornado pelo yad

if [[ "$choice" == "0" ]]; then

    clear

    sudo reboot

    # sudo shutdown -r


elif [[ "$choice" == "1" ]]; then

    clear

    exit 2

fi




}

# ----------------------------------------------------------------------------------------

function msg() {

    tput setaf 2
    echo "[*] $1"
    tput sgr0

}

# ----------------------------------------------------------------------------------------

function error_msg() {

    tput setaf 1
    echo "[!] $1"
    tput sgr0

}

# ----------------------------------------------------------------------------------------


# Verifica se o usuário é o Root.


function check_root_user() {


    if [ "$(id -u)" != 0 ]; then



# Verifica se o yad está instalado

if command -v yad &> /dev/null
then

        yad --center --window-icon="$ICON" --image=dialog-error  --title="$(gettext 'ubuntu-debullshit!')" --text="$(gettext 'Please run the script as Root!\nWe need to do administrative tasks')" --buttons-layout=center --button="$(gettext 'OK')":0 --width="650"


# Verifica se o dialog está instalado

elif command -v dialog &> /dev/null; then



dialog --backtitle 'ubuntu-debullshit' --msgbox "\n$(gettext 'Please run the script as Root!\nWe need to do administrative tasks')\n" 8 50


clear



else


clear

        echo -e "\n$(gettext 'Please run the script as Root!\nWe need to do administrative tasks')\n"

        $time

fi

        # Fecha

        exit 3


    fi





}

# ----------------------------------------------------------------------------------------

function remove_telemetry(){


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

# $time

$notify_users  \
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

    $time

    systemctl stop pop-con     2>> "$log"


    echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

    $time

    systemctl disable pop-con  2>> "$log"


    echo -e "\n$(gettext 'Pop-con service stopped and disabled.')\n"

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-information.png" -t "$((DELAY * 1000))" "$(gettext 'pop-con')" "$(gettext 'Pop-con service stopped and disabled.')"

else

    echo -e "${GREEN}\n$(gettext 'Pop-con service is not running.') \n${NC}"

    # $time

fi




# Desativar a coleta de dados de telemetria no Ubuntu Snap

# O Snap (o sistema de pacotes universal do Ubuntu) coleta dados sobre o uso de pacotes 
# instalados. Você pode desativar esse comportamento no Snap da seguinte maneira:

snap set system telemetry=off 2>> "$log"

# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)


echo -e "${RED}\n$(gettext 'An error occurred while disabling telemetry collection for Snap packages.') \n${NC}"

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'An error occurred while disabling telemetry collection for Snap packages.')"


fi


# Explicação:

#     $?: Armazena o código de saída do último comando executado.
#     -ne 0: A opção -ne significa "não é igual" (not equal). Ou seja, a condição será verdadeira se o código de saída não for 0, o que indica erro.
#     notify-send: Exibe uma notificação para o usuário, com o ícone de erro e a mensagem.




# Desativar a coleta de dados do whoopsie

# O Whoopsie é um serviço do Ubuntu que envia dados sobre falhas para a Canonical. Para desativá-lo, execute:

echo -e "\n$(gettext 'Stopping service...')\n"

$time

systemctl stop whoopsie     2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

$time

systemctl disable whoopsie  2>> "$log"



# Você também pode remover o pacote whoopsie se preferir:

echo -e "\n$(gettext 'Uninstalling package...')\n"

$time

apt purge -y whoopsie 2>> "$log"


# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)

echo -e "${RED}\n$(gettext 'An error occurred while removing whoopsie.') ${NC}"

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'An error occurred while removing whoopsie.')"

fi


# Remover o canonical-livepatch

# O Canonical Livepatch é um serviço pago que aplica correções de segurança em tempo real 
# no Ubuntu. Ele coleta dados, embora de forma limitada. Para desativá-lo ou removê-lo:

# Para desativar:

echo -e "\n$(gettext 'Stopping service...')\n"

$time

systemctl stop canonical-livepatch 2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

$time

systemctl disable canonical-livepatch    2>> "$log"


# Para remover:

echo -e "\n$(gettext 'Uninstalling package...')\n"

$time

apt purge -y canonical-livepatch  2>> "$log"



# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)

echo -e "${RED}\n$(gettext 'An error occurred while removing canonical-livepatch.') \n${NC}"

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Error')" "$(gettext 'An error occurred while removing canonical-livepatch.')"

fi


# Desativar a coleta de dados de pesquisa da Dash:



# ----------------------------------------------------------------------------------------


# Irá mostrar se o pacote está ou não presente na versão específica do Ubuntu.


# O pacote unity-lens-shopping foi introduzido no Ubuntu 12.10 (Quantal Quetzal) e tinha 
# a função de integrar a busca de produtos da Amazon diretamente no Dash do Unity, o 
# ambiente gráfico padrão do Ubuntu na época. O que ele fazia basicamente era:
# 
#  Buscar produtos online: Quando você realizava uma busca no Dash (a interface de 
# pesquisa do Unity), o unity-lens-shopping enviava os termos de busca para a Amazon e 
# exibia resultados relacionados a produtos à venda, como livros, eletrônicos, roupas e 
# outros itens disponíveis no site da Amazon.
# 
# Exibição no Dash: Os resultados da Amazon eram apresentados junto com os resultados 
# locais, como aplicativos e arquivos do sistema. O Dash, portanto, não apenas retornava 
# resultados de arquivos locais e aplicativos, mas também produtos de e-commerce.
# 
# Integração direta com a Amazon: O pacote era integrado diretamente à Amazon, o que 
# significava que, ao procurar por algo no Dash, o usuário podia ver produtos disponíveis 
# para compra sem precisar acessar o site da Amazon.
# 
# 
# Razões para a remoção do pacote:
# 
#     Preocupações com privacidade: Muitas pessoas ficaram preocupadas com o fato de o 
# Ubuntu estar enviando dados de busca dos usuários para a Amazon, o que poderia ser 
# considerado uma violação de privacidade.
# 
#     Críticas dos usuários: Houve uma reação negativa por parte de muitos usuários, que 
# não queriam ver anúncios ou resultados de e-commerce diretamente na interface de busca 
# do sistema operacional.
# 
#     Descontinuação: Devido ao feedback negativo e preocupações com privacidade, a 
# Canonical (a empresa por trás do Ubuntu) decidiu remover essa funcionalidade nas versões 
# posteriores, começando com o Ubuntu 16.04 LTS.
# 
# Em versões mais recentes do Ubuntu, o Dash foi modificado para não incluir mais 
# resultados de compras online, e o pacote unity-lens-shopping foi removido dos 
# repositórios padrão.



# Verifica a versão do Ubuntu instalada

# Usa o comando lsb_release -r para obter a versão do Ubuntu instalada.

ubuntu_version=$(lsb_release -r | awk '{print $2}')


# Função para verificar a presença do pacote

check_package() {

    local version=$1

    # verifica se o pacote unity-lens-shopping está instalado

    if dpkg -l | grep -q "unity-lens-shopping"; then


        message=$(gettext 'The unity-lens-shopping package is installed on Ubuntu %s.')

        echo -e "\n$(printf "$message" "$version")\n"

        $time


        # Remoção do unity-lens-shopping

        apt-get remove -y unity-lens-shopping


    else


    message=$(gettext 'The unity-lens-shopping package is NOT installed on Ubuntu %s.')

    echo -e "\n$(printf "$message" "$version")\n"

    $time


    fi

}


# Verifica se a versão do Ubuntu é uma das versões que possui o pacote

# Se a versão do Ubuntu for entre 12.10 e 16.04, realiza a verificação; caso contrário, 
# ele informa que é para essas versões específicas.

if [[ "$ubuntu_version" == "12.10" ]] || [[ "$ubuntu_version" == "13.04" ]] || [[ "$ubuntu_version" == "13.10" ]] || \
   [[ "$ubuntu_version" == "14.04" ]] || [[ "$ubuntu_version" == "14.10" ]] || [[ "$ubuntu_version" == "15.04" ]] || \
   [[ "$ubuntu_version" == "15.10" ]] || [[ "$ubuntu_version" == "16.04" ]]; then

    check_package "$ubuntu_version"

else

    echo -e "$(gettext 'This part of the script is designed to check for the unity-lens-shopping package on Ubuntu versions 12.10 through 16.04.')"

    $time

fi


# ----------------------------------------------------------------------------------------


# Para verificar se o Unity (ambiente de desktop) está em execução


if pgrep -l unity > /dev/null
then

    # echo "A interface gráfica do Unity está em execução."




# Desative os escopos remotos nas versões do Ubuntu que usam o Unity
#
#
# Para desativar os escopos remotos nas versões do Ubuntu que utilizam o Unity. Verifica 
# a versão do Ubuntu, desabilita os escopos remotos e impede a coleta de dados relacionados 
# a lojas online, como Amazon, eBay e Ubuntu Shop, que eram frequentemente associados ao 
# Unity.
#
#
# O Unity foi o ambiente de desktop padrão do Ubuntu de 2010 a 2017. Abaixo estão as 
# versões do Ubuntu que usaram o Unity como desktop principal:
# 
# Versões do Ubuntu com Unity:
# 
#     Ubuntu 10.10 (Maverick Meerkat) — lançado em outubro de 2010
#         Primeira versão a introduzir o Unity como o ambiente de desktop padrão.
# 
#     Ubuntu 11.04 (Natty Narwhal) — lançado em abril de 2011
#         O Unity foi adotado como padrão no lugar do GNOME 2.
# 
#     Ubuntu 11.10 (Oneiric Ocelot) — lançado em outubro de 2011
#         Continuou com o Unity, aprimorando a experiência.
# 
#     Ubuntu 12.04 LTS (Precise Pangolin) — lançado em abril de 2012
#         Versão LTS (Long Term Support) que manteve o Unity como padrão.
# 
#     Ubuntu 12.10 (Quantal Quetzal) — lançado em outubro de 2012
#         Melhorias no Unity e integração com serviços de nuvem.
# 
#     Ubuntu 13.04 (Raring Ringtail) — lançado em abril de 2013
#         Melhorias no Unity, incluindo novos recursos de interface.
# 
#     Ubuntu 13.10 (Saucy Salamander) — lançado em outubro de 2013
#         Continuou o desenvolvimento do Unity com mais melhorias na interface.
# 
#     Ubuntu 14.04 LTS (Trusty Tahr) — lançado em abril de 2014
#         Outra versão LTS com Unity, com melhorias contínuas e mais estável.
# 
#     Ubuntu 14.10 (Utopic Unicorn) — lançado em outubro de 2014
#         Continuou com Unity, mas com foco em melhorias de estabilidade.
# 
#     Ubuntu 15.04 (Vivid Vervet) — lançado em abril de 2015
#         Última versão com Unity antes de o Ubuntu fazer mudanças para o GNOME.
# 
#     Ubuntu 15.10 (Wily Werewolf) — lançado em outubro de 2015
#         Continuou o uso do Unity, mas com foco em melhorias e atualizações do sistema.
# 
#     Ubuntu 16.04 LTS (Xenial Xerus) — lançado em abril de 2016
#         A última versão LTS com Unity, que foi amplamente usada por vários anos.
# 
#     Ubuntu 16.10 (Yakkety Yak) — lançado em outubro de 2016
#         Versão de transição para a mudança para o GNOME no Ubuntu.
# 
#     Ubuntu 17.04 (Zesty Zapus) — lançado em abril de 2017
#         Última versão do Ubuntu com Unity como o ambiente de desktop padrão.
#
#
# Transição para o GNOME:
#
# A partir do Ubuntu 17.10 (Artful Aardvark), o Ubuntu abandonou o Unity em favor do GNOME 
# como o ambiente de desktop padrão, após a Canonical (a empresa por trás do Ubuntu) 
# decidir que o Unity não era mais viável a longo prazo.


# Define o caminho do comando gsettings

GS="/usr/bin/gsettings"
CCUL="com.canonical.Unity.lenses"


# Obtém a versão do Ubuntu

V=`/usr/bin/lsb_release -rs`


# O Unity foi usado no Ubuntu de 10.10 até 17.04, então a faixa de versões para desativar 
# escopos remotos deve ser essas.


# Versões do Ubuntu com Unity que serão afetadas

MIN="10.10"
MAX="17.04"





# Verifica se a versão do Ubuntu está dentro do intervalo desejado

if [[ $(echo "$V >= $MIN" | bc -l) -eq 1 && $(echo "$V <= $MAX" | bc -l) -eq 1 ]]; then

    echo -e "$(gettext 'Ubuntu version within range to disable remote scopes.')"

    $time

    # Verifica se o esquema Canonical Unity está presente

    SCHEMA="`$GS list-schemas | grep -i $CCUL | head -1`"
    
    if [[ -z "$SCHEMA" ]]; then

        echo -e "$(gettext 'Error: Canonical Unity lenses schema not found.')"

        $time

        exit 1

    else

        CCUL="$SCHEMA"
    fi

    # Desabilita a pesquisa remota no Unity (impede que dados de pesquisa sejam enviados para a internet)

    echo -e "$(gettext 'Disabling Remote Content Search...')"

    $time

    $GS set $CCUL remote-content-search none


    # Desabilita escopos relacionados a lojas online (Amazon, Ebay, Ubuntu Shop, etc.)

    echo -e "$(gettext 'Disabling remote scopes from online store suggestions...')"

    $time

    $GS set $CCUL disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

    echo -e "$(gettext 'Remote scopes disabled successfully!')"

    $time

else

    echo -e "$(gettext 'This version of Ubuntu does not need modifications or is out of range for disabling remote scopes.')"

    $time

    # exit
fi




else

    echo -e "$(gettext 'Unity GUI is NOT running.')"

    $time

fi


# ----------------------------------------------------------------------------------------



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

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Notice')" "$(gettext 'An error occurred while disabling online search sources (eBay, Wikipedia, flickr, etc.)')"

fi


# Este comando desabilita especificamente a pesquisa online da Amazon na Dash, que é uma 
# das fontes de dados online mais comuns que o Ubuntu utiliza.

gsettings set org.gnome.desktop.search-providers disabled "['amazon.com']" 2>> "$log"


# Para verificar se o comando foi executado corretamente

if [ $? -ne 0 ]; then  # Verifica se o código de saída é diferente de 0 (erro)


echo -e "${RED}\n$(gettext 'An error occurred while disabling Amazon online search in Dash') \n${NC}"

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/network-error.png" -t "$((DELAY * 1000))" "$(gettext 'Notice')" "$(gettext 'An error occurred while disabling Amazon online search in Dash')"

fi


# Alternativa: Desabilitar a pesquisa online via configurações do sistema

# Se preferir, você também pode manualmente desmarcar a opção "Incluir resultados online nas buscas" nas configurações de privacidade do Ubuntu:

#    Vá em Configurações > Privacidade > Pesquisa Online.
#    Desmarque a opção "Incluir resultados online nas buscas".

# O método via script automatiza essa configuração, desativando a pesquisa online e evitando o envio de consultas para serviços como a Amazon.



# Desativação de sugestões online no GNOME

# Desativar as sugestões online:

gsettings set org.gnome.desktop.search-providers disable-remote true

# Isso vai desabilitar a pesquisa online do GNOME, impedindo que sugestões de fontes 
# externas sejam mostradas na pesquisa do sistema.



echo -e "${GREEN}\n$(gettext "Dash's search data collection has been disabled.") \n${NC}"

$time


# https://www.gnu.org/philosophy/ubuntu-spyware.pt-br.html


}


# ----------------------------------------------------------------------------------------


# Para remover PPA (Personal Package Archive) do seu sistema


# Os pacotes instalados via PPAs (Personal Package Archives) geralmente não possuem uma 
# indicação explícita de "PPA" diretamente na lista de pacotes. No entanto, a origem dos 
# pacotes pode ser identificada com base no repositório de onde eles foram instalados. 
# Quando um pacote é instalado de um PPA, ele pode aparecer no formato de origem no 
# comando apt list --installed ou na saída de dpkg -l.


function remover_PPA() {




# Verificar se a pasta /etc/apt/sources.list.d existe

if [ -d "/etc/apt/sources.list.d" ]; then

   # echo "A pasta /etc/apt/sources.list.d existe."



    check_internet



# Verifica se o dialog está instalado

if  command -v dialog &> /dev/null; then


# Explicação:

# --timeout 10: Isso fecha automaticamente a caixa de diálogo após 10 segundos. Você pode 
# alterar esse número conforme necessário.

# Agora, a caixa de diálogo será exibida e fechará automaticamente após o tempo 
# especificado, sem precisar de interação do usuário.



dialog \
--backtitle 'ubuntu-debullshit' \
--timeout 10 \
--msgbox "\n$(gettext "Revert packages installed via PPAs\n\n\nWarning\n\nIf you are a winuser who is addicted to Baixaki and installs all kinds of \nthird-party junk on your Linux, such as PPAs, .deb packages, \nruns scripts and compilations without knowing whether it is for food or \ndrink, don't even try to use this option. Your system will most likely break.")\n" 20 90


clear



else


# clear


echo "$(gettext "Revert packages installed via PPAs


Warning

If you are a winuser who is addicted to Baixaki and installs all kinds of 
third-party junk on your Linux, such as PPAs, .deb packages, 
runs scripts and compilations without knowing whether it is for food or 
drink, don't even try to use this option. Your system will most likely break.")" | tee -a "$log"


sleep 10


fi




echo -e "${GREEN}\n$(gettext 'Starting to clean up packages installed via PPAs...')  \n${NC}"

$time

# Passo 1: Remover todos os PPAs adicionados

echo -e "$(gettext 'Removing .list files from PPAs...')" | tee -a "$log"

$time

for ppa in /etc/apt/sources.list.d/*; do

    if [[ "$ppa" == *"ppa:"* ]]; then

        message=$(gettext 'Removing PPA: %s')

        echo -e "${GREEN}$(printf "$message" "$ppa")  ${NC}"

        $time

        rm -f "$ppa" 2>> "$log"
    fi

done



# Passo 2: Atualizar a lista de pacotes


echo -e "${GREEN}$(gettext 'Updating package list...')  ${NC}"

$time


apt update 2>> "$log"

$time


# Passo 3: Remover pacotes instalados via PPAs

echo -e "${GREEN}$(gettext 'Checking packages installed via PPAs...')  ${NC}"

$time


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

    $time


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

    $time


$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-error.png" -t "$((DELAY * 1000))" "$(gettext 'ubuntu-debullshit')" "\n$(gettext 'Removal of packages installed by PPAs has been completed.')\n"


else


    echo "$(gettext 'The folder /etc/apt/sources.list.d does not exist...')" >> "$log"


    echo -e "${RED}\n$(gettext 'The folder /etc/apt/sources.list.d does not exist...') \n${NC}"

    $time


fi



}


# https://linuxdicasesuporte.blogspot.com/2022/06/ubuntu-2204-extra-lite.html


# ----------------------------------------------------------------------------------------

function remove_gnome-online-accounts() {

echo -e "\n$(gettext 'Uninstall GNOME Online Accounts

Integration with online accounts (mounting Google Drive folders, email, calendar).

This will remove support for Online Accounts and also the service (daemon) that is running on the system.')\n\n\n"

sleep 10

apt purge -y gnome-online-accounts 2>> "$log"


# Remova os resíduos.

cleanup

}


# ----------------------------------------------------------------------------------------

function remove_software_stores() {


echo -e "\n$(gettext 'Removing software stores and updaters

Uninstall the Software Stores (only if you know how to use APT).

If you usually manage your software through the command line, uninstall the 
manager programs that also keep services (daemons) running all the time 
on the system (not recommended).


This action will remove the store(s), the repository manager, the 
update manager and the update notifier.')\n\n"

sleep 10

apt purge -y ubuntu-software gnome-software software-properties-gtk update-manager  2>> "$log"


# Remova os resíduos.

cleanup


}

# ----------------------------------------------------------------------------------------


function remove_location_service() {


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

$time

# Para desativar o serviço de localização no Ubuntu

# Desativar o serviço de localização (Geoclue2):

# O Ubuntu usa o geoclue2 para obter a localização, então o primeiro passo é parar e desabilitar esse serviço.


echo -e "\n$(gettext 'Stopping service...')\n"

$time

systemctl stop geoclue 2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

$time

# Desabilitar o serviço de localização para que ele não seja iniciado automaticamente:

# Após parar o serviço, para garantir que ele não inicie automaticamente na próxima vez que você reiniciar o computador, execute:

systemctl disable geoclue 2>> "$log"


echo -e "\n$(gettext 'Uninstalling package...')\n"

$time

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


function disable_file_history() {


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




echo -e "\n$(gettext 'Disable search

GNOME Shell searches for files, calendar events, programs in 
GNOME Software (or Ubuntu Software), in the terminal, in addition to the standard search for installed programs.


Disabling search will make the system much lighter, responding more quickly. 
Evaluate your needs and decide if it is worth it (ideal for very weak machines).


Disable File History

GNOME Shell stores the history of files used to place in recent items, in searches. If it is not important, disable it.')\n"


sleep 10



# Para desativar o Histórico de Arquivos no Ubuntu, é necessário focar no gnome-initial-setup e no próprio serviço de rastreamento de arquivos.

# Desabilitar o Histórico de Arquivos no GNOME (tracker3 e gnome-shell): No Ubuntu, o GNOME usa o tracker3 para indexar arquivos e criar o histórico de arquivos acessados.

echo -e "$(gettext 'Disabling file tracking service (tracker3)...')"

$time

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




echo -e "$(gettext 'Disable File History in GNOME')"

$time

# Se você também quiser desabilitar o histórico de arquivos do GNOME, que armazena informações sobre arquivos abertos recentemente:

# Desabilitar o histórico de arquivos no Nautilus: O Nautilus usa uma configuração específica para armazenar o histórico de arquivos acessados. Para desativá-lo, execute:

gsettings set org.gnome.nautilus.history enabled false 2>> "$log"

# Isso irá desabilitar o registro de arquivos acessados no Nautilus e também os itens recentes mostrados no menu "Recentes".


echo -e "$(gettext 'Clear recent file history')"

$time

# (Opcional) Apagar o histórico de arquivos armazenado:

# Para limpar os arquivos históricos que já foram gravados, você pode executar este comando:

rm -rf ~/.local/share/recently-used.xbel 2>> "$log"


# Este comando remove o arquivo que contém o histórico de arquivos recentemente acessados.

# Esses passos irão desabilitar o histórico de arquivos e impedir que o Ubuntu rastreie 
# ou armazene arquivos acessados no futuro.


# Após esses passos, o GNOME Shell não armazenará mais o histórico de arquivos acessados, 
# e as buscas e menus não exibirão mais itens recentes.


# O GNOME Shell armazena o histórico dos arquivos utilizados para exibir nos itens recentes 
# e para ajudar nas buscas feitas no sistema. Esse histórico é usado principalmente pelo 
# Nautilus (o gerenciador de arquivos do GNOME) e pelo próprio GNOME Shell, para melhorar 
# a experiência de uso.

# Esse histórico pode ser utilizado para mostrar arquivos recentemente acessados tanto no 
# menu "Atividades" (quando você faz uma busca rápida) quanto nos itens recentes no Nautilus, 
# entre outras partes do sistema.


echo -e "\n\n$(gettext "After performing these steps, you will have disabled search in Ubuntu, 
including file indexing, recent file history, and GNOME Shell search. This 
may improve performance, but it also means that you will no longer be 
able to use the system's quick search to find files or applications.")\n\n"

sleep 10



}

# ----------------------------------------------------------------------------------------


# Desative as animações [desligar os efeitos visuais da interface]


function disable_animations() {

echo -e "\n$(gettext 'Disable GNOME GUI animations')\n"

$time

# Para desativar as animações no Ubuntu, você pode alterar as configurações do GNOME para 
# desativar as animações da interface gráfica. Isso pode ser feito com o comando gsettings, 
# que permite modificar as configurações do GNOME diretamente.


# Para desabilitar as animações no GNOME:

gsettings set org.gnome.desktop.interface enable-animations false 2>> "$log"


# Verifica se houve erro durante a execução

if [ $? -eq 0 ]; then

    # Se o comando for bem-sucedido

    echo -e "${GREEN}$(gettext "Animations have been successfully disabled.") ${NC}"

    $time

else

    # Se houver algum erro

    message=$(gettext 'An error occurred while trying to disable animations. Check the log for more details.
    
    Error logged in: %s')

    echo -e "${RED}\n$(printf "$message" "$log") ${NC}"

    $time

fi


# Esse comando desativa as animações em toda a interface gráfica do GNOME, incluindo 
# animações de transições de janelas, menus, etc.

echo -e "\n$(gettext 'Disable animations when minimizing and restoring windows.')\n"

$time

# Embora o comando acima já desative as animações principais, se você quiser garantir 
# que as animações ao minimizar e restaurar janelas também sejam desativadas, pode usar:

gsettings set org.gnome.desktop.wm.preferences minimize-animations false 2>> "$log"

# Isso desativa as animações ao minimizar janelas.


# Verifica se houve erro durante a execução

if [ $? -eq 0 ]; then

    # Se o comando for bem-sucedido

    echo -e "${GREEN}$(gettext "Window minimize and restore animations have been successfully disabled.") ${NC}"

    $time

else

    # Se houver algum erro

message=$(gettext 'An error occurred while trying to disable window minimize and restore animations. Check the log for more details.

Error logged in: %s')

    echo -e "${RED}\n$(printf "$message" "$log") ${NC}"

    $time
    
$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-error.png" -t "$((DELAY * 1000))" "$(gettext 'ubuntu-debullshit')" "\n$(printf "$message" "$log")\n"


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


function disable_automatic_updates() {

echo -e "$(gettext '
If you remember to update your system from time to time, disable automatic updates.

Automatic updates will be disabled, including disabling the unattended-upgrades service and checking for new Ubuntu versions.
')"

$time

# Desativar atualizações automáticas no Ubuntu

echo -e "$(gettext 'Disabling automatic package and security updates...

Ubuntu manages automatic updates through unattended-upgrades, which is
responsible for automatically installing security and other important 
updates.')"

sleep 10

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

echo -e "\n$(gettext 'Disable the unattended-upgrades service:

In addition to disabling the configuration for automatic updates, we can ensure that the 
service that manages these automatic updates is not running.')\n"

sleep 10

# Parando o serviço unattended-upgrades...

echo -e "\n$(gettext 'Stopping service...')\n"

$time

systemctl stop unattended-upgrades     2>> "$log"


echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

$time

systemctl disable unattended-upgrades  2>> "$log"

# Isso desativa o serviço que gerencia as atualizações automáticas no Ubuntu, evitando 
# que ele seja executado após reiniciar o sistema.




# Desabilitar atualizações automáticas no Update Manager


echo -e "\n$(gettext 'Disabling automatic checking for new versions...')\n"

$time

# Desativar atualizações automáticas no update-manager:

# Se você usar o Atualizador de Software (Update Manager) e ele verificar por atualizações 
# automaticamente, você pode também desativar isso, editando o arquivo de configurações 
# do update-manager


# Caminho do arquivo

FILE="/etc/update-manager/release-upgrades"


# Verificar se o arquivo existe

if [ -e "$FILE" ]; then

  # echo "O arquivo $FILE existe."

  # $time


#  Editar o arquivo de configurações

# Encontre a linha Prompt=lts e altere o valor para Prompt=never, para desabilitar a verificação automática de novas versões do Ubuntu:

sed -i 's/Prompt=lts/Prompt=never/' /etc/update-manager/release-upgrades


# Isso evita que o Ubuntu faça verificações automáticas por novas versões do sistema operacional.

echo -e "\n$(gettext 'Automatic updates successfully disabled.

These steps will ensure that Ubuntu does not perform automatic updates, giving you full control over when updates are made.')\n"

# $time


$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-error.png" -t "$((DELAY * 1000))" "$(gettext 'ubuntu-debullshit')" "\n$(gettext 'Automatic updates successfully disabled.

These steps will ensure that Ubuntu does not perform automatic updates, giving you full control over when updates are made.')\n"


else


  message=$(gettext "The file %s does not exist.")

  echo -e "${RED}\n$(printf "$message" "$FILE") ${NC}"

  $time


fi


}



# https://www.youtube.com/watch?v=wA1BIJYZbXI


# ----------------------------------------------------------------------------------------


function disable_GNOME_extensions() {


# * Desative as extensões (pelo menos as que não usa)


# O comando gnome-extensions disable é utilizado para desativar uma extensão do GNOME 
# (um ambiente de desktop para Linux). O GNOME permite que você adicione funcionalidades 
# extras ao sistema por meio de "extensões". Quando você executa o comando 
# gnome-extensions disable, você está desabilitando uma extensão específica sem removê-la 
# do sistema. Isso pode ser útil quando você deseja temporariamente desativar uma extensão 
# para testar ou resolver problemas sem precisar desinstalá-la.




# Para ativar o "Não me perturbe" no Ubuntu, você pode usar a ferramenta 
# gnome-shell-extension-dnd (Do Not Disturb) do GNOME. Ela é responsável pela função de 
# "não perturbe" no GNOME Shell, o ambiente de desktop do Ubuntu.
# 
#     Instale a ferramenta necessária, caso não tenha instalado:
# 
# apt install -y gnome-shell-extension-dnd
# 
# Ative o "Não me perturbe": Para ativar a função, use o seguinte comando:
# 
# gnome-extensions enable [ID_da_extensão]
# 
# Normalmente, o ID da extensão de "Não Perturbe" será algo como 
# do-not-disturb@gnome-shell-extensions.gcampax.github.com. Porém, se você não souber o 
# ID exato, pode verificar com o comando:
# 
# gnome-extensions list
# 
# Ele irá listar as extensões instaladas. Procure pela extensão relacionada ao 
# "Do Not Disturb" e use o ID correto no comando acima.
# 
# Desative o "Não me perturbe" (se precisar reverter depois): Para desativá-lo, basta usar:
# 
#     gnome-extensions disable [ID_da_extensão]
# 
# Após isso, a função "Não me perturbe" deve estar ativada e você não receberá notificações.




if which gnome-extensions > /dev/null 2>&1; then

   # echo "O comando 'gnome-extensions' existe."





echo -e "${GREEN}$(gettext "Disable all GNOME extensions at once") ${NC}"

$time

echo -e "\n$(gettext 'Extensions that are active on your system:')\n" | tee -a "$log"

$time

gnome-extensions list | tee -a "$log"

# Isso irá retornar uma lista das extensões instaladas e ativas no GNOME.


# Para desativar uma extensão, use o comando abaixo, substituindo <nome_da_extensao> pelo nome da extensão que você deseja desativar (obtido com o comando gnome-extensions list):

# gnome-extensions disable <nome_da_extensao>


# Desativar todas as extensões de uma vez

for ext in $(gnome-extensions list); do


    message=$(gettext 'Disabling extension: %s')

    echo -e "\n$(printf "$message" "$ext")\n" >> "$log"

    echo -e "${RED}\n$(printf "$message" "$ext") ${NC}"


    gnome-extensions disable "$ext"  2>> "$log"


done

# Esse comando percorre todas as extensões ativas e as desativa uma por uma.


# Verificar se as extensões foram desativadas:

# Para verificar se as extensões foram desativadas, basta executar novamente o comando gnome-extensions list e verificar se as extensões estão listadas como desativadas.


echo -e "\n$(gettext 'Extensions that are active on your system now:')\n" | tee -a "$log"

$time

gnome-extensions list | tee -a "$log"


else



      echo -e "${RED}\n$(gettext 'Error disabling all GNOME extensions... Check if the gnome-extensions command is on the system.') ${NC}"
    
     $time

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-error.png" -t "$((DELAY * 1000))" "$(gettext 'ubuntu-debullshit')" "\n$(gettext 'Error disabling all GNOME extensions... Check if the gnome-extensions command is on the system.')\n"


fi


# 5:43 - https://www.youtube.com/watch?v=wA1BIJYZbXI

}



# ----------------------------------------------------------------------------------------

# Para desativar os espaços de trabalho dinâmicos no GNOME


function Static_Workspaces() {


echo -e "\n$(gettext "* Static Workspaces (Fix the number of workspaces and leave them static.)

To set up Static Workspaces in Ubuntu (i.e. fix the number of 
workspaces and make them static), you will need to change the 
GNOME Shell settings.

By default, GNOME Shell allows workspaces to adjust dynamically — that 
is, the number of workspaces increases as you open more windows and decreases 
as you close some of them. To set this to a fixed number of workspaces, 
click on the GNOME Shell icon.")\n\n\n\n"


sleep 10


echo -e "${GREEN}$(gettext "Disable dynamic workspaces (make them static)") ${NC}"

$time


# Para garantir que os Espaços de Trabalho sejam fixos e não se ajustem dinamicamente:

gsettings set org.gnome.desktop.wm.preferences dynamic-workspaces false  2>> "$log"

# Esse comando desabilita a opção de "espaços de trabalho dinâmicos", garantindo que o 
# número de espaços de trabalho seja fixo.


echo -e "\n$(gettext 'Set the fixed number of workspaces to two.')\n"

$time

#  Definir o número de espaços de trabalho fixos:

# Agora que você desativou a criação dinâmica de espaços de trabalho, você pode definir 
# quantos espaços de trabalho fixos deseja. O número padrão é 4, mas você pode definir 
# um número diferente.

# Por exemplo, para definir 2 espaços de trabalho fixos, execute o seguinte comando:

gsettings set org.gnome.desktop.wm.preferences num-workspaces 2  2>> "$log"

# Você pode substituir o número 2 pelo número de espaços de trabalho que você desejar.

    
echo -e "${RED}\n$(gettext 'This will ensure that the number of workspaces is fixed, and will not change 
automatically based on the number of open windows.') \n\n${NC}"

$time


}



# ----------------------------------------------------------------------------------------


function startup_programs() {


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

$time

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

$time

# O systemd é o sistema de inicialização que o Ubuntu usa para gerenciar os serviços do 
# sistema. Alguns programas podem ser configurados para iniciar como serviços do sistema, 
# e você pode listar esses serviços com o seguinte comando:

message=$(gettext 'Files in folder %s: ')

echo -e "\n$(printf "$message" "$HOME/.config/autostart")\n" | tee -a "$log"

$time


ls -lh ~/.config/autostart/ | tee -a "$log"


echo "" | tee -a "$log"


message=$(gettext 'Files in folder %s: ')

echo -e "\n$(printf "$message" "/etc/xdg/autostart")\n" | tee -a "$log"

$time

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

  $time


  echo -e "\n$(gettext 'Stopping service...')\n"

  $time

  systemctl stop "$service"      2>> "$log"     # Para o serviço imediatamente


# Verifica se houve erro durante a execução

if [ $? -eq 0 ]; then

    # Se o comando for bem-sucedido

    message=$(gettext "Service %s has been stopped successfully.")

    echo -e "${GREEN}\n$(printf "$message" "$service") \n${NC}"

    $time

else

    # Se houver algum erro

    message=$(gettext "An error occurred while trying to stop service %s. Check the log for more details.

Error logged: %s")

    echo -e "${RED}\n$(printf "$message" "$service" "$log") ${NC}"

    $time

fi




  echo -e "\n$(gettext 'Disabling the service so that it does not start automatically...')\n"

  $time

  systemctl disable "$service"   2>> "$log"     # Desabilita o serviço para não iniciar automaticamente na inicialização



# Verifica se houve erro durante a execução

if [ $? -eq 0 ]; then

    # Se o comando for bem-sucedido

    message=$(gettext "The %s service has been successfully disabled.")

    echo -e "${GREEN}\n$(printf "$message" "$service") \n${NC}"

    $time

else

    # Se houver algum erro

    message=$(gettext "An error occurred while trying to disable service %s. Check the log for more details.

Error logged: %s")

    echo -e "${RED}\n$(printf "$message" "$service" "$log") ${NC}"

    $time

fi



done




# O tee é um comando que lê a entrada e a escreve tanto na saída padrão (no terminal) quanto em um arquivo especificado.
# A opção -a (append) faz com que o tee adicione a mensagem ao final de um arquivo de log existente (especificado pela variável $log), em vez de sobrescrevê-lo.






# sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop


# sudo: Executa o comando com permissões de superusuário, ou seja, ele concede permissões 
# administrativas para modificar arquivos do sistema.
# 
# sed: O sed é uma ferramenta de manipulação de texto usada para realizar substituições 
# em arquivos de texto ou na entrada fornecida.
# 
# -i: Esse parâmetro diz ao sed para editar os arquivos no local, ou seja, a modificação 
# é feita diretamente no arquivo, sem necessidade de criar um arquivo temporário ou de saída.
# 
# "s/NoDisplay=true/NoDisplay=false/g": Esta é a expressão de substituição do sed. Ela 
# busca por todas as ocorrências de NoDisplay=true e as substitui por NoDisplay=false no 
# conteúdo dos arquivos. O g no final significa "global", ou seja, todas as ocorrências 
# na linha serão substituídas.
# 
# /etc/xdg/autostart/*.desktop: O caminho especifica todos os arquivos .desktop na pasta 
# /etc/xdg/autostart/. Arquivos .desktop são usados para definir como aplicativos são 
# lançados, com suas propriedades e configurações de execução, geralmente no ambiente 
# gráfico. Esses arquivos de configuração de inicialização contêm várias propriedades, 
# incluindo NoDisplay, que controla se o aplicativo será ou não exibido nas configurações 
# de inicialização automática.


# O que o comando faz?
# 
# Ele altera todos os arquivos .desktop dentro do diretório /etc/xdg/autostart/, 
# substituindo a linha NoDisplay=true por NoDisplay=false.
# 
#     Antes: Se NoDisplay=true, o aplicativo não será mostrado na interface gráfica de 
# configurações de inicialização.
# 
#     Depois: A mudança para NoDisplay=false faz com que o aplicativo passe a ser visível 
# nas configurações de inicialização automática.

# Isso pode ser útil quando você deseja tornar visíveis na interface gráfica aplicativos 
# que normalmente são ocultos nas configurações de inicialização automática.
 


# Services disabled successfully!

# echo "Serviços desativados com sucesso!"



}



# https://medium.com/@leandroembu/melhorando-a-performance-do-ubuntu-em-computadores-fracos-6b60c1a2678#:~:text=Desinstale%20o%20GNOME%20Online%20Accounts&text=Isso%20vai%20remover%20o%20suporte%20%C3%A0s%20Contas,servi%C3%A7o%20(daemon)%20que%20fica%20rodando%20no%20sistema.

# https://www.youtube.com/watch?v=HdyXCSe1aEE


# ----------------------------------------------------------------------------------------


# Redefinir o ambiente de desktop GNOME


function reset_GNOME(){


# Verifica o nome de usuário

user=$(whoami)


# Verifica se o usuário é Root

if [ "$user" == "root" ]; then

    echo -e "${RED}\n$(gettext 'The user is Root.') \n${NC}"

    # $time

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-error.png" -t "$((DELAY * 1000))" "$(gettext 'Restore Gnome Interface')" "\n$(gettext 'The user is Root.')\n"

   # exit 1

fi



# No Linux, o grupo wheel e o grupo sudo podem ter funções semelhantes, mas não são 
# exatamente a mesma coisa. Ambos os grupos geralmente concedem permissões para que o 
# usuário execute comandos como superusuário (ou seja, usando sudo), mas o comportamento 
# depende da distribuição e da configuração do sistema.


# Verifica se o usuário está no grupo sudo ou wheel

if groups "$user" | grep -q '\bsudo\b' || groups "$user" | grep -q '\bwheel\b'; then

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-error.png" -t "$((DELAY * 1000))" "$(gettext 'Restore Gnome Interface')" "\n$(gettext 'The user has sudo permissions.')\n"

   # exit 1

fi


    echo -e "${GREEN}$(gettext 'The user is common and does not have Root or sudo permissions.')  ${NC}"

    $time


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

# dconf reset -f /org/gnome/   2>> "$log" 


# Para listar os usuários comuns do sistema e mostrá-los em uma tela do yad, para que 
# você possa selecionar um e usá-lo em seu comando.

# clear

# Cria uma lista de usuários comuns

# Podemos usar o comando who para obter uma lista dos usuários conectados, que geralmente 
# será mais adequada para suas necessidades.


# Lista os usuários ativos atualmente conectados

usuarios=$(who | awk '{print $1}' | sort | uniq)




# Verifica se o yad está instalado

if command -v yad &> /dev/null
then


# Exibe a lista de usuários no yad

usuario_selecionado=$(echo "$usuarios" | yad --center --list --title="$(gettext 'Select a user')" --column="$(gettext 'Users')" --width=600 --height=500 --separator="\n" --button="$(gettext 'Select')":0 --button="$(gettext 'Cancel')":1)

# error: Erro ao chamar a linha de comandos “dbus-launch --autolaunch=9733713912251517def2795567c63105 --binary-syntax --close-stderr”: Processo filho concluiu com código 1


# Verifica se o dialog está instalado

elif command -v dialog &> /dev/null; then

# Usar o 'dialog' para exibir a lista e capturar a seleção

# usuario_selecionado=$(dialog   --backtitle 'ubuntu-debullshit' --stdout  --menu "$(gettext 'Select a user')" 0 0 0 $usuarios)

# clear


# Como funciona:
# 
# Agora, o dialog está sendo alimentado diretamente com o nome do usuário (como chave e valor) para que, quando o usuário fizer a seleção, ele retornará diretamente o nome do usuário escolhido.
# 
# Não há mais a necessidade de associar números às opções, o que simplifica a manipulação e mantém o valor desejado (nome do usuário).


# Pega os nomes dos usuários logados (excluindo o root)
usuarios=$(who | awk '{print $1}' | sort | uniq | grep -v '^root$')

# Inicializar uma variável para armazenar as opções formatadas
opcoes=""

# Construir a lista de opções para o comando 'dialog'
# Agora associamos diretamente os nomes dos usuários às opções, sem usar números
while IFS= read -r usuario; do
    opcoes+="$usuario $usuario "
done <<< "$usuarios"

# Exibe o menu para selecionar o usuário
usuario_selecionado=$(dialog --backtitle 'ubuntu-debullshit' --stdout --menu "$(gettext 'Select a user')" 0 0 0 $opcoes)

# Limpa a tela após o comando 'dialog'
clear

# Exibe uma notificação com o nome do usuário selecionado
# DELAY=5  # Defina o tempo de delay para a notificação






else


clear

        echo "$usuarios"
        
        echo -e "\nQual usuário deseja zera o Gnome?"
        read usuario_selecionado


fi



# Verifica se um usuário foi selecionado

if [ -n "$usuario_selecionado" ]; then

    # Executa o comando dconf reset -f /org/gnome/ com o usuário selecionado
    
  notify_users="sudo -u $(who | grep '('$DISPLAY')' | awk '{print $1}' | head -n 1) DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $(who | grep '('$DISPLAY')' | awk '{print $1}' | head -n 1))/bus"
  
    $notify_users  \
    dconf reset -f /org/gnome/
    

exit_code=$?

# Verifica o código de saída do comando

if [ $exit_code -eq 0 ]; then

    echo -e "${GREEN}\n$(gettext 'GNOME settings reset successfully performed...') \n${NC}"

    $time

else


    echo -e "${RED}\n$(gettext 'Errors occurred while resetting GNOME settings...') $(gettext 'Exit code:') $exit_code \n${NC}"
    
    exit $exit_code

    $time

fi

  
else

    echo -e "${RED}\n$(gettext 'No user selected....') \n${NC}"

    $time

    exit

fi

# Este script irá exibir uma lista dos usuários comuns no yad, permitir que você selecione um usuário e, em seguida, executar o comando dconf reset -f /org/gnome/ como o usuário selecionado.



# Isso irá resetar as configurações do GNOME para o estado padrão.


$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-warning.png" -t "$((DELAY * 1000))" "$(gettext 'Restore Gnome Interface') - $usuario_selecionado" "\n$(gettext 'Restart GNOME (or reboot your system) for the changes to take effect. You can restart GNOME with the command:

# killall -3 gnome-shell')\n"



# Método 2: Redefinindo as configurações do GNOME usando gnome-tweaks
# 
# Se você tem o GNOME Tweaks instalado, pode redefinir algumas configurações específicas 
# através dessa ferramenta:
# 
#     Abra GNOME Tweaks (Você pode procurar por "Ajustes" ou "Tweaks" no menu de aplicativos).
#     Vá para a aba que você deseja resetar (por exemplo, "Extensões", "Aparência" ou "Comportamento").
#     Dependendo da configuração, você pode manualmente voltar às configurações padrão.
#
#
# apt install -y gnome-tweak-tool
#


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


#  Desmarcar Parceiros da Canonical (Código fonte) do repositório


# Em Parceiros da Canonical não há necessidade de marcar a opção 
# "Parceiros da Canonical (Código fonte)" se o usuário não for programador 
# e precisar acessar o código de alguns softwares. Geralmente o usuário comum/médio 
# não se beneficiará dessa opção.


# Para desmarcar "Parceiros da Canonical" (ou qualquer repositório adicional) do 
# repositório do Ubuntu, podemos modificar os arquivos de repositórios encontrados 
# em /etc/apt/sources.list ou nos arquivos dentro do diretório /etc/apt/sources.list.d/.
# 
# O repositório "Parceiros da Canonical" geralmente é definido por uma linha como:
# 
# deb http://archive.canonical.com/ubuntu focal partner
# 
# Para desmarcar o repositório, basta comentar essa linha (adicionando # no início) ou removê-la.


function desmarcar_repositorio_canonical() {



# Caminho para o arquivo de repositórios principal

SOURCE_LIST="/etc/apt/sources.list"

# Caminho para o diretório de arquivos de repositórios adicionais

SOURCE_LIST_DIR="/etc/apt/sources.list.d/"


# Função para comentar a linha do repositório "parceiros"

desmarcar_repositorio() {

    # Comentar a linha do repositório "Parceiros da Canonical"

    sed -i '/canonical.com\/ubuntu/s/^\(deb .*\)$/#\1/' "$SOURCE_LIST"  2>> "$log" 
    
    # Comentar em arquivos do diretório sources.list.d

    for file in "$SOURCE_LIST_DIR"*.list; do

        sed -i '/canonical.com\/ubuntu/s/^\(deb .*\)$/#\1/' "$file"     2>> "$log" 

    done

}


# Explicação do Script:
# 
#  /etc/apt/sources.list: É o arquivo principal que contém as configurações dos repositórios.
# 
#  /etc/apt/sources.list.d/: Contém arquivos adicionais com repositórios específicos.
# 
#  sed -i '/canonical.com\/ubuntu/s/^\(deb .*\)$/#\1/': Usamos o comando sed para procurar 
#  qualquer linha que contenha canonical.com/ubuntu e comentar essa linha. O # no início 
#  da linha transforma o repositório em um comentário.
# 
#  apt update: Atualiza a lista de pacotes após a modificação dos repositórios.


# Executa a função

desmarcar_repositorio


    check_internet


    echo -e "${GREEN}\n$(gettext 'Updating repositories...') \n${NC}"

    $time

    apt update 2>> "$log" 

    $time


$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-information.png" -t "$((DELAY * 1000))" "$(gettext 'Canonical Partners Repository')" "\n$(gettext 'Canonical repositories successfully unchecked.')\n"


# Essa função desmarcará os repositórios de "Parceiros da Canonical" e atualizará a lista de pacotes.


}


# https://www.vivaolinux.com.br/dica/O-que-fazer-apos-instalar-o-Ubuntu-1404


# ----------------------------------------------------------------------------------------


#  Buscar a menor latência para repositorio
# 
# Em aplicativos Ubuntu (Dentro de programas e atualizações) recomendo usar o servidor - principal em vez do Servidor - Brasil, pois o Principal é mais rápido e estável.
# 
# O Principal na verdade é mais lento, pois vem da Grã-Bretanha até o Brasil (a latência é alta, mesmo com banda larga). Nisto recomendo deixar default (Brasil) mesmo.



# Busca a menor latência para os repositórios e informa ao usuário qual é o melhor servidor 
# para baixar pacotes:
# 
#     Obter uma lista de servidores de repositórios da distro.
#     Medir a latência de cada servidor.
#     Escolher o servidor com a menor latência.
#     Mostrar essa informação ao usuário utilizando yad ou notify-send .


function test_latency(){


# O script verificará se o arquivo /etc/apt/sources.list existe ou se o diretório 
# /etc/apt/sources.list.d/ existe, e executará o bloco echo caso nenhuma das condições 
# seja verdadeira.

if [ -e "/etc/apt/sources.list" ] || [ -d "/etc/apt/sources.list.d/" ]; then

  # Se a condição for verdadeira, o código será executado aqui


    check_internet


# Função para medir a latência de um servidor

function test_latency() {

    server=$1

    # Usando ping para medir a latência (4 pacotes e tempo máximo de resposta)

    latency=$(ping -c 4 -q $server | awk -F'/' 'END {print $5}')

    echo "$latency"
}


# Função para listar os servidores configurados nos arquivos sources.list e sources.list.d

function get_repositories() {

    # Usando grep para procurar todas as URLs dos repositórios

    grep -oP 'http[s]?://\S+' /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null | sort -u | sed 's|https\?://||' | cut -d/ -f1
}


# Obter os servidores dos repositórios configurados

servers=($(get_repositories))

# Inicializa as variáveis para armazenar o melhor servidor e sua latência

best_server=""
best_latency=9999


# Loop para testar a latência de cada servidor na lista

echo -e "\n\n$(gettext 'Testing server latency...')"

$time

for server in "${servers[@]}"; do


    message=$(gettext "Testing latency of %s...")

    echo -e "\n$(printf "$message" "$server")\n"

    $time

    latency=$(test_latency $server)


    # Verifica se a latência atual é menor que a melhor latência encontrada

    if (( $(echo "$latency < $best_latency" | bc -l) )); then

        best_latency=$latency

        best_server=$server
    fi

done


# Exibe o servidor com a menor latência e as URLs de repositórios configurados

message=$(gettext "The fastest repository server is: %s with latency of %s ms.")

echo -e "\n$(printf "$message" "$best_server" "$best_latency")"

$time

echo -e "\n$(gettext 'Repositories configured in the system:')\n"

$time

get_repositories


# Exibe o servidor de menor latência usando o yad

    message=$(gettext "The fastest repository server for your connection is:

%s

With latency of: %s ms.")



# Verifica se o yad está instalado

if command -v yad &> /dev/null
then


yad --center --info --title="$(gettext 'Best repository server')" \
    --text="$(printf "$message" "$best_server" "$best_latency")" \
    --buttons-layout=center \
    --width=600 --height=300 \
    --button="$(gettext 'OK'):0"


# Verifica se o dialog está instalado

elif command -v dialog &> /dev/null; then



dialog --backtitle 'ubuntu-debullshit' --msgbox "\n$(printf "$message" "$best_server" "$best_latency")\n" 8 50


clear



else


clear

        echo -e "\n$(printf "$message" "$best_server" "$best_latency")\n"


fi




# Explicação do que foi feito:
# 
# 
#  Função get_repositories:
# 
#   O get_repositories agora extrai todas as URLs de repositórios a partir dos arquivos 
# /etc/apt/sources.list e /etc/apt/sources.list.d/*.list.
# 
#   A expressão sed 's|https\?://||' remove o prefixo http:// ou https:// das URLs.
#   O cut -d/ -f1 pega apenas o domínio (ex.: archive.ubuntu.com).
# 
#
#  Uso da Função para Preencher a Lista de Servidores:
#
#    Agora a variável servers=() é preenchida diretamente com o resultado da função 
# get_repositories. Isso significa que a lista de servidores será obtida dinamicamente 
# com base nos repositórios configurados no sistema.
# 
# 
#  Medir Latência:
# 
#    O script percorre a lista de servidores e testa a latência de cada um usando o ping. 
# O servidor com a menor latência é selecionado.
# 
#  Resultado:
# 
#    Essa função exibe o servidor com a menor latência e também lista todos os servidores 
# de repositório configurados no sistema.
# 
# 
# Resultado Esperado:
# 
#     Essa função vai obter automaticamente os servidores de repositórios configurados no sistema.
#     Vai medir a latência de cada servidor.
#     Exibirá o servidor de repositório com a menor latência.
#     Exibirá a lista completa de servidores configurados no sistema.
# 
# É completamente dinâmico, adaptando-se automaticamente aos repositórios configurados no sistema.



else


  echo -e "${RED}\n$(gettext 'No repositories or folders were found...') \n${NC}"

  $time

  # sudo mkdir -p /etc/apt/sources.list.d/
  
  
fi


# https://www.thelinuxrain.org/articles/the-buttons-of-yad

}


# ----------------------------------------------------------------------------------------


# Configura o Firewall


function conf_firewall() {



# ----------------------------------------------------------------------------------------


# Firewall para Proteção Total de Privacidade


# O endereço IP 91.189.92.11 pertence à Canonical Group Limited, a empresa responsável 
# pelo desenvolvimento do Ubuntu.
# 
# Este IP está associado ao serviço productsearch.ubuntu.com, utilizado para fornecer 
# resultados de busca de produtos diretamente no Dash do Unity, a interface de busca do 
# Ubuntu.
# 
# Este serviço foi introduzido no Ubuntu 12.10 para integrar resultados de produtos da 
# Amazon ao Dash. No entanto, devido a preocupações com privacidade e feedback dos 
# usuários, a Canonical descontinuou essa funcionalidade em versões posteriores do Ubuntu.


# Função para configurar o firewall UFW

function Firewall_UFW() {

# Aqui abordamos as principais etapas de configuração do UFW para bloquear conexões indesejadas e 
# aumentar a privacidade do sistema.

# Para configurar o firewall do Ubuntu com uma proteção total de privacidade via script, 
# podemos usar o ufw (Uncomplicated Firewall), que é a ferramenta de firewall mais simples 
# e amplamente utilizada no Ubuntu. A ideia é bloquear conexões indesejadas e limitar o 
# tráfego para proteger a privacidade do sistema. Vamos criar um script que bloqueie 
# conexões de entrada e saída desnecessárias, proteja serviços e IPs específicos, além de 
# garantir uma configuração mais segura.
# 
# 
# O que esse script faz:
# 
#     Ativa o UFW (Uncomplicated Firewall): Se o firewall não estiver ativo, o script o 
# ativa.
# 
#     Limpeza das regras existentes: Caso haja regras antigas, elas são removidas para 
# começar a configuração do zero.
# 
# 
#     Definir políticas padrão:
# 
#         Bloquear todas as conexões de entrada: Impede qualquer tráfego de entrada não 
# solicitado, protegendo o sistema de possíveis ataques externos.
# 
#         Permitir todas as conexões de saída: Permite que o sistema se conecte à internet 
# para atualizações e serviços, mas depois vamos bloquear tráfego específico para proteger 
# a privacidade.
# 
#     Bloqueio de IPs específicos: O script bloqueia conexões de saída para alguns IPs 
# conhecidos por fornecer anúncios ou fazer rastreamento de dados (como os servidores da 
# Canonical e Amazon). Você pode adicionar mais IPs a essa lista conforme necessário.
# 
#     Permitir apenas tráfego local: O tráfego de entrada é restrito a 127.0.0.1 (loopback), 
# garantindo que somente serviços locais possam interagir com o sistema.
# 
#     Permitir serviços essenciais: O script deixa espaço para permitir serviços essenciais 
# como SSH (para acesso remoto) ou VPN, caso você queira configurar algum desses serviços.
# 
#     Verificar o status do firewall: O script imprime o status do firewall para garantir 
# que as regras estão ativas e funcionando corretamente.
# 
# 
# Observações:
# 
#     O script deve ser executado com privilégios de superusuário (sudo) para poder 
# configurar o firewall corretamente.
# 
#     Este script é um ponto de partida. Você pode precisar ajustar alguns detalhes 
# dependendo dos serviços que você usa (por exemplo, habilitar ou desabilitar o SSH ou VPN) 
# ou adicionar mais IPs que você deseja bloquear.
# 
#     O ufw é uma ferramenta de firewall simples, mas poderosa. Se você precisar de 
# configurações mais avançadas, como regras específicas de portas e protocolos, é possível 
# expandir esse script para incluir essas configurações.
# 
# Esse script ajuda a aumentar a privacidade, controlando o tráfego de entrada e saída e 
# bloqueando serviços que podem estar coletando dados sobre você.



# A ordem das regras no ufw é importante, pois o ufw avalia as regras na sequência em que 
# são aplicadas, e a primeira regra que corresponde à solicitação será a que será aplicada.




# ----------------------------------------------------------------------------------------

# Desativa o UFW se necessário

# O comando sudo ufw disable desativa o firewall. Isso pode ser perigoso, dependendo do 
# contexto, especialmente se você está tentando configurar um firewall seguro. Certifique-se 
# de que isso seja realmente necessário. Caso queira garantir que as regras anteriores sejam 
# limpas, é melhor usar o ufw reset.

sudo ufw  disable

sudo ufw status verbose

# ----------------------------------------------------------------------------------------

# Limpa as regras existentes, se houver

echo -e "$(gettext 'Cleaning up existing rules...')"

$time

# Aqui usamos o "yes" para resetar as regras do firewall, mas a execução de ufw reset deve ser feita com 
# cuidado, pois pode apagar todas as configurações personalizadas.

# Quando você executa o comando ufw reset, o ufw (Uncomplicated Firewall) irá perguntar se você deseja 
# continuar com a operação, porque isso apagará todas as regras de firewall configuradas anteriormente e 
# as redefinirá para os padrões de instalação. A mensagem que você viu, 
# "Resetting all rules to installed defaults. Proceed with operation (y|n)?", está pedindo confirmação para você
# prosseguir com a redefinição das regras.

# É possível rodar o comando ufw reset automaticamente com a resposta "y" (sim), sem precisar de confirmação 
# manual. Para fazer isso, você pode usar o comando yes no Linux, que envia automaticamente "y" para 
# qualquer comando que precise de uma confirmação.

yes |ufw reset | tee -a "$log"

# O comando yes irá automaticamente responder "y" para a pergunta de confirmação do ufw, permitindo que 
# o comando seja executado sem a necessidade de interação manual.

# Nota: Use com cautela, pois isso vai resetar todas as regras do ufw, removendo qualquer configuração 
# personalizada de firewall que você tenha feito.

# ----------------------------------------------------------------------------------------

# Ativa o Firewall


# Ativa o UFW (Uncomplicated Firewall)

echo -e "$(gettext 'Activating UFW...')"

$time

sudo ufw enable

sudo ufw status verbose

# ----------------------------------------------------------------------------------------

# Define a política padrão para bloquear todas as conexões de entrada e permitir todas as de saída

echo -e "$(gettext 'Setting default policies: block inbound, allow outbound...')"

$time

ufw default deny incoming    | tee -a "$log"

ufw default allow outgoing   | tee -a "$log"


# ----------------------------------------------------------------------------------------

# Permitir tráfego HTTP, HTTPS, DNS


# A linha ufw deny from any provavelmente está bloqueando o tráfego essencial. Para 
# permitir o tráfego de entrada para serviços essenciais (como DNS, HTTP, HTTPS), pode 
# especificar regras mais granulares. Pode, por exemplo, permitir conexões de entrada 
# para os serviços que precisa e ainda negar o acesso não autorizado.


ufw allow from any to any port 80 proto tcp     # Para tráfego HTTP

ufw allow from any to any port 443 proto tcp   # Para tráfego HTTPS

ufw allow from any to any port 53 proto udp   # Para DNS


# Configuração de serviços específicos que queremos permitir

echo -e "$(gettext 'Enabling essential system services...')"

$time

# Permitir SSH para acesso remoto (ajuste se necessário)
# sudo ufw allow ssh



# Permitir o tráfego para conexões VPN ou outras ferramentas que você queira permitir
# Por exemplo, para OpenVPN (ajuste a porta conforme necessário)
# sudo ufw allow 1194/udp


# ----------------------------------------------------------------------------------------


# Bloqueia IPs específicos (anúncios, rastreamento)


# Bloqueia conexões de saída para servidores de anúncios conhecidos (IP da Canonical, Amazon, e outros servidores de rastreamento)
# Aqui, vamos bloquear os servidores conhecidos por fazer rastreamento de dados.

echo -e "$(gettext 'Blocking ad servers and tracking...')"

$time

# Exemplo de servidores conhecidos da Canonical (substitua ou adicione mais conforme necessário)

#     BLOCKED_IPS=("91.189.92.11" "54.239.28.85" "127.0.0.1")

BLOCKED_IPS=(
  "91.189.92.11"  # IP do servidor de anúncios da Canonical
  "54.239.28.85"  # Amazon, por exemplo (ajustar conforme necessário)
  "127.0.0.1"     # Bloquear chamadas locais de loopback que possam ser indesejadas
)


# Adicionando regras para bloquear os IPs listados

for ip in "${BLOCKED_IPS[@]}"; do

  echo "$ip" | tee -a "$log"

  $time

  ufw deny out to $ip   | tee -a "$log"

done

# ----------------------------------------------------------------------------------------

# Bloquear todas as conexões de entrada de qualquer IP que não seja local

echo -e "$(gettext 'Blocking incoming connections, allowing only the local interface (loopback)...')"

$time

# Permite tráfego local

ufw allow from 127.0.0.1  | tee -a "$log"

# ----------------------------------------------------------------------------------------

# Nega tráfego de entrada


# A regra "ufw deny from any" no final pode ser redundante, 
# dependendo da ordem das regras. Certifique-se de que você 
# já tenha especificado as regras para serviços essenciais, como 
# HTTP, HTTPS, e DNS, antes de aplicar uma regra de bloqueio global.


# Regra de deny from any:

# Bloqueia todas as conexões de entrada (para todas as interfaces) vindas de qualquer IP 
# externo. Essa regra pode estar impedindo conexões que você precisa para acessar a internet.

ufw deny from any  | tee -a "$log"


# Regra de negação geral (ufw deny from any): Isso deve vir por último, pois ela bloqueia 
# todo o tráfego de entrada. Caso você a coloque antes de outras regras, você pode acabar 
# bloqueando tráfego legítimo (como HTTP, HTTPS e DNS) que você quer permitir.


# ----------------------------------------------------------------------------------------


# Verifica o status do firewall para garantir que as regras estão ativas

echo -e "\n$(gettext 'Checking Firewall status...')\n"

$time


# Condição de verificação do status do UFW

# Para garantir que o notify-send seja executado somente quando necessário.

if [ "$(sudo ufw status verbose | grep Status | cut -d: -f2 | xargs)" == "inactive" ]; then

  echo -e "\nUFW - $(gettext 'Firewall is disabled. Please check the configuration.')\n" >> "$log"
  
  echo -e "${RED}\n$(gettext 'Firewall is disabled. Please check the configuration.') \n${NC}"

  $time

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/security-medium.png" -t "$((DELAY * 1000))" "$(gettext 'Warning: UFW is down!')" "\n$(gettext 'Firewall is disabled. Please check the configuration.')\n"


else


echo -e "\nUFW - $(gettext 'Firewall configured for maximum privacy!')\n\n" >> "$log"
  
echo -e "${GREEN}\n$(gettext 'Firewall configured for maximum privacy!') \n${NC}"

# Para listar as regras do ufw (Uncomplicated Firewall)


# Este comando exibe as regras configuradas no firewall de forma detalhada. O verbose adiciona informações adicionais, como a interface de rede, os protocolos usados e as portas associadas a cada regra.

sudo ufw status verbose  | tee -a "$log"


# Se você quiser apenas ver uma lista simplificada das regras ativas, pode usar:

# sudo ufw status

# Isso vai mostrar as regras de maneira mais compacta, como "Allow" ou "Deny" para determinadas portas ou endereços IP.


# sudo ufw show raw: Exibe as regras de firewall de forma mais bruta, sem formatação.

# sudo ufw app list: Lista aplicativos que podem ser usados para configurar regras de firewall via ufw.

# Esses comandos são úteis para visualizar o status e as regras do firewall configuradas no seu sistema.





echo -e "\n\n\n" >> "$log"

echo -e "${RED}\n$(gettext '# sudo ufw  disable') \n${NC}"


$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/security-medium.png" -t "$((DELAY * 1000))" "$(gettext 'Firewall for Total Privacy Protection')" "\n$(gettext 'Firewall configured for maximum privacy!')\n"

fi


# ----------------------------------------------------------------------------------------


sleep 10


# Podemos agrupar as regras de firewall em funções separadas para tornar o script mais modular e reutilizável.

}


# ----------------------------------------------------------------------------------------


function Firewall_iptables() {


# Função para verificar se o iptables está instalado

function check_iptables() {

    # Verifica se o comando iptables está disponível

    if command -v iptables > /dev/null 2>&1; then

        echo -e "$(gettext 'iptables is already installed.')"

        $time

    else

        check_internet

        echo -e "$(gettext 'iptables is not installed. Installing now...')"

        $time

        # Atualiza o repositório de pacotes e instala o iptables

        apt update

        apt install -y iptables

        echo -e "$(gettext 'iptables installed successfully!')"

        $time

    fi
}


# Função para configurar as regras básicas do iptables (Firewall)

function configure_iptables() {

    echo -e "$(gettext 'Setting up basic iptables rules to protect your privacy...')"

    $time

# ----------------------------------------------------------------------------------------

        iptables -F
        iptables -X
        iptables -Z
    
# ----------------------------------------------------------------------------------------

    # Definindo a política padrão


# Política de Rejeição para INPUT e FORWARD:

#     As regras de iptables para as políticas padrão INPUT e FORWARD estão corretas, o 
# que significa que, por padrão, você está bloqueando todas as conexões de entrada e de 
# encaminhamento, permitindo apenas as saídas. Isso está bom para uma política de 
# segurança restritiva.


    echo -e "$(gettext 'Setting default policies: block all and allow local connections...')"

    $time

    iptables -P INPUT   ACCEPT

    iptables -P FORWARD DROP

    iptables -P OUTPUT  ACCEPT

# ----------------------------------------------------------------------------------------

    # Permitir conexões de loopback (localhost)

# Permitir tráfego local (loopback):

#    As regras para aceitar tráfego de loopback (lo) estão corretas. Isso é essencial para 
# permitir que o sistema se comunique consigo mesmo (por exemplo, para serviços locais).


    echo -e "$(gettext 'Allow local traffic (loopback)...')"

    $time

    iptables -A INPUT  -i lo -j ACCEPT

    iptables -A OUTPUT -o lo -j ACCEPT

# ----------------------------------------------------------------------------------------

    # Permitir SSH (ajuste se necessário)

# A linha comentada (para permitir o acesso SSH na porta 22) está opcional, dependendo do 
# que você deseja fazer. Se você precisar acessar o sistema via SSH, você pode descomentar 
# esta linha:

    # echo "Permitir SSH..."

    # $time

    # iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# ----------------------------------------------------------------------------------------

    # Permitir tráfego de saída para conexões essenciais


# Permitir tráfego de saída para HTTP, HTTPS e DNS:

#   As regras para permitir tráfego de saída para portas HTTP (80), HTTPS (443) e 
# DNS (53). Essas regras permitem que o servidor tenha acesso a sites na web e 
# resolva nomes de domínio.


#     echo -e "$(gettext 'Allow essential outbound traffic...')"

#     $time

#     iptables -A OUTPUT -p tcp --dport 80  -j ACCEPT  # Para HTTP
#     iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT  # Para HTTPS
#     iptables -A OUTPUT -p udp --dport 53  -j ACCEPT  # Para DNS


# ----------------------------------------------------------------------------------------

# Bloquear IPs específicos (lista BLOCKED_IPS):

    # Bloquear conexões para servidores de rastreamento (exemplo de IPs conhecidos)

    BLOCKED_IPS=("91.189.92.11" "54.239.28.85")

    for ip in "${BLOCKED_IPS[@]}"; do


        message=$(gettext 'Blocking tracking IP: %s')

        echo -e "$(printf "$message" "$ip")" | tee -a "$log"

        $time

        iptables -A OUTPUT -d $ip -j DROP

    done


# Bloquear IPs com outras ações: Além de usar DROP, você pode optar por usar REJECT caso 
# queira responder ativamente aos IPs bloqueados (embora isso possa gerar tráfego adicional). 
# Isso depende da sua política de segurança.


# ----------------------------------------------------------------------------------------

    # Salvar as regras do iptables

# Certifique-se de que você tem as permissões adequadas para escrever nesse arquivo, caso 
# contrário, você pode precisar executar o comando com permissões de Root.

    echo -e "$(gettext 'Saving rules...')"

    $time

    sudo sh -c 'iptables-save > /etc/iptables/rules.v4'



# Mas a persistência também pode depender de ferramentas adicionais, como 
# iptables-persistent em sistemas baseados em Debian/Ubuntu, ou systemctl enable iptables 
# em sistemas que usam systemd. Se você não usar essas ferramentas, as regras podem não 
# ser restauradas após uma reinicialização.

# Caso esteja usando iptables-persistent, você pode instalar e configurar com:

# apt install -y iptables-persistent


# ----------------------------------------------------------------------------------------

iptables --version  >>  "$log"

iptables -L >> "$log"


    echo -e "${GREEN}\n$(gettext 'Iptables rules configured successfully!') \n${NC}"


$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/security-medium.png" -t "$((DELAY * 1000))" "$(gettext 'Firewall for Total Privacy Protection')" "\n$(gettext 'Firewall configured for maximum privacy!')\n"




# Observações:
# 
#     SSH: O script comentado permite conexões SSH na porta 22. Se você precisar acessar 
# sua máquina via SSH, descomente a linha correspondente. Caso contrário, remova-a para 
# aumentar a segurança.
# 
#     Persistência: Em distribuições baseadas no Debian (como o Ubuntu), as regras do 
# iptables não são persistentes por padrão após reinicializações. O script resolve isso 
# salvando as regras no arquivo /etc/iptables/rules.v4, mas você também pode usar ferramentas 
# como iptables-persistent para garantir que as regras sejam carregadas automaticamente 
# após a reinicialização.
# 
#     Para instalar o iptables-persistent:
# 
#     apt install iptables-persistent
# 
#     IP de rastreamento: Você pode adicionar mais IPs à lista BLOCKED_IPS caso queira 
# bloquear outros servidores ou serviços específicos que considerem uma ameaça à privacidade.
# 
# Esse script fornece uma solução de firewall robusta e privada, utilizando o iptables, 
# permitindo que você tenha controle total sobre o tráfego de entrada e saída no seu sistema.


}


# Chama a função para verificar e instalar o iptables

check_iptables


# Chama a função para configurar as regras de firewall

configure_iptables


}


# ----------------------------------------------------------------------------------------


# Função para verificar se o ufw está instalado

function check_ufw() {


    # Verifica se o ufw está instalado

    dpkg -l | grep -q ufw


    # Se o ufw não estiver instalado

    if [ $? -ne 0 ]; then


        # echo -e "${RED}\n$(gettext 'UFW is not installed. Installing now...') \n${NC}"

        # $time

        # check_internet


        # Atualiza o repositório de pacotes e instala o ufw

        # apt update

        # apt install -y ufw


        # echo -e "${GREEN}\n$(gettext 'UFW installed successfully!') \n${NC}"

        # $time

        
        # Chama a função para configurar o firewall (iptables)
        
        Firewall_iptables


    else


        echo -e "${GREEN}\n$(gettext 'UFW is already installed.') \n${NC}"

        $time

        # Chama a função para configurar o firewall (UFW)

        Firewall_UFW


    fi

    
# https://www.cyberciti.biz/faq/how-to-delete-a-ufw-firewall-rule-on-ubuntu-debian-linux/
# https://medium.com/better-programming/understanding-ufw-8d70d5d8f9d2
# https://blog.ferenz.com.br/ufw-firewall-sintaxes-e-configuracao/
# https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu

}


# ----------------------------------------------------------------------------------------


# Chama a função para verificar e instalar o ufw

check_ufw



# https://github.com/tuxslack/fixubuntu


}

# ----------------------------------------------------------------------------------------


# Manter o Sistema Atualizado


# Dica: Nunca atualizar entre versões e sempre instalar de forma limpa!


# PC de produção, que precisa estar funcionando, não dá para ficar com essas ideias de 
# instalar/atualizar o sistema no primeiro mês.



function deb_upgrades() {


    check_internet


# Verificação Manual de Atualizações


echo -e "${GREEN}\n$(gettext 'Update the system') \n${NC}"

$time

# Para garantir que você tenha a lista mais recente de pacotes disponíveis para o sistema.

echo -e "$(gettext 'Updating package list...')"

$time

apt update 


# Depois de atualizar a lista de pacotes, você pode atualizar todos os pacotes do sistema.

echo -e "$(gettext 'Updating installed packages...')"

$time

apt upgrade -y


# Isso irá atualizar todos os pacotes para as versões mais recentes disponíveis.



# Para atualizar todos os pacotes do sistema, incluindo a instalação de novos pacotes ou 
# a remoção de pacotes antigos, quando necessário.
# 
# full-upgrade: Atualiza todos os pacotes do sistema para suas versões mais recentes. Ao 
# contrário de apt upgrade, que tenta apenas atualizar pacotes já instalados sem remover 
# nada, o full-upgrade pode também remover pacotes desnecessários ou que causam conflitos, 
# para garantir que o sistema esteja completamente atualizado e funcional.
#
#
# Realiza uma atualização completa do sistema, atualizando, instalando e removendo pacotes 
# conforme necessário, sem pedir confirmação ao usuário.

apt full-upgrade -y



# Atualizar a distribuição (opcional)

# Se você deseja atualizar para uma nova versão do Ubuntu (por exemplo, de uma versão LTS 
# para outra LTS), pode usar o comando:

# sudo do-release-upgrade


# Este comando verifica se há uma nova versão do Ubuntu disponível e, se houver, vai 
# permitir que você faça a atualização para essa versão.



echo -e "$(gettext 'Cleaning up unnecessary packages...')"

$time

# Após atualizar, você pode limpar pacotes antigos ou não necessários usando:

apt autoremove -y

# Isso remove pacotes que foram instalados automaticamente, mas que já não são mais necessários.



echo -e "$(gettext 'Cleaning up downloaded packages...')"

$time

# Você também pode limpar os pacotes baixados durante a atualização, para liberar espaço 
# no disco, com o comando:

apt clean

# Esses passos devem garantir que seu Ubuntu esteja atualizado corretamente! Se precisar 
# de mais alguma coisa, é só avisar.



}


# ----------------------------------------------------------------------------------------



function reduza_uso_de_swap() {


# Diminuir a taxa de uso de swap


echo -e "${GREEN}\n$(gettext 'Reduce swap access (Ubuntu defaults to 60.)') \n${NC}"


$time

# ----------------------------------------------------------------------------------------

# Definindo as variáveis

SWAPPINESS="10"

VFS_CACHE_PRESSURE="50"


# O sistema usa bastante swap quando tem pouca memória RAM (é o meu caso), ou quando você 
# tem mais RAM e o sistema está configurado para usar swap com mais frequência. O sistema 
# armazena algumas coisas numa área de cache da RAM para acessar mais rapidamente, e 
# esvazia essa área se a RAM for necessária para alguma coisa mais importante. 


# Vou fazer duas coisas:

#     Diminuir a taxa de uso de swap para que o sistema use mais RAM antes de recorrer ao 
# disco (onde, nos casos padrão, fica a swap). Se seu disco for mecânico, o desempenho 
# piora muito quando o sistema usa swap com muita frequência. No meu caso, com SSD, eu não 
# noto tanta perda.

#     Diminuir o uso do cache da memória para que ela fique mais disponível aos programas. 
# Se você for fazer uma operação demorada, como uma descompactação, o sistema deixa parte 
# dos dados no cache da RAM e outras coisas acabam indo para a área de troca (e isso pode 
# ser parte de um programa que você está usando) e você sente a perda de performance.

# Reduza o acesso ao swap (o padrão do Ubuntu é 60. Quanto menor o número, menor o acesso):

sysctl vm.swappiness=$SWAPPINESS

# Reduza o uso do cache (o padrão do Ubuntu é 100):

sysctl vm.vfs_cache_pressure=$VFS_CACHE_PRESSURE


# Torne as mudanças permanentes editando o arquivo /etc/sysctl.d/99-sysctl.conf

# nano /etc/sysctl.d/99-sysctl.conf

# Adicione o conteúdo abaixo ao final do arquivo

# vm.swappiness=10
# vm.vfs_cache_pressure=50



# Realiza a verificação e, caso as opções já existam, atualiza os valores. Se não 
# existirem, adiciona ao final do arquivo.


# Arquivo de configuração


# Verificar se o arquivo existe


# Verifica primeiro se o arquivo /etc/sysctl.d/99-sysctl.conf existe. Se não, ele verifica 
# se o arquivo /etc/sysctl.conf existe. Se nenhum dos dois arquivos existir, ele imprime 
# a mensagem "O arquivo não existe".


if [ -e "/etc/sysctl.d/99-sysctl.conf" ]; then

# O arquivo /etc/sysctl.d/99-sysctl.conf é um arquivo de configuração utilizado para 
# ajustar parâmetros do kernel do Linux, especificamente por meio do comando sysctl. Ele 
# permite configurar diversos parâmetros de sistema, como o comportamento da rede, a 
# memória, a segurança, entre outros, que são carregados durante o processo de inicialização 
# ou podem ser aplicados a qualquer momento usando o sysctl.

# O arquivo 99-sysctl.conf:

# O número 99 no nome do arquivo (como em 99-sysctl.conf) é uma convenção usada para 
# definir a ordem em que os arquivos de configuração são aplicados. Arquivos com números 
# mais altos têm prioridade e são aplicados depois de arquivos com números mais baixos. 
# Portanto, 99-sysctl.conf é carregado após outros arquivos com números menores (como 
# 00-sysctl.conf), permitindo que você sobrescreva configurações de maneira mais específica.


  SYSCTL_CONF="/etc/sysctl.d/99-sysctl.conf"


elif [ -e "/etc/sysctl.conf" ]; then


# O arquivo /etc/sysctl.conf é um arquivo de configuração utilizado no Linux para ajustar 
# parâmetros do kernel do sistema operacional, permitindo o controle de diversos aspectos 
# de desempenho e segurança do sistema em tempo de execução. Ele contém definições de 
# parâmetros do kernel que afetam o comportamento do sistema, como rede, memória, limites 
# de processo, entre outros.


# O que o /etc/sysctl.conf faz?

# Quando o sistema Linux inicia, o kernel e o sistema carregam configurações que podem 
# ser ajustadas de acordo com as necessidades do administrador do sistema. O arquivo 
# /etc/sysctl.conf é um desses lugares onde configurações do kernel podem ser definidas 
# de forma persistente, ou seja, as configurações que são aplicadas automaticamente sempre 
# que o sistema é inicializado.

  SYSCTL_CONF="/etc/sysctl.conf"

else


#  echo -e "${RED}\n$(gettext 'The file does not exist.') ${NC}"

#  exit


#  Se o objetivo é simplesmente não fazer nada quando nenhum dos arquivos for encontrado, 
#  pode substituir por um # (comentário), ou usar um comando como : (um comando nulo que 
#  não faz nada). 

# Não fazer nada

#    :

echo " "


# Explicação:
# 
#   : (dois pontos): É um comando nulo no shell, ou seja, não faz nada. Ele é útil quando 
# você precisa de um comando válido, mas não deseja executar nada em um determinado bloco 
# de código.
# 
# 
#   Comentário (#): Outra alternativa para indicar que você não quer fazer nada é 
# simplesmente adicionar um comentário explicativo, como # Não fazer nada, no lugar do 
# continue.


fi





if [ -z "$SYSCTL_CONF" ]; then

  # A variável SYSCTL_CONF não tem valor.

  echo -e "${RED}\n$(gettext 'The file does not exist.') ${NC}"

  $time


else

  # echo "A variável SYSCTL_CONF tem o valor: $SYSCTL_CONF"



# Verificando se vm.swappiness já está no arquivo e ajustando o valor

if grep -q "vm.swappiness" "$SYSCTL_CONF"; then

    echo -e "$(gettext 'vm.swappiness found, updating value...')"

    $time

    sed -i "s/^vm.swappiness=.*/vm.swappiness=$SWAPPINESS/" "$SYSCTL_CONF"

else

    echo -e "$(gettext 'vm.swappiness not found, adding to file...')"

    $time

    echo "vm.swappiness=$SWAPPINESS" >> "$SYSCTL_CONF"

fi



# Verificando se vm.vfs_cache_pressure já está no arquivo e ajustando o valor

if grep -q "vm.vfs_cache_pressure" "$SYSCTL_CONF"; then

    echo -e "$(gettext 'vm.vfs_cache_pressure found, updating value...')"

    $time

    sed -i "s/^vm.vfs_cache_pressure=.*/vm.vfs_cache_pressure=$VFS_CACHE_PRESSURE/" "$SYSCTL_CONF"

else

    echo -e "$(gettext 'vm.vfs_cache_pressure not found, adding to file...')"

    $time

    echo "vm.vfs_cache_pressure=$VFS_CACHE_PRESSURE" >> "$SYSCTL_CONF"

fi


# Aplicando as novas configurações


# O comando sysctl -p é usado para aplicar as configurações do arquivo de configuração do 
# sysctl (geralmente /etc/sysctl.conf ou arquivos dentro do diretório /etc/sysctl.d/) no 
# kernel do sistema sem precisar reiniciar o sistema.
# 
# 
# Explicação detalhada:
# 
#     sysctl: É uma ferramenta de linha de comando no Linux usada para visualizar ou 
# alterar parâmetros do kernel enquanto o sistema está em execução.
# 
#     -p: A opção -p diz ao sysctl para carregar as configurações de um arquivo específico, 
# aplicando os parâmetros listados nesse arquivo diretamente no kernel do sistema.
# 
# Por padrão, quando você executa sysctl -p sem especificar um arquivo, ele lê e aplica as 
# configurações de /etc/sysctl.conf.


# Se você quiser carregar configurações de um arquivo diferente, pode especificar o 
# caminho do arquivo.

sysctl -p "$SYSCTL_CONF"


echo -e "${GREEN}\n$(gettext 'Swap settings adjusted successfully!') \n${NC}"

$time


fi


# ----------------------------------------------------------------------------------------


# 10:52 https://www.youtube.com/watch?v=wA1BIJYZbXI


}

# ----------------------------------------------------------------------------------------


# Configurar a ordem dos botões da janela (minimizar, maximizar e fechar)
# 
# 
# Para identificar a versão do Ubuntu e, se for uma versão que utiliza o GNOME 2 com 
# Metacity, ele executará o comando gconftool-2 para ajustar o layout dos botões da janela.
# 
# O comando gconftool-2 é uma ferramenta usada para modificar configurações do sistema em 
# versões antigas do Ubuntu que utilizavam o GNOME 2 como ambiente de desktop. Especificamente, 
# ele é útil para ajustar configurações do GNOME 2, como o layout dos botões da janela.
# 
# Após o Ubuntu 11.04 (Natty Narwhal), o Ubuntu fez a transição para o Unity como o ambiente 
# de desktop padrão, e o GNOME 3 substituiu o GNOME 2 como o ambiente de desktop para outras 
# variantes, como o Ubuntu GNOME. O Unity e o GNOME 3 não utilizam o Metacity como gerenciador 
# de janelas e, por isso, o comando gconftool-2 deixou de ser relevante nessas versões.
# 
# Conclusão:
# 
# O comando funciona em versões anteriores ao Ubuntu 11.04, como o Ubuntu 10.04 e versões 
# mais antigas, que usavam o GNOME 2 com o Metacity. Para versões mais recentes do Ubuntu 
# (Ubuntu 11.04 e posteriores), você precisaria usar outras ferramentas, como dconf-editor 
# ou comandos específicos do GNOME Shell, para ajustar o comportamento dos botões na barra 
# de título das janelas.


function  layout_buttons_window(){


# $ lsb_release -a
# No LSB modules are available.
# Distributor ID:	Ubuntu
# Description:	Ubuntu 10.04 LTS
# Release:	10.04
# Codename:	lucid



# Obtendo a versão do Ubuntu:
# 
# O comando lsb_release -r retorna a versão do Ubuntu, que é extraída com o awk para pegar 
# apenas o número da versão.

UBUNTU_VERSION=$(lsb_release -r | awk '{print $2}')

# Compara a versão do Ubuntu

# Converte a versão para um número para comparação

# A versão do Ubuntu é transformada para um número sem ponto (sed 's/\.//') para facilitar a comparação.

UBUNTU_VERSION_NUMBER=$(echo $UBUNTU_VERSION | sed 's/\.//')

# Define a versão mínima do Ubuntu que pode usar o gconftool-2 (10.04)

# A versão mínima compatível com o comando gconftool-2 é o Ubuntu 10.04 (número 1004), e a 
# comparação é feita entre a versão do sistema e a versão mínima.

MIN_VERSION=1004


# Execução do comando:
#
# Se a versão for compatível (menor ou igual a 10.04), o script verifica se o gconftool-2 
# está instalado. Caso esteja, o comando gconftool-2 é executado para ajustar o layout 
# dos botões.


# echo -e "$UBUNTU_VERSION_NUMBER  \n$MIN_VERSION"


if [ "$UBUNTU_VERSION_NUMBER" -le "$MIN_VERSION" ]; then


    echo -e "${GREEN}\n$(gettext 'This version of Ubuntu supports the gconftool-2 command.') \n${NC}"

    $time

  
  # Verifica se o gconftool-2 está instalado

  if command -v gconftool-2 &> /dev/null; then

    # Executa o comando para ajustar os botões da janela e redireciona os erros para o log

# Esse comando vai capturar o nome do usuário atualmente logado e armazená-lo na variável 
# usuario_comum. Isso é útil para garantir que o comando seja executado para o usuário atual.


# A variável usuario_comum pode estar vazia, especialmente se o comando logname falhar 
# (se o script for executado em um ambiente que não tem um usuário logado).

# Aspas ao redor das variáveis: Sempre que você usa variáveis em comandos, é uma boa 
# prática colocar as variáveis entre aspas para evitar problemas com espaços em nomes de 
# arquivos ou usuários.


# Captura o nome do usuário atual

usuario_comum="$(logname)"

# Verifica se o nome do usuário foi encontrado

# Isso ajuda a evitar erros inesperados 

if [ -z "$usuario_comum" ]; then

    # echo "Erro: Não foi possível determinar o nome do usuário atual."

    exit 1
fi



# Se estiver usando o GNOME com o Mutter, usar o comando gsettings:

# sudo -u "$usuario_comum" gsettings set org.gnome.metacity.general button-layout 'menu:minimize,maximize,close' 2>> "$log" 



# Executa o comando gconftool-2 para o usuário comum

sudo -u "$usuario_comum" \
gconftool-2 --type string --set /apps/metacity/general/button_layout "menu:minimize,maximize,close" 2>> "$log" 


# Verifica se o comando foi bem-sucedido

if [[ $? -eq 0 ]]; then

    # Comando executado com sucesso!


# ----------------------------------------------------------------------------------------

# Aplicação da Configuração

# Às vezes, as alterações feitas via gconftool-2 ou gsettings podem não ser aplicadas 
# imediatamente e podem exigir um reinício da sessão ou do gerenciador de janelas.

# Solução:

# Tente reiniciar a sessão gráfica ou o gerenciador de janelas. Se estiver usando o 
# Metacity, você pode reiniciar o Metacity da seguinte forma:


# Verifica se o processo Metacity está rodando

if pgrep -x "metacity" > /dev/null; then

    # Se o Metacity estiver rodando, reinicia o Metacity

    # echo "Metacity está rodando. Reiniciando..."

    # Reinicia o Metacity

    killall -9 metacity && metacity &

# else
#    echo "Metacity não está rodando."

fi



# Ou, se estiver usando o GNOME Shell (Mutter), você pode reiniciar o GNOME Shell:

# gnome-shell --replace &


# ----------------------------------------------------------------------------------------


    echo -e "${GREEN}\n$(gettext 'Adjusted button layout.') \n${NC}"

    $time

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-information.png" -t "$((DELAY * 1000))" "$(gettext '') - $usuario_selecionado" "\n$(gettext 'Adjusted button layout.')\n"




else

    message=$(gettext 'Error executing command to adjust window buttons. See log file %s for details.')

    echo -e "${RED}\n$(printf "$message" "$log") ${NC}"

    $time

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-warning.png" -t "$((DELAY * 1000))" "$(gettext 'ubuntu-debullshit')" "\n$(printf "$message" "$log")\n"


fi





  else

    # Caso o gconftool-2 não esteja instalado, o script avisa ao usuário que ele deve 
    # instalar o pacote.


    echo -e "${RED}\n$(gettext 'gconftool-2 is not installed. Install it using: sudo apt-get install -y gconftool-2') ${NC}"

    $time

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-warning.png" -t "$((DELAY * 1000))" "$(gettext 'ubuntu-debullshit') - $usuario_selecionado" "\n$(gettext 'gconftool-2 is not installed. Install it using: sudo apt-get install -y gconftool-2')\n"


  fi



else


    echo -e "${RED}\n$(gettext 'This version of Ubuntu does not support the gconftool-2 command.') ${NC}"

    $time

$notify_users  \
notify-send -i "/usr/share/icons/gnome/32x32/status/dialog-warning.png" -t "$((DELAY * 1000))" "$(gettext 'ubuntu-debullshit')" "\n$(gettext 'This version of Ubuntu does not support the gconftool-2 command.')\n"


fi


 


#     Saída:
# 
#         O script informa ao usuário se a versão do Ubuntu é compatível ou não e se o comando foi executado com sucesso.


# Esse script ajudará a identificar se a versão do Ubuntu é compatível com o uso do comando gconftool-2 e executará a modificação do layout dos botões se possível.



} 



# ----------------------------------------------------------------------------------------

# Vamos instalar as aplicações do GNOME diretamente do Flathub.

function setup_gnome_apps() {

     # Please create a PR with missing gnome apps

     flatpak install flathub -y org.gnome.TextEditor org.gnome.clocks org.gnome.Logs org.gnome.Calculator org.gnome.Calendar org.gnome.Contacts org.gnome.Epiphany org.gnome.Loupe org.gnome.Music org.gnome.Papers org.gnome.Photos org.gnome.Showtime org.gnome.Snapshot org.gnome.Weather org.gnome.Maps org.gnome.seahorse.Application org.gnome.baobab org.gnome.SimpleScan


# Explicação:
# 
#  flatpak install flathub: Instala os pacotes do repositório Flathub.
# 
#  -y: Aceita automaticamente todas as permissões sem pedir confirmação ao usuário.


}

# ----------------------------------------------------------------------------------------


# Fortalecer a Autenticação
# 
#  Configuração de senhas fortes: Implemente políticas de senhas fortes (exigindo uma 
# combinação de letras maiúsculas, minúsculas, números e caracteres especiais).
# 
#  Modifique as configurações no /etc/login.defs ou utilize o pam_pwquality.so para 
# reforçar as regras de senhas.

# ----------------------------------------------------------------------------------------


# Segurança no SSH
# 
# Desabilitar login root: No arquivo /etc/ssh/sshd_config, desabilite o login de root e 
# use autenticação baseada em chave.
# 
# PermitRootLogin no
# PasswordAuthentication no
# 
# Usar chaves SSH: Em vez de usar senhas, gere chaves SSH para acessar o servidor de forma 
# mais segura.
# 
# ssh-keygen -t rsa -b 4096
# 
# Alterar a porta SSH: Mude a porta padrão (22) para uma porta não padrão.
# 
# Port 2222
# 
# Limitar acesso SSH por IP: Configure o firewall ou o sshd_config para permitir acesso 
# apenas a determinados IPs.

# ----------------------------------------------------------------------------------------

# Instalar o Fail2ban: Protege o sistema contra tentativas de acesso via SSH e outros 
# serviços, bloqueando IPs após múltiplas tentativas falhas.
# 
# apt install -y fail2ban
# 
# systemctl enable fail2ban
# systemctl start fail2ban

# ----------------------------------------------------------------------------------------

# Auditoria e Monitoramento
# 
# Instalar o auditd: O auditd permite auditar e registrar todas as atividades do sistema.
# 
# apt install -y auditd
# 
# systemctl enable auditd
# systemctl start auditd

# ----------------------------------------------------------------------------------------

# Criptografia
# 
#  Criptografia de disco: Use criptografia de disco completo (LUKS) para proteger dados 
# em caso de roubo ou acesso não autorizado.
# 
#  Configure a criptografia no momento da instalação ou use ferramentas como cryptsetup.
# 
#  Criptografia de arquivos sensíveis: Utilize ferramentas como GnuPG para criptografar 
# arquivos sensíveis.
# 
# gpg -c arquivo.txt

# ----------------------------------------------------------------------------------------

# Backup e Recuperação

#  Criação de backups regulares: Realize backups regulares dos seus dados críticos e 
# configure scripts automáticos de backup.
# 
#  Verificação de integridade dos backups: Teste periodicamente a integridade dos backups 
# para garantir que podem ser restaurados corretamente.


# ----------------------------------------------------------------------------------------

# Considerar a Segurança de Aplicações Web
# 
# Se estiver executando servidores web, como o Apache ou Nginx:
# 
# Configurar HTTPS: Utilize certificados SSL/TLS para criptografar o tráfego web (pode ser 
# feito facilmente com o Let's Encrypt).
# 
# Configurar cabeçalhos de segurança HTTP:
# 
#  Exemplo: X-Content-Type-Options: nosniff, Strict-Transport-Security.


# ----------------------------------------------------------------------------------------

# Considerações Finais

# Revisar regularmente logs de segurança: Monitore os logs do sistema, especialmente os 
# logs de autenticação e eventos do kernel.

# tail -f /var/log/auth.log

# Implementar um plano de resposta a incidentes: Esteja preparado para agir caso ocorra 
# uma violação de segurança.



# Conclusão

# A segurança de um sistema é uma combinação de práticas, ferramentas e políticas. Adotar 
# várias dessas recomendações e revisar frequentemente a configuração do sistema ajudará a 
# garantir que o Ubuntu esteja o mais seguro possível. Além disso, sempre fique atento às 
# vulnerabilidades e patches de segurança que surgem para os pacotes que você utiliza.

# ----------------------------------------------------------------------------------------


# Para trocar a posição dos botões da janela no GNOME
# 
#     Usando GNOME Tweaks (Ferramentas de Ajuste):
# 
#         Abra o aplicativo GNOME Tweaks (se não tiver, pode instalar com o comando sudo apt install -y gnome-tweaks no Ubuntu, por exemplo).
#         Na interface do GNOME Tweaks, vá para a aba Aparência.
#         Dentro dessa aba, procure pela opção Botões da janela.
# 
#         Em Botões da janela, você pode escolher a posição dos botões de "Fechar", "Minimizar" e "Maximizar". Normalmente, o GNOME os coloca à esquerda por padrão, mas você pode movê-los para a direita, se preferir.
# 
#     Usando dconf-editor (avançado):
# 
#         Abra o terminal e digite: dconf-editor
#         Navegue até: org > gnome > desktop > wm > preferences
#         Encontre a opção button-layout.
#         A chave padrão é geralmente: close,minimize,maximize:
#         Se você quiser mover os botões para a esquerda, altere para: :close,minimize,maximize
# 
# Após essas alterações, os botões devem mudar de posição conforme a sua escolha.
# 
# 
# Se você preferir realizar essa alteração via terminal, pode usar o gsettings para 
# alterar a posição dos botões da janela no GNOME. Aqui está o comando que você pode usar:
# 
# Para mover os botões da janela para a direita:
# 
# gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
# 
# Para mover os botões da janela para a esquerda (padrão):
# 
# gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"
# 
# Esses comandos alteram a configuração de layout dos botões da janela. O que está antes 
# dos dois pontos : indica a posição dos botões à esquerda, e o que está depois dos dois 
# pontos indica a posição dos botões à direita.
# 
# Após executar o comando, os botões devem aparecer na posição desejada.


# https://askubuntu.com/questions/651347/how-to-bring-back-minimize-and-maximize-buttons-in-gnome-3


# ----------------------------------------------------------------------------------------


function print_banner() {

clear

    echo "                                                                                                                                   
    ▐            ▗            ▐     ▐       ▝▜  ▝▜      ▐    ▝   ▗   ▗  
▗ ▗ ▐▄▖ ▗ ▗ ▗▗▖ ▗▟▄ ▗ ▗      ▄▟  ▄▖ ▐▄▖ ▗ ▗  ▐   ▐   ▄▖ ▐▗▖ ▗▄  ▗▟▄  ▐  
▐ ▐ ▐▘▜ ▐ ▐ ▐▘▐  ▐  ▐ ▐     ▐▘▜ ▐▘▐ ▐▘▜ ▐ ▐  ▐   ▐  ▐ ▝ ▐▘▐  ▐   ▐   ▐  
▐ ▐ ▐ ▐ ▐ ▐ ▐ ▐  ▐  ▐ ▐  ▀▘ ▐ ▐ ▐▀▀ ▐ ▐ ▐ ▐  ▐   ▐   ▀▚ ▐ ▐  ▐   ▐   ▝  
▝▄▜ ▐▙▛ ▝▄▜ ▐ ▐  ▝▄ ▝▄▜     ▝▙█ ▝▙▞ ▐▙▛ ▝▄▜  ▝▄  ▝▄ ▝▄▞ ▐ ▐ ▗▟▄  ▝▄  ▐  
                                                                                                      


$(gettext 'Version'): $version


$(gettext 'Download Ubuntu'): https://ubuntu.com/download

$(gettext 'kernel'): `uname -r`

$(gettext 'Processor architecture'): `uname -m`

$(gettext 'RAM consumption'): `free -h 2>/dev/null | grep Mem | awk '{print $3}'`

 "

$time

}

# ----------------------------------------------------------------------------------------

function show_menu() {




function YAD_OFF(){

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
    echo "23 - $(gettext 'Disables Canonical partner repositories')"
    echo "24 - $(gettext 'What is the best repository?')"
    echo "25 - $(gettext 'Configure the Firewall')"
    echo "26 - $(gettext 'Update the system')"
    echo "27 - $(gettext 'Reduza o acesso ao swap')"
    echo "28 - $(gettext 'Removing Ubuntu default apps')"
    echo "29 - $(gettext 'Configure the order of window buttons (minimize, maximize, and close)')"
    echo "30 - $(gettext 'Setting up Gnome desktop')"
    echo "31 - $(gettext 'Installing Gnome apps from flathub')"
    echo "50 - $(gettext 'Exit')"
    echo

read choice


}


function YAD_OFF2(){

choice=$(dialog \
--backtitle 'ubuntu-debullshit' \
--title "$(gettext 'Menu')" \
--menu "$(gettext 'Choose what to do:')" 40 80 30 \
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
23 "$(gettext 'Disables Canonical partner repositories')" \
24 "$(gettext 'What is the best repository?')" \
25 "$(gettext 'Configure the Firewall')" \
26 "$(gettext 'Update the system')" \
27 "$(gettext 'Reduza o acesso ao swap')" \
28 "$(gettext 'Removing Ubuntu default apps')" \
29 "$(gettext 'Configure the order of window buttons (minimize, maximize, and close)')" \
30 "$(gettext 'Setting up Gnome desktop')" \
31 "$(gettext 'Installing Gnome apps from flathub')" \
50 "$(gettext 'Exit')" --stdout)



# dialog \
# --backtitle 'ubuntu-debullshit' \
# --radiolist "$(gettext 'Choose what to do:')" 40 80 30 \
# "25" "$(gettext 'Configure the Firewall')" OFF \
# "26" "$(gettext 'Update the system')" OFF \
# "27" "$(gettext 'Reduza o acesso ao swap')" OFF \
# "50" "$(gettext 'Exit')" ON --stdout


clear


}



function YAD_ON(){

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
false 23 "$(gettext 'Disables Canonical partner repositories')" \
false 24 "$(gettext 'What is the best repository?')" \
false 25 "$(gettext 'Configure the Firewall')" \
false 26 "$(gettext 'Update the system')" \
false 27 "$(gettext 'Reduza o acesso ao swap')" \
false 28 "$(gettext 'Removing Ubuntu default apps')" \
false 29 "$(gettext 'Configure the order of window buttons (minimize, maximize, and close)')" \
false 30 "$(gettext 'Setting up Gnome desktop')" \
false 31 "$(gettext 'Installing Gnome apps from flathub')" \
true  50 "$(gettext 'Exit')" \
--buttons-layout=center  --button="$(gettext 'OK')":0 \
--width="700" --height="795")


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
# https://aurelio.net/shell/dialog/


}



# ----------------------------------------------------------------------------------------


function main() {


    check_root_user


    # Chama a função para identificar a distribuição

    identificar_distro
    
    # check_distro


    check_programs

     
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
    
$notify_users  \
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


            # Adicionando o repositório julianfairfax

            setup_julianfairfax_repo


            # Instalar adw-gtk3

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



# Verifica se o yad está instalado

if command -v yad &> /dev/null
then

    yad --center --window-icon="$ICON" --text-info --title="ubuntu-debullshit - $(gettext 'Help')" --filename="$file_path" --buttons-layout=center  --button="$(gettext 'OK')":0 --width="1200" --height="800"


# Verifica se o dialog está instalado

elif command -v dialog &> /dev/null; then



# dialog --backtitle 'ubuntu-debullshit' --msgbox "\n$(cat $file_path)\n" 40 100


dialog --backtitle 'ubuntu-debullshit' --textbox $file_path 40 100


clear



else


clear

        more $file_path
        

fi




else
    
    # Se o arquivo não existir, exibe a notificação

    message=$(gettext 'The file %s does not exist.')


    # A conexão está fechada

$notify_users  \
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

            # Desabilita repositórios de parceiros da Canonical

            desmarcar_repositorio_canonical       

            msg "$(gettext 'Done!')"

            ;;

        24)

            # Busca a menor latência para os repositórios
       
            test_latency

            msg "$(gettext 'Done!')"

            ;;


        25)

            # Configura o Firewall

            conf_firewall

            msg "$(gettext 'Done!')"


            ;;


        26)

            # Atualizar o sistema

            deb_upgrades

            msg "$(gettext 'Done!')"


            ;;

        27)

            # Reduza o acesso ao swap 

            reduza_uso_de_swap 

            msg "$(gettext 'Done!')"


            ;;

        28)

            # Remove muitos aplicativos deb pré-instalados.

            remove_ubuntu_default_apps

            msg "$(gettext 'Done!')"

            ;;

        29)

            # Configurar a ordem dos botões da janela (minimizar, maximizar e fechar)

            layout_buttons_window

            msg "$(gettext 'Done!')"

            ;;


        30)

            # Configurando o ambiente de trabalho Gnome

            setup_desktop

            msg "$(gettext 'Done!')"

            ;;


        31)

            # Instalando aplicativos Gnome do flathub

            msg 'Installing Gnome apps from flathub'

            setup_gnome_apps

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


function auto() {


    check_internet


    # Atualizando o sistema

    msg "$(gettext 'Updating system')"

    update_system


    # Configurar a ordem dos botões da janela (minimizar, maximizar e fechar)

    # msg "$(gettext 'Configure the order of window buttons (minimize, maximize, and close)')"

    # layout_buttons_window


    # Removendo aplicativos padrão do Ubuntu

    msg "$(gettext 'Removing Ubuntu default apps')"

    remove_ubuntu_default_apps


    msg "$(gettext 'Disabling ubuntu report')"

    disable_ubuntu_report


    msg "$(gettext 'Removing annoying appcrash popup')"

    remove_appcrash_popup


    # Removendo anúncios de terminal (se estiverem habilitados)

    msg "$(gettext 'Removing terminal ads (if they are enabled)')"

    disable_terminal_ads


    msg "$(gettext 'Disable Telemetry')"

    remove_telemetry


    # Removendo snap

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

    # msg "$(gettext "Remove PPA (Personal Package Archive) from the system")"

    # remover_PPA


    # Redefinir o ambiente de desktop GNOME

    # msg $(gettext 'Restore Gnome Interface')

    # reset_GNOME



    # Desabilita repositórios de parceiros da Canonical

    msg $(gettext 'Disables Canonical partner repositories')

    desmarcar_repositorio_canonical       



    # Busca a menor latência para os repositórios

    # msg  "$(gettext 'What is the best repository?')"
  
    # test_latency


    # Configura o Firewall

    msg $(gettext 'Configure the Firewall')

    conf_firewall


    # Atualizar o sistema

    msg $(gettext 'Update the system')

    deb_upgrades


    # Reduza o acesso ao swap 

    msg "$(gettext 'Reduza o acesso ao swap')"

    reduza_uso_de_swap 



    # Instalando flatpak e flathub

    msg "$(gettext 'Setting up flathub')"

    setup_flathub


    # Instalando o Firefox do repositório da Mozilla

    msg "$(gettext 'Restoring Firefox from mozilla repository')"

    restore_firefox


    msg "$(gettext 'Installing vanilla Gnome session')"

    setup_vanilla_gnome


    # Adicionando o repositório julianfairfax

    msg "$(gettext 'Adding julianfairfax repo')"

    setup_julianfairfax_repo


    # Instalar adw-gtk3

    msg "$(gettext 'Install adw-gtk3 and set dark theme')"

    install_adwgtk3


    msg "$(gettext 'Installing GNOME 46 and morewaita icons')"

    # msg 'Installing vanilla icons and Papirus icons'

    install_icons


    # Configurando o ambiente de trabalho Gnome

    # msg "$(gettext 'Setting up Gnome desktop')"

    # setup_desktop


    # Instalando aplicativos Gnome do flathub

    # msg 'Installing Gnome apps from flathub'

    # setup_gnome_apps


    # Limpeza

    msg "$(gettext 'Cleaning up')"

    cleanup

}

# ----------------------------------------------------------------------------------------


(return 2> /dev/null) || main



