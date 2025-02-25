#!/bin/bash


# https://unix.stackexchange.com/questions/203136/how-do-i-run-gui-applications-as-root-by-using-pkexec


clear

which gettext || exit
which yad     || exit

# echo "

# $ xrandr -s  1440x900

# $ setxkbmap br

# apt install -y yad gettext

# dpkg-reconfigure locales

# $ export LANG=pt_BR.UTF-8

# Fecha a sessão do openbox e no gerenciador de login seleciona o idioma desejado.

# $ pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /usr/local/bin/ubuntu-debullshit.sh

# "

cp -r usr /


# Aplica o comando chmod 755 a todos os arquivos chamados ubuntu-debullshit.mo na pasta /usr/share/locale/

sudo find /usr/share/locale/ -type f -name 'ubuntu-debullshit.mo' -exec sudo chmod 755 {} \;



exit 0

