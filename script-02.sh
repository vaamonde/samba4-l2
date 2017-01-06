#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 30/12/2016
# Versão: 0.8
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Instalação dos pacotes principais para a terceira etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# SAMBA4 (Server Message Block) Serviço de Armazenamento e Gerenciamento de Arquivos e Usuários
# DNS (Domain Name System) Serviço de Domínio de Nomes
# CUPS (Common Unix Printing System) Serviços de Impressão
# DHCP (Dynamic Host Configuration Protocol) Configuração Dinâmica de Computadores
# WINBIND Integração SAMBA4 + Linux
# QUOTA Criação de Quotas de Discos
# CLAMAV - sistema de anti-vírus
#
# Após o reboot fazer as mudanças do arquivo /etc/nsswitch.conf para suportar a autenticação via Winbind
#	vim /etc/nsswitch.conf
#	passwd:		files compat winbind
#	group:		files compat winbind
#	shadown:	files compat winbind
#	hosts:		files dns mdns4_minimal [NOTFOUND=return]
#
# Configurações de suporte a Quota, Acl e Xattr no rquivo /etc/fstab
# Utilizar essas configuração apenas para o sistema de arquivos EXT4
# Se tiver utilizando o BTRFS deixar o padrão
#
#	vim /etc/fstab
#	defaults,barrier=1,grpquota,usrquota
#
# Comando para confirmar as modificações feitas no FSTAB
#	tune2fs -l /dev/sda6 | grep "Default mount options:"
#
# Editando o arquivo /etc/hostname para acrescentar o FQDN
#	vim /etc/hostname
#	ptispo01dc01.pti.intra
#
# Editando o arquivo /etc/hosts
#	vim /etc/hosts
#	192.168.1.10	ptispo01dc01.pti.intra	ptispo01dc01
#
# Editando o arquivo /etc/defaults/grub
#	GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0" 
#	update-grub
#
# Atualizando o ClamAV
#	freshclam
#	service clamav-daemon start
#	service clamav-freshclam start
#
# Melhor anti-vírus para GNU/Linux, indicação: Shopos Antivirus for GNU/Linux
# Download: https://www.sophos.com/en-us/products/free-tools/sophos-antivirus-for-linux.aspx
# Instalação: https://www.sophos.com/en-us/support/knowledgebase/14378.aspx
# No Level-3 estarei utilizando ele nas configurações
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-02.sh
LOG="/var/log/script-02.log"
#
# Variável da Data Inicial para calcular tempo de execução do Script
DATAINICIAL=`date +%s`
#
# Validando o ambiente, verificando se o usuário e "root"
USUARIO=`id -u`
UBUNTU=`lsb_release -rs`
KERNEL=`uname -r | cut -d'.' -f1,2`

