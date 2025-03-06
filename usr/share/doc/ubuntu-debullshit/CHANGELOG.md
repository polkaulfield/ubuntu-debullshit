# Changelog


## [1.0.1] - 2025-02-24
# 
# Fernando Souza - https://github.com/tuxslack/
# 

### Bug conhecido
-  Problema com o comando notify-send para enviar a notificação do usuário Root para um 
   usuário comum (Ex: BigLinux).

   Erro ao chamar a linha de comandos "dbus-launch --autolaunch=c0f819ea778135115579f38967c53b85 --binary-syntax --close-stderr": Processo filho concluiu com código 1


### Corrigido 
- Bloqueio de acesso a internet quando configurava o Firewall (ufw ou iptables) [conf_firewall].
- Problema com a tradução do idioma Inglês para o Português do Brasil.
- UFW - O firewall está desativado. Por favor, verifique a configuração [Firewall_UFW]. Começava o processo como ativado só que não final ficava como desativado. O "ufw enable" estava antes do "ufw reset"


### Adicionado
- Implementação do Yad no script.
- Melhorias na legibilidade do script (Algumas chamadas de "echo com o gettext" para garantir que sejam mais informativo).
- Notificações são enviadas de forma condicional (notify-send).
- Suporte para múltiplos idiomas (Inglês, Português).
- Verificação de internet somente nas partes de instalação de pacotes e na atualização do sistema.
- Verificação de programas instalados.
- Verifica se o arquivo /etc/default/motd-news existe.
- Nova opção chamada Ajuda adicionada ao menu principal.
- Verifica se a fonte Monospace está instalada.
- Verifica se os sites estão fora do ar.
- Verifica se as pastas existem.
- Verifica se os arquivos existem.
- Verifica se o usuário está utilizando o GNOME como ambiente de desktop.
- Verifica se a distribuição Linux é o Ubuntu.
- Parando o serviço do apport antes de remove o pacote.
- Desativar a Telemetria.
- Desativar a coleta de dados de pesquisa da Dash.
- Extrair os nomes dos arquivos que correspondem ao padrão adwaita-icon-theme*all.deb. Ex: adwaita-icon-theme_48~beta-3_all.deb.
- Corrigido o error sed: não é possível ler /etc/default/motd-news: arquivo ou diretório inexistente.
- Adicionado arquivo de log (/tmp/ubuntu-debullshit.log) para erros.
- Desinstale o GNOME Online Accounts (Integração com contas online Ex: Google Drive, e-mail, calendário).
- Remove "Lojas de Software" e atualizador (ubuntu-software, gnome-software, software-properties-gtk, update-manager).
- Remove serviço de localização (Geoclue).
- Desativa o Histórico de Arquivos (pesquisa do GNOME Shell).
- Desativa as animações da interface gráfica GNOME [desligar os efeitos visuais].
- Desativa as atualizações automáticas.
- Desativa todas as extensões do GNOME de uma vez.
- Desativa os espaços de trabalho dinâmico colocando em estáticos no GNOME (fixa somente 2 espaços de trabalho).
- Desativa programas que iniciam com o sistema (Ex: Bluetooth, serviço de impressão - cups, servidor web - Apache, serviço Snap).
- Remover PPA (Personal Package Archive) do sistema [EM FACE DE TESTE].
- Restaurar Interface Gnome (via dconf e removendo pastas).
- Verificar qual o servidor de repositório mais rápido.
- Configura o Firewall - ufw (Uncomplicated Firewall) ou iptables.
- Atualiza o sistema de forma manual.
- Executa ações especificas para determinadas versões do Ubuntu.




## [1.0.0] - 2024-04-19
# 
## polkaulfield - https://github.com/polkaulfield
# 
### Adicionado
- Lançamento inicial do programa.
- Funcionalidade básica usando somente o terminal.

