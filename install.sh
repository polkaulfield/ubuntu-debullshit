#!/bin/bash


# https://unix.stackexchange.com/questions/203136/how-do-i-run-gui-applications-as-root-by-using-pkexec

log="/tmp/ubuntu-debullshit.log"



clear

# ----------------------------------------------------------------------------------------


# echo "Você está executando como Root!"



which yad             1> /dev/null 2> /dev/null || { echo "Programa Yad não esta instalado."      ; exit ; }

which gettext         1> /dev/null 2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa gettext não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; }

which msgfmt          1> /dev/null 2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa msgfmt não esta instalado. Falta o pacote gettext"        --width 450 --height 100 2>/dev/null   ; exit ; }

which notify-send     1> /dev/null 2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa notify-send não esta instalado." --width 450 --height 100 2>/dev/null   ; exit ; }

which find            1> /dev/null 2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa find não esta instalado."        --width 450 --height 100 2>/dev/null   ; exit ; }
which sed             1> /dev/null 2> /dev/null || { yad --center --image=dialog-error --timeout=10 --no-buttons --title "Aviso" --text "Programa sed não esta instalado."        --width 450 --height 100 2>/dev/null   ; exit ; }



# ----------------------------------------------------------------------------------------

# Verificar se o script está sendo executado como Root

if [ "$EUID" -ne 0 ]; then

   yad --center --title="Erro" --text="Este script deve ser executado como Root!" --button=OK
  
  exit 1
  
fi


# ----------------------------------------------------------------------------------------

# echo "

# $ xrandr -s  1440x900

# $ setxkbmap br

# apt install -y yad gettext

# dpkg-reconfigure locales

# $ export LANG=pt_BR.UTF-8

# Fecha a sessão do openbox e no gerenciador de login seleciona o idioma desejado.

# $ pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /usr/local/bin/ubuntu-debullshit.sh

# "


# ----------------------------------------------------------------------------------------

# Função para instalar pacotes

  
instalar(){

clear

rm "$log"

echo "Iniciando a instalação..." | tee -a "$log"
  
find usr -type f > desinstalar_ubuntu-debullshit.log


# Incluir uma / no início de cada linha do arquivo desinstalar_ubuntu-debullshit.log usando o comando sed

sed -i 's/^/\//g' desinstalar_ubuntu-debullshit.log


# Filtra todos os arquivos .pot da pasta  usr/share/doc/ubuntu-debullshit/locale/ para gera o arquivo .mo na pasta usr/share/locale/  corresponde ao idioma.
find usr/share/doc/ubuntu-debullshit/locale/ -type f -name "*.pot" | while read potfile; do

    # Obtém o nome do idioma a partir do arquivo .pot
    lang=$(basename "$potfile" .pot | sed 's/ubuntu-debullshit_//')

    # Diretório onde o arquivo .mo será gerado
    mo_dir="usr/share/locale/$lang/LC_MESSAGES"

    # Cria o diretório se não existir
    
    # echo "$mo_dir"
    
    mkdir -p "$mo_dir"
    
    # Usa msgfmt para gerar o arquivo .mo
    
    # echo "$potfile" 
    
    msgfmt "$potfile" -o "$mo_dir/ubuntu-debullshit.mo" 2>> "$log"
    
done


sleep 2

echo "Instalando pacote..." | tee -a "$log"
    
cp -r usr /  | tee -a "$log"

    if [ $? -eq 0 ]; then
    
      echo "Pacote instalado com sucesso." | tee -a "$log"
      
    else
    
      echo "Erro ao instalar pacote. Verifique o log $log para mais detalhes." | tee -a "$log"
      
    fi
    

# Aplica o comando chmod 755 a todos os arquivos chamados ubuntu-debullshit.mo na pasta /usr/share/locale/

sudo find /usr/share/locale/ -type f -name 'ubuntu-debullshit.mo' -exec sudo chmod 755 {} \;  2>> "$log"


echo "
Para mais informações verifique o arquivo de log $log
"

cat "$log"

}


# ----------------------------------------------------------------------------------------


# Função para desinstalar pacotes

desinstalar(){

clear

rm "$log"

echo "Iniciando a desinstalação..." | tee -a "$log"
  
# Para remover todos os arquivos listados no arquivo desinstalar_ubuntu-debullshit.log, você pode usar o comando rm em conjunto com o comando xargs.

echo "Desinstalando pacote..." | tee -a "$log"

cat desinstalar_ubuntu-debullshit.log | xargs rm -f   

# 2>> "$log"

    if [ $? -eq 0 ]; then
      echo "Desinstalado com sucesso." | tee -a "$log"
    else
      echo "Erro ao desinstalar. Verifique o log $log para mais detalhes." | tee -a "$log"
    fi
    

echo "
Para mais informações verifique o arquivo de log $log
"

cat "$log"

}

# ----------------------------------------------------------------------------------------


# Função para exibir ajuda

ajuda() {

  clear

  echo "Uso: $0 [instalar|desinstalar]" | tee -a "$log"

  echo "
"        | tee -a "$log"

  echo "Exemplo: $0 instalar|install"           | tee -a "$log"
  echo "Exemplo: $0 desinstalar|uninstall"      | tee -a "$log"

}


# ----------------------------------------------------------------------------------------

# Verificar se o usuário forneceu pelo menos um argumento

if [ "$#" -lt 1 ]; then

  ajuda

  exit 1

fi


# ----------------------------------------------------------------------------------------

# Chamar a função apropriada com base no primeiro argumento

comando=$1
shift

case "$comando" in

  instalar|install)
    instalar "$@"
    ;;

  desinstalar|uninstall)
    desinstalar "$@"
    ;;

  *)
    ajuda
    exit 1
    ;;

esac

# ----------------------------------------------------------------------------------------

rm /tmp/ubuntu-debullshit.log

exit 0

