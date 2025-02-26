# ubuntu-debullshit!

#### Um script automatizado para configurar o Ubuntu como ele deve ser. Testado no Ubuntu 22.04, 23.04 e 24.04.2 LTS

<img src="https://raw.githubusercontent.com/polkaulfield/ubuntu-debullshit/main/menu.png" width="500" />

#### Recursos:

* Remove snaps completamente
* Instala uma sessão vanilla gnome
* Configura flathub e gnome-software com o plugin flatpak
* Instala gnome-tweaks
* Instala [Extension Manager](https://github.com/mjakeman/extension-manager)
* Desativa o tema do Ubuntu
* Habilita o tema libadwaita em aplicativos gtk3 usando [adw-gtk3](https://github.com/lassekongo83/adw-gtk3)
* Instala o tema de ícones adwaita 46 e morewaita para suporte estendido a ícones
* Habilita a integração do gnome com Aplicativos QT
* Instala o Firefox do Repositório Mozilla
* Desativa o componente de relatórios de dados
* Desativa o pop-up de travamento irritante
* Remove anúncios de terminal

Resumo: você terminará com uma área de trabalho GNOME limpa com flatpaks, semelhante a uma instalação nova do Fedora.

#### Visualização

<img src="https://raw.githubusercontent.com/polkaulfield/ubuntu-debullshit/main/screenshot.png" width="500" />

#### Instalação

Eu recomendo uma instalação mínima do Ubuntu 24.04.2 LTS para executar isso.

Você pode baixar o script do repositório ou usar este comando oneliner, não há dependências necessárias.

`sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/polkaulfield/ubuntu-debullshit/main/ubuntu-debullshit.sh)"`

Após a instalação, reinicie e aproveite uma experiência limpa :)

<a href='https://ko-fi.com/polkaulfield' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Compre-me um café em ko-fi.com' />


O Ubuntu não é considerado um "spyware" no sentido tradicional, mas há algumas práticas de coleta de dados que podem ser vistas como invasivas, dependendo da sua perspectiva e preocupações com a privacidade. Vamos esclarecer como a coleta de dados funciona no Ubuntu e como você pode controlá-la ou desativá-la, caso tenha preocupações.
O que o Ubuntu coleta?

A Canonical, empresa por trás do Ubuntu, coleta alguns dados para melhorar a distribuição e oferecer suporte técnico. A coleta de dados pode incluir:

    Relatórios de falhas e erros (Apport): Quando um aplicativo ou o sistema falha, o Ubuntu pode coletar informações sobre o erro e enviar para a Canonical, para ajudar a melhorar o sistema. Isso é feito através do Apport, que pode ser configurado para desativar.

    Informações sobre o sistema e uso de hardware (ubuntu-report): Durante a instalação ou quando você configura o Ubuntu, ele pode coletar informações sobre o hardware, a versão do sistema e os pacotes instalados, com o objetivo de melhorar a experiência de uso e o suporte a dispositivos. Esses dados são coletados por um serviço chamado ubuntu-report.

    Snap: O sistema de pacotes Snap também pode coletar dados de uso de pacotes instalados via Snap, como as atualizações e interações com pacotes.

    Pesquisa na Dash: Em versões antigas do Ubuntu, ao realizar pesquisas na Dash (a ferramenta de pesquisa do Unity), algumas informações eram enviadas para a Amazon para mostrar resultados de pesquisa patrocinados. Essa prática gerou bastante controvérsia. A partir do Ubuntu 16.04, essa funcionalidade foi desativada por padrão, mas ainda pode ser ativada em alguns casos.

O Ubuntu é spyware?

Não, o Ubuntu não é spyware. A Canonical, empresa responsável pelo Ubuntu, foi transparente quanto à coleta de dados. No entanto, alguns usuários podem considerar que a coleta de dados, especialmente quando feita de forma automática, pode afetar a privacidade. A boa notícia é que o Ubuntu oferece várias maneiras de desativar ou limitar essa coleta de dados.
Como desativar a coleta de dados no Ubuntu?

    Desativar relatórios de falhas (Apport):

        Para desativar o Apport (relatórios de falhas), você pode parar o serviço e desativá-lo:

    sudo systemctl stop apport
    sudo systemctl disable apport

Desativar o ubuntu-report:

    Você pode desativar o ubuntu-report, que coleta informações do sistema, editando o arquivo de configuração:

    sudo sed -i 's/Enabled=1/Enabled=0/' /etc/default/ubuntu-report

Desativar o Snap Telemetry:

    Para desativar a coleta de dados do Snap, você pode usar:

    sudo snap set system telemetry=off

Desativar o Whoopsie (para relatórios de falhas):

    O Whoopsie também pode ser desativado, o que impede a coleta de falhas:

        sudo systemctl stop whoopsie
        sudo systemctl disable whoopsie

    Desativar a coleta de dados de pesquisa da Dash:
        No passado, o Ubuntu enviava consultas de pesquisa para a Amazon, mas isso foi desativado por padrão em versões mais recentes. Para garantir que a coleta de dados de pesquisa esteja desativada, verifique se a opção "Incluir resultados online nas buscas" está desmarcada em "Configurações" > "Privacidade" > "Pesquisa online".

Conclusão

O Ubuntu não é considerado spyware. No entanto, há certos recursos de coleta de dados no sistema que podem ser considerados como uma forma de monitoramento, dependendo das suas preocupações com a privacidade. A boa notícia é que a Canonical oferece opções para desativar ou minimizar a coleta de dados. Se a privacidade for uma preocupação importante para você, você pode facilmente desativar esses recursos para garantir que os dados do seu sistema não sejam enviados para a Canonical.

Portanto, se você não deseja que o Ubuntu colete dados, há maneiras de configurar o sistema para garantir mais privacidade.



Identificar backdoors no Ubuntu ou em qualquer sistema Linux envolve examinar a presença de programas ou configurações que possam ser usados para acessar o sistema sem o conhecimento ou autorização do administrador. Backdoors podem ser instalados por malware, usuários mal-intencionados ou até por administradores legítimos para fins de manutenção (embora isso seja uma prática ruim). Aqui estão algumas etapas e ferramentas que você pode usar para identificar e remover backdoors no Ubuntu:

1. Verificar processos e conexões de rede
A) Verificar processos em execução:

