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
# Verificação das portas de serviços da nona etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# Informações de Serviços de Rede integrado com o SAMBA4
#
# SSH (Secure Shell - Porta padrão: TCP 22)
# DNS (Domain Name System - Porta padrão: TCP/UDP 53 UDP 5353)
# SMB (Server Message Block NetBIOS - Portas padrão: UDP 137, UDP 138 é TCP 139) 
# RPC/ECM (Microsoft Remote Procedure Call - Porta padrão: TCP/UDP 111 é TCP 135)
# CIFS (Common Internet File System - Porta padrão: TCP 445)
# LDAP (Lightweight Directory Access Protocol - Porta padrão: TCP/UDP 389)
# LDAPS (Lightweight Directory Access Protocol Secure - Porta padrão: TCP 636)
# GC (Global Catalog - Portas padrão: TCP 3268 é TCP 3269)
# Kerberos (Network Authentication Protocol - Portas padrão: TCP/UDP 88 é TCP/UDP 464)
# NTP (Network Time Protocol - Porta padrão: UDP 123)
# DHCP (Dynamic Host Configuration Protocol - Porta padrão: UDP 67)
# CUPS (Common Unix Printing System - Porta padrão: TCP/UDP 631 TCP 9100)
# WEBMIN (Web-based System Configuration - Porta padrão: TCP/UDP 10000)
# APACHE (Apache HTTP Server - Porta padrão: TCP 80)
# MYSQL (Open-Source Relational Database Nanagement System - Porta padrão: TCP 3306)
# FTP (File Transfer Protocol - Porta padrão: TCP 20 e 21)
# NFS (Network File System - Porta padrão: TCP/UDP 2049)
# RPC (Remote Procedure Call - Portas dinâmicas de: TCP 1024 até 5000)
# Netdata (Sistema de Monitoramento - Porta padrão: TCP/UDP 19999)
# Postfix SMTP (Simple Mail Transfer Protocol - Porta padrão: TCP 25)
# 
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-08.sh
LOG="/var/log/script-08.log"
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
					 echo -e "Usuário é `whoami`, continuando a executar o Script-08.sh"
					 echo
					 echo -e "Listando as Portas TCP e UDP do servidor: `hostname`"
					 echo -e "Aguarde..."
					 echo -e "Rodando o Script-08.sh em: `date`" > $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Portas  Num.Porta Status        Serviço"
					 #Executando o comando map para explorar as Portas TCP e UDP abertas
					 nmap `hostname` -sS -sU | head -n37 | tail -n31 | cat -n
					 
					 echo -e "Quantida de portas padrão que devem ser listadas no servidor `hostname`: 31 (portas)"
					 echo -e "Após todos os serviços instalados e configurados o número de porta aumenta para 34"
					 echo -e "Caso o número de portas seja diferente, verificar os status dos serviços de rede"
					 echo -e "Pressione <Enter> para verificar as regras de Firewall"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Verificando as Regras de Firewall do servidor: `hostname`"
					 echo -e "Status padrão do UFW = Inactive"
					 #Verificando o status do serviço de Firewall UFW
					 ufw status
					 echo ============================================================ >> $LOG
					 echo -e "Fim do Script-08.sh em: `date`" >> $LOG
					 echo -e "Verificação das Portas do Servidor executado com sucesso!!!!!"

					 echo
					 # Script para calcular o tempo gasto para a execução do script-08.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-08.sh: $TEMPO"
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