if [ "$USUARIO" == "0" ]
then
	if [ "$UBUNTU" == "16.04" ]
		then
			if [ "$KERNEL" == "4.4" ]
				then		
					 clear
					 # Exportação da variável de configuração
					 FQDN=".pti.intra"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-02.sh"
					 echo
					 echo -e "Instalação dos software: SAMBA4, DNS, CUPS, DHCP, WINBIND e QUOTA"
					 echo
					 echo -e "SAMBA4 (Server Message Block) Serviço de Armazenamento e Gerenciamento de Arquivos e Usuários"
					 echo -e "DNS (Domain Name System) Serviço de Domínio de Nomes"
					 echo -e "CUPS (Common Unix Printing System) Serviços de Impressão"
					 echo -e "Para testar o CUPS após a instalação acesse a URL: http://`hostname -I`:631"
					 echo -e "DHCP (Dynamic Host Configuration Protocol) Configuração Dinâmica de Computadores"
					 echo -e "WINBIND Integração SAMBA + Linux"
					 echo -e "QUOTA Criação de Quotas de Discos"
					 echo -e "CLAMAV Sistema de Anti-Vírus Open Source"
					 echo -e "Configuração do FSTAB para suporte a Quota"
					 echo -e "Configuração do NSSWITCH para suporte a Winbind"
					 echo -e "Configuração do CLAMAV para suporte a Anti-vírus"
					 echo -e "Configuração do HOSTNAME para suporte a FQDN"
					 echo -e "Configuração do HOSTS para suporte a DNS local"
					 echo -e "Configuração do GRUB para ativar o recurso de Alias de Rede"
					 echo -e "Configuração do CUPS para suporte a configuração remota"
					 echo
					 echo -e "Aguarde..."
					 echo 
					 echo -e "Rodando o Script-02.sh em: `date`" > $LOG
					 
					 echo -e "Atualizando as Listas do Apt-Get (apt-get update)"
					 #Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND=noninteractive
					 #Atualizando as listas do apt-get
					 apt-get update &>> $LOG
					 echo -e "Listas Atualizadas com Sucesso!!!"
					 echo
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando os Software instlados (apt-get upgrade)"
					 #Fazendo a atualização de todos os pacotes instalados no servidor
					 apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
					 echo -e "Sistema Atualizado com Sucesso!!!"
					 echo
					 echo ============================================================ >> $LOG

					 echo -e "Instalação do SAMBA-4, CUPS, DHCP, QUOTA, BIND-DNS e CLAMAV e suas dependências, aguarde..."
					 #Instalando os principais pacotes para o funcionamento correto dos serviços de rede
					 apt-get -y install samba samba-common smbclient cifs-utils samba-vfs-modules samba-testsuite samba-dbg samba-dsdb-modules cups cups-bsd cups-common cups-core-drivers cups-pdf printer-driver-gutenprint printer-driver-hpcups hplip antiword docx2txt gutenprint-doc gutenprint-locales isc-dhcp-server winbind quota quotatool ldb-tools libnss-winbind libpam-winbind nmap bind9 bind9utils clamav clamav-base clamav-daemon clamav-freshclam clamdscan clamfs clamav-testfiles clamav-unofficial-sigs arc cabextract p7zip unzip unrar libclamunrar7 kcc tree &>> $LOG
					 echo -e "Instalação dos Serviços de Rede Feito com Sucesso!!!"
					 echo
					 echo ============================================================ >> $LOG 

					 echo -e "Limpando o Cache do Apt-Get (apt-get autoremove && apt-get autoclean && apt-get clean)"
					 #Limpando o diretório de cache do apt-get
					 apt-get -y autoremove &>> $LOG
					 apt-get -y autoclean &>> $LOG
					 apt-get -y clean &>> $LOG
					 echo -e "Cache Limpo com Sucesso!!!"
					 echo
					 echo ============================================================ >> $LOG
					 
					 echo -e "Serviços instalados/atualizados com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando a Base de Vírus do ClamAV, aguarde esse processo demora alguns minutos..."
					 echo
					 echo -e "Para verificar o andamento do download, digite em outro terminal o comando:"
					 echo -e "tail -f /var/log/script-02.log"
					 echo
					 echo -e "Caso o processo demora mais que o previsto, execute os comandos:"
					 echo -e "ps -aux | grep freshclam"
					 echo -e "kill ID_PROCESSO_FRESHCLAM"
					 #Atualizando a base de dados de vírus do ClamAV, esse processo demora um pouco
					 freshclam &>> $LOG
					 echo
					 echo -e "Base de dados atualizada com sucesso!!!"
					 echo
					 
					 echo -e "Atualizando a Base de Vírus do ClamAV não oficial, aguarde esse processo demora alguns minutos..."
					 echo
					 echo -e "Para verificar o andamento do download, digite em outro terminal o comando:"
					 echo -e "tail -f /var/log/script-02.log"
					 echo -e "ps -aux | grep clamav-unofficial"
					 echo -e "kill ID_PROCESSO_CLAMAV-UNOFFICIAL"
					 #Atualizando a base de dados de vírus do ClamAV não Ofícial, esse processo demora um pouco
					 clamav-unofficial-sigs &>> $LOG
					 echo
					 echo -e "Base de dados não oficial atualizada com sucesso!!!"
					 echo
					 
					 echo -e "Iniciando o Serviço do ClamAV-Daemon"
					 #Iniciando o serviço do ClamAV Antivírus
					 sudo service clamav-daemon restart
					 
					 echo -e "Iniciando o Serviço do ClamAV-Freshclam"
					 #Iniciando o serviço do Freshclam que faz a atualização do ClamAV
					 sudo service clamav-freshclam restart
					 
					 echo -e "Serviços reiniciados com sucesso!!!"
					 sleep 2
					 echo 
					 
					 echo -e "Criando o diretório de quarentena"
					 #Criando o diretório para armazenar os arquivos com vírus
					 mkdir -v /backup/quarentena >> $LOG
					 echo -e "Diretório de quarentena criado com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Base de dados de vírus atualizadas com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG
					 
					 echo -e "Agendamento do scaneamento do ClamAV no diretório /arquivos ás 22:30hs, todos os dias"
					 echo -e "30 22  * * *    root     clamscan -r -i -v /arquivos --move=/backup/quarentena --log=/var/log/scan-arquivos.log"
					 echo
					 echo -e "Agendamento das atualizações do Freshclam ás 21:30hs, todos os dias"
					 echo -e "30 21  * * *    root     freshclam"
					 echo
					 echo -e "Editando o arquivo /etc/cron.d/clamav para acrescentar informações de agendamento do ClamAV"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 sleep 2
					 
					 echo -e "Copiando o arquivo de agendamento do clamav para diretório do cron.d"
					 #Copiando o arquivo de agendamento do ClamAV
					 cp -v conf/clamav /etc/cron.d/ >> $LOG
					 echo -e "Arquivo copiado com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Copiando o arquivo de agendamento do freshclam para diretório do cron.d"
					 #Copiando o arquivo de agendamento do Freshclam
					 cp -v conf/freshclam /etc/cron.d/ >> $LOG
					 echo -e "Arquivo copiado com sucesso!!!"
					 sleep 2
					 echo 
					 
					 #Editando o arquivo de agendamento de vírus do ClamAV
					 vim /etc/cron.d/clamav +14
					 echo -e "CLAMAV atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo /etc/cron.d/freshclam para acrescentar informações de agendamento das atualizações"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Editando o arquivo de agendamento de atualização da base de dados do ClamAV
					 vim /etc/cron.d/freshclam +15
					 echo -e "FRESHCLAM atualizado com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo /etc/cron.d/clamav-unofficial-sigs para acrescentar informações de agendamento do ClamAV"
					 echo -e "Alterar o tempo para 45 20 - 20:45hs"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 echo
					 
					 echo -e "Fazendo backup do arquivo de agendamento do clamav-unofficial-sigs para diretório do cron.d"
					 #Fazendo o backup do arquivo de agendamento do ClamAV Não Oficial
					 mv -v /etc/cron.d/clamav-unofficial-sigs /etc/cron.d/clamav-unofficial-sigs.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Copiando o arquivo de agendamento do clamav-unofficial-sigs para diretório do cron.d"
					 #Copiando o arquivo de agendamento do ClamAV Não Oficial
					 cp -v conf/clamav-unofficial-sigs /etc/cron.d/ >> $LOG
					 echo -e "Copia feita com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de agendamento do ClamAV Não Oficial
					 vim /etc/cron.d/clamav-uno* +27
					 echo -e "CLAMAV-UNOFFICIAL-SIGS atualizado com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 3
					 clear
					 
					 echo -e "Testando o Anti-Vírus ClamAV, utilizando o site: www.eicar.org"
					 echo
					 echo -e "Baixando arquivos *.com e *.zip com o vírus: Eicar-Test-Signature"
					 echo
					 echo -e "Movendo o conteúdo infectado para a quarentena em: /backup/quarentena"
					 echo
					 
					 echo -e "Fazendo o download do arquivo eicar.com"
					 #Fazendo o download do arquivo eicar.com e armazenando no diretório /arquivos
					 wget -c -P /arquivos http://www.eicar.org/download/eicar.com &>> $LOG
					 echo -e "Download feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Fazendo o download do arquivo eicar_com.txt"
					 #Fazendo o download do arquivo eicar_com.txt e armazenando no diretório /arquivos
					 wget -c -P /arquivos http://www.eicar.org/download/eicar_com.txt &>> $LOG
					 echo -e "Download feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Copiando o arquivo eicar.com para diretório /arquivos alterando sua extensão para .bat"
					 #Copiando o arquivo eicar.com e criando um arquivo com extensão .bat
					 cp -v /arquivos/eicar.com /arquivos/eicar.bat &>> $LOG
					 echo -e "Arquivo copiado com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Zipando o arquivo eicar.com"
					 #Zipando o arquivo eicar.bat
					 bzip2 -v /arquivos/eicar.bat &>> $LOG
					 echo -e "Arquivo zipado com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Executando a verificação de vírus no diretório /arquivos"
					 echo
					 #Executando a varredurar de vírus no diretório /arquivos, caso encontre vírus, mover para o diretório /backup/quarentena
					 clamscan -r -i -v /arquivos --move=/backup/quarentena
					 sleep 2
					 echo
					 
					 echo -e "Listando o contéudo do diretório /backup/quarentena"
					 #Listando o contéudo do diretório /backup/quarentena
					 ls -lha /backup/quarentena
					 sleep 3
					 echo
					 
					 echo -e "Teste de análise vírus realizada com sucesso!!!, pressione <Enter> para continuar o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Removendo o conteúdo infectado da quarentena em: /backup/quarentena"
					 echo
					 echo -e "Executanndo a remoção do vírus do diretório /backup/quarentena"
					 echo
					 #Verificando o diretório quarentena e removendo os vírus
					 clamscan -r -i -v /backup/quarentena --remove
					 sleep 3
					 echo
					 
					 echo -e "Listando o contéudo do diretório /backup/quarentena"
					 echo
					 #Listando o conteúdo do diretório /backup/quarentena
					 ls -lha /backup/quarentena
					 sleep 2
					 echo
					 
					 echo -e "Remoção do vírus realizada com sucesso!!!, pressione <Enter> para continuar o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Editando o arquivo /etc/fstab para acrescentar as informações de Quota"
					 echo -e "Sistemas de arquivos BTRFS o sistema de Quota e diferente, deixar o padrão"
					 echo
					 echo -e "Linha a ser editada no arquivo /etc/fstab"
					 echo
					 echo -e "`cat -n /etc/fstab | sed -n '9p'`"
					 echo
					 echo -e "Informações a serem acrescentadas depois de ext4: defaults,barrier=1,grpquota,usrquota"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 
					 echo -e "Fazendo o backup do arquivo fstab"
					 cp -v /etc/fstab /etc/fstab.old.1 &>> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo fstab
					 vim /etc/fstab
					 sleep 2
					 echo
					 
					 echo -e "Remontando o ponto de montagem: /arquivos"
					 #Remontando a partição /arquivos com as novas opções de quota
					 mount -v -o remount /arquivos &>> $LOG
					 echo -e "Remontagem feita com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Habilitando os recursos de quota de disco no ponto de montagem /arquivos"
					 #Habilitando o recurso de quota e criando os arquivos quota.user e quota.group
					 quotacheck -ugcv /arquivos &>> $LOG
					 echo -e "Quota habilitada com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "FSTAB atualizado com sucesso!!!, Pressione <Enter> continuando com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Editando o arquivo /etc/nsswitch.conf para acrescentar as informações de Winbind"
					 echo
					 echo -e "Linhas a serem editadas no arquivo /etc/nsswitch.conf"
					 echo -e "`cat -n /etc/nsswitch.conf | head -n9 | tail -n3`"
					 echo
					 echo -e "Informações a serem acrescentadas depois de compact: winbind"
					 echo -e "Linha a ser editada no arquivo /etc/nsswitch.conf"
					 echo -e "`cat -n /etc/nsswitch.conf | head -n12 | tail -n1`"
					 echo
					 echo -e "Informações a serem alteradas depois de files: dns mdns4_minimal [NOTFOUND-RETURN]"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 
					 echo -e "Fazendo o backup do arquivo nsswitch.conf"
					 #Fazendo o backup do arquivo de configuração do nsswitch.conf
					 mv -v /etc/nsswitch.conf /etc/nsswitch.conf.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo nsswitch.conf"
					 #Copiando o arquivo de configuração do nsswitch.conf
					 cp -v conf/nsswitch.conf /etc/nsswitch.conf >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração do nsswitch.conf
					 vim /etc/nsswitch.conf
					 echo -e "NSSWITCH.CONF atualizado com sucesso!!!, Pressione <Enter> continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Editando o arquivo /etc/hostname para acrescentar as informações de FQDN"
					 echo
					 echo -e "Linha a ser editada no arquivo /etc/hostname"
					 echo -e "`cat -n /etc/hostname`"
					 echo
					 echo -e "Informações a serem acrescentadas depois de `hostname`: $FQDN"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 
					 echo -e "Fazendo o backup do arquivo hostname"
					 #Fazendo o backup do arquivo de configuração hostname
					 mv -v /etc/hostname /etc/hostname.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo hostname"
					 #Copiando o arquivo de configuração do hostname
					 cp -v conf/hostname /etc/hostname >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração do hostname
					 vim /etc/hostname +13
					 echo -e "HOSTNAME atualizado com sucesso!!!, Pressione <Enter> continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Editando o arquivo /etc/hosts para acrescentar as informações de DNS Local"
					 echo
					 echo -e "Linhas a serem editadas no arquivo /etc/hosts"
					 echo -e "`cat -n /etc/hosts | head -n3`"
					 echo
					 echo -e "Informação a ser acrescentadas na linha 03: 192.168.1.10 ptispo01dc01.pti.intra ptispo01dc01"
					 echo
					 echo -e "Recomendo utilizar a tecla <TAB> para separar os valores"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 
					 echo -e "Fazendo o backup do arquivo hosts"
					 #Fazendo o backup do arquivo de configuração do hosts
					 mv -v /etc/hosts /etc/hosts.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo hosts"
					 #Copiando o arquivo de configuração do hosts
					 cp -v conf/hosts /etc/hosts >> $LOG
					 echo -e "Arquivos atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração do hosts
					 vim /etc/hosts +14
					 echo -e "HOSTS atualizado com sucesso!!!, Pressione <Enter> continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Editando o arquivo /etc/defaults/grub para acrescentar as informações de Interface de Rede"
					 echo
					 echo -e "Linhas a serem editadas no arquivo /etc/defaults/grub"
					 echo -e "`cat -n /etc/default/grub | sed -n '11p'`"
					 echo
					 echo -e "Informação a ser acrescentada na variavel GRUB_CMDLINE_LINUX_DEFAULT: net.ifnames=0"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 
					 echo -e "Fazendo o backup do arquivo grub"
					 #Fazendo o backup do arquivo de configuração do grub
					 mv -v /etc/default/grub /etc/default/grub.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo do grub"
					 #Copiando o arquivo de configuração do grub
					 cp -v conf/grub /etc/default/grub >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração do grub
					 vim /etc/default/grub +24
					 sleep 2
					 echo
					 
					 echo -e "Desativando o Serviço do LXD-CONTAINERS"
					 #Desabilitando o serviço de LXD Containers que vem habilitado como padrão
					 systemctl disable lxd-containers.service &>> $LOG
					 echo -e "Serviço desabilitado com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Desativando o CTRL+ALT+DEL (para não reinicializar o servidor)"
					 #Desabilitando o recurso de pressione CTRL+ALT+DEL para reinicializar o servidor 
					 systemctl mask ctrl-alt-del.target &>> $LOG
					 #Restartando todos os serviços
					 systemctl daemon-reload &>> $LOG
					 echo -e "Serviço desabilitado com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o GRUB"
					 #Atualizando o grub com as novas modificações feitas no arquivo grub, atualizar Kernel e Initrd
					 update-grub &>> $LOG
					 echo -e "Atualização feita com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "GRUB atualizado com sucesso!!!, Pressione <Enter> continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Editando o arquivo /etc/cups/cupsd.conf para liberar o acesso remoto"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 
					 echo -e "Fazendo o backup do arquivo do cupsd.conf"
					 #Fazendo o backup do arquivo de configuração do cupsd.conf
					 mv -v /etc/cups/cupsd.conf /etc/cups/cupsd.conf.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo do cupsd.conf"
					 #Copiando o arquivo de configuração do cupsd.conf
					 cp -v conf/cupsd.conf /etc/cups/cupsd.conf >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração do cupsd.conf
					 vim /etc/cups/cupsd.conf
					 
					 #Verificando informações de impressoras
					 lpinfo -vm >> $LOG
					 #Verificando os status das impressoras
					 lpstat -t >> $LOG
					 echo
					 
					 echo -e "Testando as configurações do arquivo: cupsd.conf"
					 #Testando as configurações do arquivo cupsd.conf
					 cupsd -t
					 echo -e "Configurações testadas com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "CUPSD.CONF atualizado com sucesso!!!, Pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG
					 
					 echo -e "Atualizando é editando arquivo CUPS-PDF.CONF, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 
					 echo -e "Fazendo o backup do arquivo cups-pdf.conf"
					 #Fazendo o backup do arquivo original
					 mv -v /etc/cups/cups-pdf.conf /etc/cups/cups-pdf.conf.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo do cups-pdf.conf"
					 #Atualizando o arquivo
					 cp -v conf/cups-pdf.conf /etc/cups/cups-pdf.conf >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo CUPS-PDF
					 vim /etc/cups/cups-pdf.conf
					 sleep 2
					 echo
					 
					 echo -e "Reinicializando os serviços do CUPS"
					 #Reinicializando os serviços do CUPS
					 sudo service cups restart
					 sudo service cups-browsed restart
					 echo -e "Serviços reinicializados com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Arquivos atualizandos com sucesso!!! pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG
					 
					 echo -e "Atualizando é editando arquivo USR.SBIN.CUPSD, pressione <Enter> para continuar"
					 read
					 sleep 2
					 
					 echo -e "Fazendo o backup do arquivo usr.sbin.cupsd"
					 #Fazendo o backup do arquivo original
					 mv -v /etc/apparmor.d/usr.sbin.cupsd /etc/apparmor.d/usr.sbin.cupsd.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo usr.sbin.cupsd"
					 #Atualizando o arquivo
					 cp -v conf/usr.sbin.cupsd /etc/apparmor.d/usr.sbin.cupsd >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo CUPS-PDF
					 vim /etc/apparmor.d/usr.sbin.cupsd +183
					 sleep 2
					 echo
					 
					 echo -e "Reinicializando os serviços do CUPS e do APPARMOR"
					 #Reinicializando os serviços do CUPS
					 sudo service apparmor restart
					 sudo service cups restart
					 sudo service cups-browsed restart
					 echo -e "Serviços reinicializados com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Arquivos atualizandos com sucesso!!! pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 
					 echo -e "Fim do Script-02.sh em: `date`" >> $LOG

					 echo
					 echo -e "Instalação dos Servicos de Rede Feito com Sucesso!!!!!"
					 echo
					 # Script para calcular o tempo gasto para a execução do script-02.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-02.sh: $TEMPO"
					 echo -e "Pressione <Enter> para concluir o processo."
					 read
					 else
						 echo -e "Versão do Kernel: $KERNEL não homologada para esse script, versão: >= 4.4 "
						 echo -e "Pressione <Enter> para finalizar o script"
					 read
			fi
		else
			 echo -e "Distribuição GNU/Linux: `lsb_release -is` não homologada para esse script, versão: $UBUNTU"
			 echo -e "Pressione <Enter> para finalizar o script"
			 read
		fi
else
	 echo -e "Usuário não é ROOT, execute o comando com a opção: sudo -i <Enter> depois digite a senha do usuário `whoami`"
	 echo -e "Pressione <Enter> para finalizar o script"
	read
fi