Examine os processos em execução para identificar qualquer comportamento suspeito. Alguns backdoors podem se esconder como processos normais ou serviços.

ps aux --sort=-%mem | head -n 10

Este comando exibe os 10 processos que estão consumindo mais memória no sistema. Procure por processos desconhecidos ou não relacionados ao seu ambiente normal.

Para uma verificação mais profunda:

top

B) Verificar portas de rede abertas:

Backdoors podem abrir portas para permitir acessos remotos. Use o comando netstat ou ss para verificar as portas abertas no sistema:

netstat -tuln

Ou, se você preferir ss, que é mais eficiente:

ss -tuln

Procure por portas suspeitas ou desconhecidas que podem estar abertas e podem estar sendo usadas por backdoors.
C) Verificar conexões ativas:

Verifique as conexões de rede ativas para ver se há algo suspeito:

netstat -tnp

Isso mostrará todas as conexões ativas e os processos que as estão utilizando. Verifique se há conexões inesperadas com IPs desconhecidos.
2. Examinar usuários e grupos
A) Verificar usuários no sistema:

Verifique se há usuários desconhecidos ou suspeitos no sistema:

cat /etc/passwd

Isso listará todos os usuários do sistema. Se você encontrar usuários não autorizados, investigue mais a fundo.
B) Verificar grupos no sistema:

Verifique se há grupos de usuários suspeitos que possam ter sido criados por um backdoor:

cat /etc/group

3. Verificar tarefas agendadas (cron jobs)

Backdoors podem ser configurados para executar periodicamente usando cron jobs. Verifique os arquivos de configuração do cron para encontrar qualquer tarefa agendada maliciosa.
A) Verificar cron jobs do usuário:

Verifique o cron do usuário padrão (geralmente, o arquivo crontab):

crontab -l

B) Verificar cron jobs do sistema:

Verifique também os cron jobs do sistema:

