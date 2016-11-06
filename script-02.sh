#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 26/09/2016
# Versão: 0.6
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
# Melhor anti-vírus para GNU/Linux, indicação:
# Shopos Antivirus for GNU/Linux
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
					 echo -e "Aguarde..."
					 echo 
					 echo -e "Rodando o Script-02.sh em: `date`" > $LOG
					 
					 echo -e "Atualizando as Listas do Apt-Get" >> $LOG
					 echo -e "Atualizando as Listas do Apt-Get"
					 #Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND=noninteractive
					 #Atualizando as listas do apt-get
					 apt-get update &>> $LOG
					 echo -e "Listas Atualizadas com Sucesso!!!"
					 echo
					 echo -e "Listas Atualizadas com Sucesso!!!" >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o Sistema" >> $LOG
					 echo -e "Atualizando o Sistema"
					 #Fazendo a atualização de todos os pacotes instalados no servidor
					 apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
					 echo -e "Sistema Atualizado com Sucesso!!!"
					 echo
					 echo -e "Sistema Atualizado com Sucesso!!!" >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Instalação do SAMBA-4, CUPS, DHCP, QUOTA, BIND-DNS e CLAMAV" >> $LOG
					 echo -e "Instalação do SAMBA-4, CUPS, DHCP, QUOTA, BIND-DNS e CLAMAV"
					 #Instalando os principais pacotes para o funcionamento correto dos serviços de rede
					 apt-get -y install samba samba-common smbclient cifs-utils samba-vfs-modules samba-testsuite samba-dbg samba-dsdb-modules cups cups-bsd cups-common cups-core-drivers cups-pdf isc-dhcp-server winbind quota quotatool ldb-tools libnss-winbind libpam-winbind nmap bind9 bind9utils clamav clamav-base clamav-daemon clamav-freshclam clamdscan clamfs clamav-testfiles clamav-unofficial-sigs arc cabextract p7zip unzip unrar libclamunrar7 kcc &>> $LOG
					 echo -e "Instalação dos Serviços de Rede Feito com Sucesso!!!"
					 echo
					 echo -e "Instalação dos Serviços de Rede Feito com Sucesso!!!" >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Limpando o Cache do Apt-Get" >> $LOG
					 echo -e "Limpando o Cache do Apt-Get"
					 #Limpando o diretório de cache do apt-get
					 apt-get clean &>> $LOG
					 echo -e "Cache Limpo com Sucesso!!!"
					 echo
					 echo -e "Cache Limpo com Sucesso!!!" >> $LOG
					 echo ============================================================ >> $LOG
					 
					 echo -e "Serviços atualizados com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando a Base de Vírus do ClamAV" >> $LOG
					 echo -e "Atualizando a Base de Vírus do ClamAV, aguarde esse processo demora alguns minutos..."
					 echo -e "Para verificar o andamento do download, digite em outro terminal o comando:"
					 echo -e "tail -f /var/log/script-02.log"
					 echo -e "Caso o processo demora mais que o previsto, execute os comandos:"
					 echo -e "ps -aux | grep freshclam"
					 echo -e "kill ID_PROCESSO_FRESHCLAM"
					 #Atualizando a base de dados de vírus do ClamAV, esse processo demora um pouco
					 freshclam &>> $LOG
					 echo -e "Base de dados atualizada com sucesso!!!"
					 echo
					 echo >> $LOG
					 
					 echo -e "Atualizando a Base de Vírus não Oficial do ClamAV" >> $LOG
					 echo -e "Atualizando a Base de Vírus do ClamAV não oficial, aguarde esse processo demora alguns minutos..."
					 echo -e "Para verificar o andamento do download, digite em outro terminal o comando:"
					 echo -e "tail -f /var/log/script-02.log"
					 echo -e "ps -aux | grep clamav-unofficial"
					 echo -e "kill ID_PROCESSO_CLAMAV-UNOFFICIAL"
					 #Atualizando a base de dados de vírus do ClamAV não Ofícial, esse processo demora um pouco
					 clamav-unofficial-sigs &>> $LOG
					 echo -e "Base de dados não oficial atualizada com sucesso!!!"
					 echo
					 echo >> $LOG
					 
					 echo -e "Inciando o Serviço do ClamAV-Daemon" >> $LOG
					 #Iniciando o serviço do ClamAV Antivírus
					 sudo service clamav-daemon start
					 
					 echo -e "Iniciando o Serviço do ClamAV-Freshclam" >> $LOG
					 #Iniciando o serviço do Freshclam que faz a atualização do ClamAV
					 sudo service clamav-freshclam start
					 
					 echo -e "Criando o diretório de quarentena" >> $LOG
					 #Criando o diretório para armazenar os arquivos com vírus
					 mkdir -v /backup/quarentena >> $LOG
					 echo >> $LOG
					 
					 echo -e "Base de dados de vírus atualizadas com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG
					 
					 echo -e "Agendando o scaneamento do diretório /arquivos" >> $LOG
					 echo -e "Agendamento do scaneamento do ClamAV no diretório /arquivos as 22:30hs, todos os dias"
					 echo -e "30 22  * * *    root     clamscan -r -i -v /arquivos --move=/backup/quarentena --log=/var/log/scan-arquivos.log"
					 echo
					 echo -e "Agendamento da atualização do Freshclam as 21:30hs, todos os dias"
					 echo -e "30 21  * * *    root     freshclam"
					 echo
					 echo -e "Editando o arquivo /etc/cron.d/clamav para acrescentar informações de agendamento do ClamAV"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Copiando o arquivo de agendamento do ClamAV
					 cp -v conf/clamav /etc/cron.d/ >> $LOG
					 #Copiando o arquivo de agendamento do Freshclam
					 cp -v conf/freshclam /etc/cron.d/ >> $LOG
					 #Editando o arquivo de agendamento de vírus do ClamAV
					 vim /etc/cron.d/clamav +14
					 echo -e "CLAMAV atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
					 read
					 sleep 3
					 clear
					 
					 echo -e "Editando o arquivo /etc/cron.d/freshclam para acrescentar informações de agendamento das atualizações"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Editando o arquivo de agendamento de atualização da base de dados do ClamAV
					 vim /etc/cron.d/freshclam +15
					 echo -e "FRESHCLAM atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
					 read
					 sleep 3
					 clear
					 
					 echo -e "Editando o arquivo /etc/cron.d/clamav-unofficial-sigs para acrescentar informações de agendamento do ClamAV"
					 echo -e "Alterar o tempo para 45 20 - 20:45hs"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 echo >> $LOG
					 #Fazendo o backup do arquivo de agendamento do ClamAV Não Oficial
					 mv -v /etc/cron.d/clamav-unofficial-sigs /etc/cron.d/clamav-unofficial-sigs.old >> $LOG
					 #Copiando o arquivo de agendamento do ClamAV Não Oficial
					 cp -v conf/clamav-unofficial-sigs /etc/cron.d/ >> $LOG
					 #Editando o arquivo de agendamento do ClamAV Não Oficial
					 vim /etc/cron.d/clamav-uno* +27
					 echo -e "Atualização feita com sucesso!!!" >> $LOG
					 echo -e "CLAMAV-UNOFFICIAL-SIGS atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
					 read
					 sleep 3
					 clear
					 
					 echo -e "Testando o Anti-Vírus ClamAV, utilizar o site: www.eicar.org"
					 echo -e "Baixando arquivos *.com e *.zip com o vírus: Eicar-Test-Signature"
					 echo -e "Movendo o conteúdo infectado para a quarentena em: /backup/quarentena"
					 echo
					 echo >> $LOG
					 #Fazendo o download do arquivo eicar.com e armazenando no diretório /arquivos
					 wget -c -P /arquivos http://www.eicar.org/download/eicar.com &>> $LOG
					 #Fazendo o download do arquivo eicar_com.txt e armazenando no diretório /arquivos
					 wget -c -P /arquivos http://www.eicar.org/download/eicar_com.txt &>> $LOG
					 #Copiando o arquivo eicar.com e criando um arquivo com extensão .bat
					 cp -v /arquivos/eicar.com /arquivos/eicar.bat >> $LOG
					 #Zipando o arquivo eicar.bat
					 bzip2 -v /arquivos/eicar.bat >> $LOG
					 echo
					 echo -e "Executando a verificação de vírus no diretório /arquivos"
					 echo
					 #Executando a varredurar de vírus no diretório /arquivos, caso encontre vírus, mover para o diretório /backup/quarentena
					 clamscan -r -i -v /arquivos --move=/backup/quarentena
					 echo
					 echo -e "Listando o contéudo do diretório /backup/quarentena"
					 #Listando o contéudo do diretório /backup/quarentena
					 ls -lha /backup/quarentena
					 echo
					 echo -e "Teste de analise vírus realizada com sucesso, pressione <Enter> para continuar o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Removendo o conteúdo infectado da quarentena em: /backup/quarentena"
					 echo
					 echo -e "Executanndo a remoção do vírus do diretório /backup/quarentena"
					 echo
					 #Verificando o diretório quarentena e removendo os vírus
					 clamscan -r -i -v /backup/quarentena --remove
					 echo
					 echo -e "Listando o contéudo do diretório /backup/quarentena"
					 echo
					 #Listando o conteúdo do diretório /backup/quarentena
					 ls -lha /backup/quarentena
					 echo
					 echo -e "Remoção do vírus realizada com sucesso!!!, pressione <Enter> para continuar o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o arquivo FSTAB" >> $LOG
					 echo -e "Editando o arquivo /etc/fstab para acrescentar as informações de Quota"
					 echo -e "Linha a ser editada no arquivo /etc/fstab"
					 echo -e "Sistemas de arquivos BTRFS o sistema de Quota e diferente, deixar o padrão"
					 echo -e "`cat -n /etc/fstab | sed -n '9p'`"
					 echo -e "Informações a serem acrescentadas depois de ext4: defaults,barrier=1,grpquota,usrquota"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 echo >> $LOG
					 #Editando o arquivo fstab
					 vim /etc/fstab
					 #Remontando a partição /arquivos com as novas opções de quota
					 mount -v -o remount /arquivos >> $LOG
					 #Habilitando o recurso de quota e criando os arquivos quota.user e quota.group
					 quotacheck -ugcv /arquivos &>> $LOG
					 echo -e "Atualização feita com sucesso!!!" >> $LOG
					 echo -e "FSTAB atualizado com sucesso!!!, continuando com o script"
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o arquivo NSSWITCH" >> $LOG
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
					 echo >> $LOG
					 #Fazendo o backup do arquivo de configuração do nsswitch.conf
					 mv -v /etc/nsswitch.conf /etc/nsswitch.conf.old >> $LOG
					 #Copiando o arquivo de configuração do nsswitch.conf
					 cp -v conf/nsswitch.conf /etc/nsswitch.conf >> $LOG
					 #Editando o arquivo de configuração do nsswitch.conf
					 vim /etc/nsswitch.conf
					 echo -e "Atualização feita com sucesso!!!" >> $LOG
					 echo -e "NSSWITCH atualizado com sucesso!!!, continuando com o script"
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o arquivo HOSTNAME" >> $LOG
					 echo -e "Editando o arquivo /etc/hostname para acrescentar as informações de FQDN"
					 echo -e "Linha a ser editada no arquivo /etc/hostname"
					 echo -e "`cat -n /etc/hostname`"
					 echo -e "Informações a serem acrescentadas depois de `hostname`: $FQDN"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 echo >> $LOG
					 #Fazendo o backup do arquivo de configuração hostname
					 mv -v /etc/hostname /etc/hostname.old >> $LOG
					 #Copiando o arquivo de configuração do hostname
					 cp -v conf/hostname /etc/hostname >> $LOG
					 #Editando o arquivo de configuração do hostname
					 vim /etc/hostname +13
					 echo -e "Atualização feita com sucesso!!!" >> $LOG
					 echo -e "HOSTNAME atualizado com sucesso!!!, continuando com o script"
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o arquivo HOSTS" >> $LOG
					 echo -e "Editando o arquivo /etc/hosts para acrescentar as informações de DNS Local"
					 echo -e "Linhas a serem editadas no arquivo /etc/hosts"
					 echo -e "`cat -n /etc/hosts | head -n3`"
					 echo -e "Informação a ser acrescentada na linha 03: 192.168.1.10 ptispo01dc01.pti.intra ptispo01dc01"
					 echo -e "Recomendo utilizar a tecla <TAB> para separar os valores"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 echo >> $LOG
					 #Fazendo o backup do arquivo de configuração do hosts
					 mv -v /etc/hosts /etc/hosts.old >> $LOG
					 #Copiando o arquivo de configuração do hosts
					 cp -v conf/hosts /etc/hosts >> $LOG
					 #Editando o arquivo de configuração do hosts
					 vim /etc/hosts +14
					 echo -e "Atualização feita com sucesso!!!" >> $LOG
					 echo -e "HOSTS atualizado com sucesso!!!, continuando com o script"
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o arquivo GRUB" >> $LOG
					 echo -e "Editando o arquivo /etc/defaults/grub para acrescentar as informações de Interface de Rede"
					 echo -e "Linhas a serem editadas no arquivo /etc/defaults/grub"
					 echo -e "`cat -n /etc/default/grub | sed -n '11p'`"
					 echo -e "Informação a ser acrescentada na variavel GRUB_CMDLINE_LINUX_DEFAULT: net.ifnames=0"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 echo >> $LOG
					 #Fazendo o backup do arquivo de configuração do grub
					 mv -v /etc/default/grub /etc/default/grub.old >> $LOG
					 #Copiando o arquivo de configuração do grub
					 cp -v conf/grub /etc/default/grub >> $LOG
					 #Editando o arquivo de configuração do grub
					 vim /etc/default/grub +24
					 echo >> $LOG
					 
					 echo -e "Desativando o Serviço do LXD-CONTAINERS" >> $LOG
					 echo -e "Desativando o Serviço do LXD-CONTAINERS"
					 #Desabilitando o serviço de LXD Containers que vem habilitado como padrão
					 systemctl disable lxd-containers.service &>> $LOG
					 echo -e "Serviço desabilitado com sucesso!!!"
					 echo
					 
					 echo -e "Desativando o CTRL+ALT+DEL" >> $LOG
					 echo -e "Desativando o CTRL+ALT+DEL"
					 #Desabilitando o recurso de pressione CTRL+ALT+DEL para reinicializar o servidor 
					 systemctl mask ctrl-alt-del.target &>> $LOG
					 #Restartando todos os serviços
					 systemctl daemon-reload &>> $LOG
					 echo -e "Serviço desabilitado com sucesso!!!"
					 echo
					 
					 echo -e "Atualizando o GRUB"
					 #Atualizando o grub com as novas modificações feitas no arquivo grub, atualizar Kernel e Initrd
					 update-grub &>> $LOG
					 echo -e "Atualização feita com sucesso!!!" >> $LOG
					 echo -e "GRUB atualizado com sucesso!!!, continuando com o script"
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o arquivo CUSPD.CONF" >> $LOG
					 echo -e "Editando o arquivo /etc/cups/cupsd.conf para liberar o acesso remoto"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 echo >> $LOG
					 #Fazendo o backup do arquivo de configuração do cupsd.conf
					 mv -v /etc/cups/cupsd.conf /etc/cups/cupsd.conf.old >> $LOG
					 #Copiando o arquivo de configuração do cupsd.conf
					 cp -v conf/cupsd.conf /etc/cups/cupsd.conf >> $LOG
					 #Editando o arquivo de configuração do cupsd.conf
					 vim /etc/cups/cupsd.conf
					 #Verificando informações de impressoras
					 lpinfo -vm >> $LOG
					 #Verificando os status das impressoras
					 lpstat -t >> $LOG
					 echo -e "Atualização feita com sucesso!!!" >> $LOG
					 echo -e "CUSPD.CONF atualizado com sucesso!!!, continuando com o script"
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