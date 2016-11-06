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
# Troubleshooting dos serviços de rede da oitava etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# Criação da Zona Reversa do DNS
#
# Atualização dos ponteiros do DNS
#
# Criação da atualização do DNS no CRON
#
# Permissões de Acesso a Disco e Impressoras
#
# SeDiskOperatorPrivilege
# SePrintOperatorPrivilege
#
# Configuração da Integração do SAMBA4 com o DNS e DHCP para atualizaçoes dinâmicas de registros
#
# AppArmor configurações:
# r = permissões de leitura
# w = permissões de gravação
# k = permissões de lock
# m = ativação da flag PROT_EXEC
# Mais informações: http://manpages.ubuntu.com/manpages/xenial/en/man5/apparmor.d.5.html
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-07.sh
LOG="/var/log/script-07.log"
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
					 # Variáveis de configuração para o troubleshooting
					 USER="administrator"
					 DOMAIN="pti.intra"
					 PASSWORD="pti@2016"
					 HOSTNAME="`hostname -s`"
					 FQDN="`hostname`"
					 IP="192.168.1.10"
					 ARPA="1.168.192.in-addr.arpa"
					 ARPAIP="10"
					 DHCPDUSER="dhcp"
					 REALM="PTI.INTRA"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-07.sh"
					 echo
					 echo -e "Criando a Zona de Pesquisa Reversa"
					 echo -e "Adicionando os Ponteiros na Zona de Pesquisa Reversa"
					 echo -e "Atualizando os Registro de DNS do SAMBA4"
					 echo -e "Criando as permissões de Gerenciamento de Disco e Impressoras"
					 echo -e "Rodando o Script-07.sh em: `date`" > $LOG
					 echo >> $LOG
					 echo

					 echo -e "Verificando se os serviços do AppArmor e BIND estão rodando corretamente"
					 echo -e "Serviço do AppArmor = Status: Active (exited)"
					 #Verificando o status do serviço do AppAmor
					 sudo service apparmor status | grep -e active
					 echo 
					 echo -e "Serviço do BIND9 DNS = Status: Active (running)"
					 #Verificando o status do serviço do Bind9 DNS Server
					 sudo service bind9 status | grep -e active
					 echo
					 echo -e "Serviço do SAMBA4-AD-DC = Status: Active (running)"
					 #Verificando o status do serviço do SAMBA-4 Active Directory Domain Controller
					 sudo service samba-ad-dc status | grep -e active
					 echo
					 echo -e "Caso algum serviço esteja com falha, analisar os arquivos de configurações do script-06.sh"
					 echo -e "Cancele a execução do Script-07.sh pressionando: Ctrl+C ou Ctrl+Z"
					 echo -e "Execute: sudo service apparmor restart && sudo serviço bind9 restart"
					 echo -e "Volte a executar o script-07.sh"
					 echo
					 echo -e "Pressione <Enter> para continuar com o Script caso os Status esteja correto"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Criando a Zona Reversa para o servidor: `hostname`" >> $LOG
					 echo -e "Criando a Zona Reversa para o servidor: `hostname`"
					 #Criando a Zona de Pesquisa Reversar utilizando o comando samba-tool
					 samba-tool dns zonecreate $DOMAIN $ARPA -U $USER --password=$PASSWORD &>> $LOG
					 echo -e "Zona Reversa criada com sucesso!!!!" >> $LOG
					 echo -e "Zona Reversa criada com sucesso!!!!"
					 echo
					 echo >> $LOG
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Criando o Ponteiro na Zona Reversa para o servidor: `hostname`" >> $LOG
					 echo -e "Criando o Ponteiro na Zona Reversa para o servidor: `hostname`"
					 #Criando o Ponteiro do endereço IP do Servidor na Zona de Pesquisa Reversar utilizando o comando samba-tool
					 samba-tool dns add $DOMAIN $ARPA $ARPAIP PTR $FQDN -U $USER --password=$PASSWORD &>> $LOG
					 echo -e "Ponteiro criado com sucesso!!!!"
					 echo -e "Ponteiro criado com sucesso!!!!" >> $LOG
					 echo
					 echo -e "Ponteiro criado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo >> $LOG
					 echo -e "=================================================================================" >> $LOG
					 

					 echo -e "Atualizando os Registros de DNS para o servidor: `hostname`" >> $LOG
					 echo -e "Atualizando os Registros de DNS para o servidor: `hostname`, pressione <Enter> para executar a atualização"
					 read
					 #Atualizando todos os registros do DNS no SAMBA-4 utilizando o script samba_dnsupdate
					 samba_dnsupdate --use-file=/var/lib/samba/private/dns.keytab --verbose --all-names &>> $LOG
					 echo -e "Atualização dos Registros de DNS feito com sucesso!!!!" >> $LOG
					 echo
					 echo -e "Atualização dos Registros de DNS feito com sucesso, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 echo >> $LOG
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Agendando as atualizações do DNS para serem feitas no Cron.d para o servidor: `hostname`"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Copiando o arquivo de agendamento do sambadnsupdate
					 cp -v conf/sambadnsupdate /etc/cron.d/ >> $LOG
					 #Editando o arquivo de agendamento do smbdadnsupdate
					 vim /etc/cron.d/sambadnsupdate +13
					 echo -e "Agendamento das atualizações do DNS criado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 echo >> $LOG
					 clear
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Testando a atualização do DNS para o servidor: `hostname`"
					 echo -e "Pressione <Enter> para testar a atualização dos registro, pressione Q (quit) para sair"
					 read
					 #Atualizando todos os registros do DNS no SAMBA-4 utilizando o script samba_dnsupdate
					 samba_dnsupdate --use-file=/var/lib/samba/private/dns.keytab --verbose --all-names | less
					 echo
					 echo -e "Teste das atualizações do DNS feito com sucesso, pressione <Enter> para continuar o script"
					 read
					 sleep 2
					 echo >> $LOG
					 clear
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Aplicando as Permissões de Gerenciamento de Disco" >> $LOG
					 echo -e "Permitindo que o Grupo Domain Admins gerencie os discos para o servidor: `hostname`"
					 #Permitindo que o grupo Domains Admins administre os discos do servidor, isso será utilizado nas permissões de compartilhamentos, utilizando o comando net rpc
					 net rpc rights grant 'PTI\Domain Admins' SeDiskOperatorPrivilege -U $USER%$PASSWORD &>> $LOG
					 echo -e "Permissão de Gerenciamento de Disco feita com sucesso!!!!" >> $LOG
					 echo -e "Permissão de Gerenciamento de Disco feita com sucesso!!!!"
					 echo >> $LOG
					 echo
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Aplicando as Permissões de Gerenciamento de Impressoras" >> $LOG
					 echo -e "Permitindo que o Grupo Domain Admins gerencie as impressoras para o servidor: `hostname`"
					 #Permitindo que o grupo Domains Admins administre as impressoras no servidor, isso será utilizado nos compartilhamentos de drivers e impressoras na rede, utilizando o comando net rpc
					 net rpc rights grant 'PTI\Domain Admins' SePrintOperatorPrivilege -U $USER%$PASSWORD &>> $LOG
					 echo -e "Permissão de Gerenciamento de Impressoras feita com sucesso!!!!" >> $LOG
					 echo -e "Permissão de Gerenciamento de Impressoras feita com sucesso!!!!"
					 echo >> $LOG
					 echo
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Criação do Usuário DHCP para integração com o DNS do SAMBA-4" >> $LOG
					 echo -e "Criação do Usuário DHCP para integração com o DNS do SAMBA-4"
					 #Criando usuário dhcp para integração do SAMBA4, DNS e DHCP utilizando o comando samba-tool
					 samba-tool user create $DHCPDUSER $PASSWORD --description="Integração SAMBA4, DNS e DHCP" &>> $LOG
					 #Desabilitando a expiração de senha do usuário dhcp com o comando samba-tool
					 samba-tool user setexpiry $DHCPDUSER --noexpiry &>> $LOG
					 #Adicionando o ususário dhcp ao grupo DnsAdmins utilizando o comando samba-tool
					 samba-tool group addmembers DnsAdmins $DHCPDUSER &>> $LOG
					 echo -e "Criação do usuário DHCP feita com sucesso!!!!" >> $LOG
					 echo -e "Criação do usuário DHCP feita com sucesso!!!!"
					 echo
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Criação do diretório /etc/dhcp/dhcpd para manter as configurações de integrações" >> $LOG
					 echo -e "Criação do diretório /etc/dhcp/dhcpd para manter as configurações de integrações"
					 #Criando o diretório para a integração do DHCP com o DNS
					 mkdir -v /etc/dhcp/dhcpd >> $LOG
					 echo -e "Criação feita com sucesso, continuando o script" >> $LOG
					 echo -e "Criação do diretório do DHCPD feita com sucesso!!!!"
					 echo
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Copiando os arquivos de integração do DNS e DHCP" >> $LOG
					 echo -e "Copiando os arquivos de integração do DNS e DHCP"
					 #Copiando o arquivo de configuração do dhcpd-update-samba-dns.conf
					 cp -v conf/dhcpd-update-samba-dns.conf /etc/dhcp/dhcpd >> $LOG
					 #Copiando o script de integração do dhcpd-update-samba-dns.sh
					 cp -v conf/dhcpd-update-samba-dns.sh /etc/dhcp/dhcpd >> $LOG
					 #Copiando o script de integração do samba-dnsupdate.sh
					 cp -v conf/samba-dnsupdate.sh /etc/dhcp/dhcpd >> $LOG
					 #Alteração as permissões de execução para os scripts com extensão .sh
					 chmod -v +x /etc/dhcp/dhcpd/*.sh >> $LOG
					 #Alteração as permissões de execução para os arquivos de configuração com extensão .conf
					 chmod -v +x /etc/dhcp/dhcpd/*.conf >> $LOG
					 #Fazendo o backup do arquivo de configuração usr.sbin.dhcpd
					 mv -v /etc/apparmor.d/local/usr.sbin.dhcpd /etc/apparmor.d/local/usr.sbin.dhcpd.old &>> $LOG
					 #Copiando o arquivo de configuração usr.sbin.dhcpd
					 cp -v conf/usr.sbin.dhcpd /etc/apparmor.d/local/ >> $LOG
					 #Reinicializando o serviço do AppAmor
					 sudo service apparmor restart
					 #Reinicializando o servidor do ISC DHCP Server
					 sudo service isc-dhcp-server restart
					 echo -e "Copia dos arquivos de integração feita com sucesso!!!!" >> $LOG
					 echo -e "Copia dos arquivos de integração feita com sucesso!!!!"
					 echo
					 echo -e "=================================================================================" >> $LOG
					 
					 echo -e "Configurando o arquivo DHCPD-UPDATE-SAMBA-DNS.CONF"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Editando o arquivo de configuração dhcpd-update-samba-dns.conf
					 vim /etc/dhcp/dhcpd/dhcpd-update-samba-dns.conf +14
					 echo -e "Configurando feita com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Configurando o arquivo USR.SBIN.DHCPD"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Editando o arquivo de configuração usr.sbin.dhcpd
					 vim /etc/apparmor.d/local/usr.sbin.dhcpd +16
					 echo -e "Configurando feita com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Testando as configurações do DNS"
					 echo -e "Pressione <Enter> para testar as configurações, para sair pressione Ctrl+C"
					 read
					 #Testando as informações do Bind9 DNS Server para verificar as atualização de registro
					 named -u bind -f -g -d 2
					 sleep 2
					 clear
					 echo -e "=================================================================================" >> $LOG

					 echo -e "Fim das configurações de permissões do SAMBA-4 e integrações com Bind9 DNS Server e ISC DHCP Server"

					 echo >> $LOG
					 echo -e "Fim do Script-07.sh em: `date`" >> $LOG
					 echo -e "=================================================================================" >> $LOG
					 echo
					 # Script para calcular o tempo gasto para a execução do script-07.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-07.sh: $TEMPO"
					 echo -e "Pressione <Enter> para concluir o processo e reinicializar o servidor"
					 read
					 reboot
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