cat /etc/crontab
cat /etc/cron.d/*

Verifique se há tarefas agendadas que não são familiares ou que parecem suspeitas.
4. Verificar arquivos de configuração do sistema e arquivos ocultos
A) Verificar arquivos de configuração de rede:

Confira os arquivos de configuração de rede e serviços de acesso remoto. A presença de configurações maliciosas, como serviços SSH alterados, pode ser um sinal de backdoors.

    Arquivo de configuração do SSH:

cat /etc/ssh/sshd_config

Verifique se há linhas suspeitas, como:

    Portas de acesso não padrão.
    PermitRootLogin habilitado.
    AllowUsers configurado com usuários não reconhecidos.

B) Verificar arquivos de configuração do sistema:

Pesquise por arquivos de configuração que foram alterados recentemente, pois eles podem indicar a instalação de um backdoor.

find /etc -type f -mtime -7

Isso listará os arquivos no diretório /etc que foram modificados nos últimos 7 dias. Isso pode ser útil para detectar alterações recentes feitas por um invasor.
C) Verificar arquivos ocultos:

Verifique os arquivos ocultos no diretório home de cada usuário, pois backdoors podem ser armazenados em arquivos que começam com um ponto (.).

ls -la /home/username/

Substitua username pelo nome de usuário que você está investigando. Procure por arquivos ou diretórios suspeitos.
5. Verificar logs do sistema

Verifique os logs do sistema para detectar atividades incomuns ou tentativas de acesso não autorizado.
A) Verificar logs de autenticação:

cat /var/log/auth.log

Verifique por tentativas de login suspeitas, como:

    Falhas de login repetidas.
    Logins realizados por usuários desconhecidos.
    Conexões SSH incomuns.

B) Verificar logs do sistema em geral:

cat /var/log/syslog
cat /var/log/messages

Esses arquivos contêm mensagens do sistema e podem mostrar atividades suspeitas, como a instalação de pacotes ou mudanças no sistema.
6. Verificar integridade do sistema
A) Usar ferramentas de verificação de integridade:

Ferramentas como AIDE (Advanced Intrusion Detection Environment) podem ser usadas para verificar a integridade dos arquivos do sistema e detectar alterações inesperadas.

Para instalar o AIDE:

sudo apt-get install aide

Depois de instalado, você pode inicializar a base de dados de integridade:

sudo aideinit

Em seguida, execute a verificação:

sudo aide --check

B) Verificar pacotes instalados:

Verifique se há pacotes suspeitos ou não reconhecidos:

dpkg --list

7. Verificar Backdoors Comuns Instalados via Pacotes

Alguns backdoors são instalados por meio de pacotes maliciosos, como Bash Bunny, Netcat, ou outros scripts de shell que permitem o acesso remoto.

Você pode procurar por programas como nc, ncat, ou outros utilitários que podem ser usados para acessar remotamente o sistema:

which nc
which ncat

Se esses programas estiverem instalados e não forem necessários para o seu sistema, eles podem ser usados como backdoors.
8. Usar ferramentas de segurança

Existem algumas ferramentas e scanners que podem ajudá-lo a detectar backdoors:

    Chkrootkit: Uma ferramenta para detectar rootkits no sistema.

    Para instalar:

sudo apt-get install chkrootkit

E para rodar:

sudo chkrootkit

RKHunter: Outra ferramenta para detectar rootkits e backdoors.

Para instalar:

sudo apt-get install rkhunter

E para rodar:

    sudo rkhunter --check

Conclusão

Detectar backdoors no Ubuntu envolve uma combinação de monitoramento de processos, análise de logs, revisão de configurações de rede, verificação de pacotes instalados e a utilização de ferramentas específicas de segurança. Sempre mantenha seu sistema atualizado e use ferramentas de segurança para monitorar alterações no sistema. Se você identificar qualquer comportamento suspeito, é importante agir rapidamente, desinstalar pacotes desconhecidos, reverter configurações e até mesmo considerar uma reinstalação limpa do sistema se necessário.


O Ubuntu usa o UFW (Uncomplicated Firewall) como firewall padrão. O UFW é uma interface simplificada para o iptables, que é a ferramenta de filtragem de pacotes que realmente gerencia o tráfego de rede no Linux. O UFW foi projetado para ser fácil de usar, permitindo que usuários configurem regras de firewall de forma simples e rápida, sem a necessidade de lidar com a complexidade do iptables diretamente.
Características do UFW:

    Interface simples: O UFW foi desenvolvido para ser fácil de usar, tanto para iniciantes quanto para administradores experientes.
    Permissões por aplicativo: Ele permite que você defina regras de firewall baseadas em portas, IPs e até mesmo aplicativos (usando o nome do serviço).
    Modo ativo ou inativo: O UFW pode ser ativado ou desativado conforme necessário.

Como verificar se o UFW está ativado:

Para verificar o status do UFW, você pode usar o comando:

sudo ufw status

Se o UFW estiver ativo, você verá uma lista de regras configuradas.
Como ativar o UFW:

Se o UFW não estiver ativado, você pode ativá-lo com o seguinte comando:

sudo ufw enable

Isso ativará o firewall com as configurações padrão.
Como configurar o UFW:

Você pode configurar o UFW para permitir ou negar o tráfego de redes específicas e serviços.

    Permitir tráfego na porta 80 (HTTP):

sudo ufw allow 80/tcp

Bloquear tráfego na porta 22 (SSH):

sudo ufw deny 22/tcp

Permitir tráfego para um serviço específico (exemplo: Apache):

sudo ufw allow 'Apache Full'

Desativar o UFW:

    sudo ufw disable

Exemplo de configuração básica:

    Permitir tráfego na porta 22 (SSH):

sudo ufw allow 22/tcp

Permitir tráfego na porta 80 (HTTP):

sudo ufw allow 80/tcp

Bloquear tráfego na porta 23 (Telnet):

sudo ufw deny 23/tcp

Verificar o status após a configuração:

    sudo ufw status verbose

Conclusão:

O UFW é a solução padrão e recomendada para firewall no Ubuntu devido à sua simplicidade e facilidade de configuração. Para configurações mais avançadas, é possível usar diretamente o iptables, mas para a maioria dos usuários, o UFW oferece uma maneira simples e eficaz de proteger seu sistema contra acessos indesejados.
Você disse:
lista regras do UFW
O ChatGPT disse:

Para listar as regras configuradas no UFW (Uncomplicated Firewall) no Ubuntu, você pode usar o comando:

sudo ufw status

Este comando exibe uma lista de regras ativas e mostra quais portas estão abertas ou fechadas, bem como a direção do tráfego (permitido ou negado).

Se você quiser uma visualização mais detalhada das regras, incluindo as informações sobre o protocolo, pode usar o seguinte comando:

sudo ufw status verbose

Exemplo de saída do comando sudo ufw status verbose:

A saída pode ser algo como:

Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
80/tcp (v6)                ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)

Explicação da saída:

    Status: active: O UFW está ativo.
    As colunas seguintes mostram:
        To: A porta ou serviço de destino.
        Action: A ação configurada (ALLOW ou DENY).
        From: De onde o tráfego é permitido (pode ser um IP específico, "Anywhere" para qualquer lugar ou "Anywhere (v6)" para conexões IPv6).

Visualização de regras de entrada e saída:

Se você deseja ver regras de entrada e saída separadas, o UFW não fornece diretamente esse nível de detalhamento. No entanto, o ufw status pode ser útil para você saber rapidamente as permissões e bloqueios básicos, e você pode detalhar mais se precisar.
Verificando as regras diretamente no arquivo:

Embora o comando ufw status seja o mais comum, as regras configuradas também estão armazenadas em arquivos de configuração. Se quiser olhar diretamente, os arquivos relevantes para o UFW estão localizados em:

    Regras de configuração do UFW: /etc/ufw/user.rules
    Regras de configuração para IPv6: /etc/ufw/user6.rules

Se você precisar editar ou visualizar essas regras manualmente, pode abrir esses arquivos com um editor de texto, como o nano:

sudo nano /etc/ufw/user.rules

Conclusão:

O comando sudo ufw status é a maneira mais fácil de listar as regras ativas do firewall no Ubuntu. Para informações mais detalhadas, você pode usar sudo ufw status verbose, que mostra mais detalhes sobre as portas e protocolos configurados. Se necessário, você pode também acessar os arquivos de configuração para ver as regras definidas diretamente.


Verificar Usuário logado

O comando: w você pode verificar quais usuários estão conectados

O comando  smbstatus também mostra os usuários logados na rede samba


Ubuntu


    Concurso de popularidade do Ubuntu - envia informações de software para o Canonical.

    Relatório do Ubuntu - envia informações de hardware para o Canonical.

    Ubuntu Whoopsie - envia relatórios de falhas - conecta-se aos servidores do Canonical na inicialização.

    Serviço de notícias motd do Ubuntu - envia informações, recebe notícias/anúncios motd.

    Serviço geoclue/geoip do Ubuntu. - conecta-se aos servidores do Canonical na inicialização.

    Ubuntu kerneloops - um programa que coleta informações de falhas do kernel
    e então envia a assinatura extraída para o site kerneloops.org.
    para análise estatística e apresentação aos desenvolvedores do kernel Linux.


https://ubuntu.com/legal/data-privacy

