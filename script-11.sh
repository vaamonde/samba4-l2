#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 07/10/2018
# Versão: 0.9
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Troubleshooting de Status dos Serviços de Rede da decima primeira etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
# Utilização de vários comandos para analisar os status dos serviços
# service
# samba-ad-dc, smbd e nmbd
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-11.sh
LOG="/var/log/script-11.log"
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
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-11.sh"
					 echo
					 echo -e "Rodando o Script-11.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "               Troubleshooting do Status dos Serviços de Rede"
					 echo

					 echo -e "01. Status do Serviço SAMBA-AD-DS do servidor: `hostname`"
					 echo
					 sudo service samba-ad-dc status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "02. Status do Serviço NMBD do servidor: `hostname`"
					 echo
					 sudo service nmbd status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "03. Status do Serviço SMBD do servidor: `hostname`"
					 echo
					 sudo service smbd status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "04. Status do Serviço QUOTA do servidor: `hostname`"
					 echo
					 sudo service quota status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "05. Status do Serviço NFS-SERVER do servidor: `hostname`"
					 echo
					 sudo service nfs-server status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "06. Status do Serviço BIND9-DNS do servidor: `hostname`"
					 echo
					 sudo service apparmor reload
					 sudo service bind9 restart
					 sudo service bind9 status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "07. Status do Serviço ISC-DHCP-SERVER do servidor: `hostname`"
					 echo
					 sudo service isc-dhcp-server status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "08. Status do Serviço SSH-SERVER do servidor: `hostname`"
					 echo
					 sudo service ssh status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "09. Status do Serviço NTP-SERVER do servidor: `hostname`"
					 echo
					 sudo service ntp status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "10. Status do Serviço APACHE-SERVER do servidor: `hostname`"
					 echo
					 sudo service apache2 status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "11. Status do Serviço MYSQL-SERVER do servidor: `hostname`"
					 echo
					 sudo service mysql status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "12. Status do Serviço PROFTPD-SERVER do servidor: `hostname`"
					 echo
					 sudo service proftpd status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "13. Status do Serviço CLAMAV do servidor: `hostname`"
					 echo
					 sudo service clamav-daemon status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "14. Status do Serviço CLAMAV-FRESHSCAN do servidor: `hostname`"
					 echo
					 sudo service clamav-freshclam status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "15. Status do Serviço CRON do servidor: `hostname`"
					 echo
					 sudo service cron status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "16. Status do Serviço APPARMOR do servidor: `hostname`"
					 echo
					 sudo service apparmor status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "17. Status do Serviço CUPS do servidor: `hostname`"
					 echo
					 sudo service cups-browsed status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "18. Status do Serviço WEBMIN do servidor: `hostname`"
					 echo
					 sudo service webmin status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
 					 echo -e "19. Status do Serviço RSYSLOG do servidor: `hostname`"
					 echo
					 sudo service rsyslog status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "20. Status do Serviço WINBIND do servidor: `hostname`"
					 echo
					 sudo service winbind status
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "21. Status de Serviço com SYSTEMCTL do servidor: `hostname`"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 echo
					 systemctl -t service
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-11.sh em: `date`" >> $LOG
					 echo -e "               Troubleshooting do Status dos Serviços de Rede"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-11.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-11.sh: $TEMPO"
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
