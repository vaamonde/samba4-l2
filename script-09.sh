#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 21/11/2016
# Versão: 0.7
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Troubleshooting dos serviços de rede da decima etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
# Utilização de vários comandos para a validação do Ambiente;
# samba-tool
# lsb_release é uname
# smbclient
# date e hwclock
# kinit e klist
# dig, host e nslookup
# wbinfo e net
# getent
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-09.sh
LOG="/var/log/script-09.log"
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
					 NTP="a.st1.ntp.br"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-09.sh"
					 echo
					 echo -e "Rodando o Script-09.sh em: `date`" > $LOG
					 echo -e "==============================================================================="
					 echo -e " Troubleshooting Pós-Instalação do SAMBA4, verificação de menssagens de error"
					 echo

					 echo -e "01. Informação da Versão do Servidor: `hostname`"
					 echo
					 lsb_release -a
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "02. Informação da Versão do Kernel do Servidor: `hostname`"
					 echo
					 uname -a
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "03. Informação da Versão do Servidor SAMBA4 para o servidor: `hostname`"
					 echo
					 samba -V
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "04. Informação da Versão do Cliente do SAMBA4 para o servidor: `hostname`"
					 echo
					 smbclient -V
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "05. Informação da Versão do BIND-DNS instalada no servidor: `hostname`"
					 echo
					 named -v
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "06. Informação do Domínio do SAMBA4 para o servidor: `hostname`"
					 echo
					 samba-tool domain info $DOMAIN 
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "07. Informação do Nível Funcional do Domínio para o servidor: `hostname`"
					 echo
					 samba-tool domain level show
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "08. Informação de FSMO para o servidor: `hostname`"
					 echo
					 samba-tool fsmo show
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "09. Verificando os Objetos da Base de Dados do SAMBA4 para o servidor: `hostname`"
					 echo
					 samba-tool dbcheck
					 echo
					 echo -e "09. Verificando a concistência da Base de Dados do SAMBA4 para o servidor: `hostname`"
					 echo
					 samba-tool drs kcc
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "10. Informações de Data e Hora do SAMBA4 para o servidor: `hostname`"
					 echo
					 samba-tool time
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "11. Informações de Data e Hora do servidor: `hostname`"
					 echo
					 date
					 echo
					 echo -e "Informações de Data e Hora do Hardware do Servidor: `hostname`"
					 echo
					 hwclock
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "12. Informações do Servidor NTP para o servidor: `hostname`"
					 echo
					 sudo service ntp stop
					 ntpdate $NTP
					 sudo service ntp start
					 ntpq -pn
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "13. Verificando as zonas criadas no servidor: `hostname`"
					 echo
					 samba-tool dns zonelist $DOMAIN -U $USER --password=$PASSWORD
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "14. Verificando as zonas reversas criadas no servidor: `hostname`"
					 echo
					 samba-tool dns zonelist $DOMAIN --reverse -U $USER --password=$PASSWORD
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "15. Verificando as informações do DNS no servidor: `hostname`"
					 echo
					 sleep 2
					 samba-tool dns serverinfo $DOMAIN -U $USER --password=$PASSWORD | less
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "16. Verificando solicitações de pesquisa do DNS no servidor: `hostname`"			 
					 echo
					 samba-tool dns query $FQDN $DOMAIN @ ALL -U $USER --password=$PASSWORD
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "16. Verificando solicitações de pesquisa do DNS no servidor: `hostname`"			 
					 echo
					 samba-tool dns query $FQDN $DOMAIN @ ALL -U $USER --password=$PASSWORD
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "16. Verificando os Root Hints do Servidor: `hostname`"			 
					 echo
					 samba-tool dns roothints $FQDN -U $USER --password=$PASSWORD | less
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "17. Verificando as chaves do SAMBA4 para integração com o Bind9 DNS no servidor: `hostname`"
					 echo
					 klist -k -K -t /var/lib/samba/private/dns.keytab
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "18. Verificando as informações do DNS no servidor: `hostname`"
					 echo 
					 sleep 2
					 samba-tool drs bind | less
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "19. Verificando as informações do DNS utilizando o DIG para o servidor: `hostname`"
					 echo
					 echo -e "Testando a resolução pelo nome: $HOSTNAME"
					 dig `hostname`
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "20. Testando as configuarações de resolução DNS local utilizando o comando host para o servidor: `hostname`"
					 echo
					 echo -e "Testando a resolução por $HOSTNAME"
					 host -t A $HOSTNAME
					 echo
					 echo -e "Testando a resolução por $FQDN"
					 host -t A $FQDN
					 echo
					 echo -e "Testando a resolução por $IP"
					 host -t A $IP
					 echo
					 echo -e "Testando a resolução por $DOMAIN"
					 host -t A $DOMAIN
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "21. Testando as configuarações de resolução DNS local utilizando o comando nslookup para o servidor: `hostname`"
					 echo
					 echo -e "Testando a resolução por $HOSTNAME"
					 nslookup $HOSTNAME
					 echo
					 echo -e "Testando a resolução por $FQDN"
					 nslookup $FQDN
					 echo
					 echo -e "Testando a resolução por $IP"
					 nslookup $IP
					 echo
					 echo -e "Testando a resolução por $DOMAIN"
					 nslookup $DOMAIN
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "22. Testando as configurações do LDAP com DNS integrado no SAMBA4 para o servidor: `hostname`"
					 echo
					 echo -e "Testando os registros NS para o nome: $DOMAIN"
					 host -t NS $DOMAIN
					 echo
					 echo -e "Testando os registros SOA para o nome: $DOMAIN"
					 host -t SOA $DOMAIN
					 echo
					 echo -e "Testando os registros SRV LDAP para o nome: $DOMAIN"
					 host -t SRV _ldap._tcp.$DOMAIN
					 echo
					 echo -e "Testando os registros SRV KERBEROS para o nome: $DOMAIN"
					 host -t SRV _kerberos._udp.$DOMAIN
					 echo
					 echo -e "Testando os registros SRV GC para o nome: $DOMAIN"
					 host -t SRV _gc._tcp.$DOMAIN
					 echo
					 echo -e "Testando os registro SRV-LDAP-MSDCS para o nome: $DOMAIN"
					 host -t SRV _ldap._tcp.dc._msdcs.$DOMAIN
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "23. Testando as configurações de Kerberos e a geração de KDC para o servidor: `hostname`"
					 echo -e "Digite a senha do usuário: $USER senha padrão: $PASSWORD"
					 echo
					 kinit administrator@PTI.INTRA
					 echo 
					 klist
					 echo
					 klist -e
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "24. Listando usuários do SAMBA4 para o servidor: `hostname`"
					 echo
					 samba-tool user list
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "25. Listando grupos do SAMBA4 para o servidor: `hostname`"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 samba-tool group list | less
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "26. Listando GPO do SAMBA4 para o servidor: `hostname`"
					 echo
					 samba-tool gpo listall
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "27. Testando o arquivo de Configuração do SAMBA4 para o servidor: `hostname`"
					 echo
					 samba-tool testparm
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "28. Listando usuários do Winbind para o servidor: `hostname`"
					 echo
					 wbinfo -u
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "29. Listando grupos do Winbind para o servidor: `hostname`"
					 echo
					 wbinfo -g
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "30. Checando as chaves de segurança do Winbind para o servidor: `hostname`"		 
					 echo -e "Status padrão do Winbind: succeeded"
					 echo
					 wbinfo -t
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "31. Informações do Domínio do Winbind para o servidor: `hostname`"
					 echo
					 net ads info
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "32. Listando usuários do Winbind integrado com o Linux para o servidor: `hostname`"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 getent passwd | less
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "33. Listando grupos do Winbind integrado com o Linux para o servidor: `hostname`"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 getent group | less
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo
					 echo -e "34. Verificando as permissões aplicadas para o usuário: $USER no servidor: `hostname`"
					 echo
					 net rpc rights list accounts -U $USER%$PASSWORD | less
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo
					 echo -e "35. Verificando o acesso aos compartilhamentos locais do SAMBA4 para o servidor: `hostname`"
					 echo
					 echo -e "Utilizando o endereço de: localhost"
					 echo
					 smbclient -L localhost -U%
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo
					 echo -e "36. Verificando o acesso aos compartilhamentos locais do SAMBA4 para o servidor: `hostname`"
					 echo
					 echo -e "Utilizando o endereço de: $IP"
					 echo
					 smbclient -L $IP -U%
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo
					 echo -e "37. Verificando o acesso aos compartilhamentos locais do SAMBA4 para o servidor: `hostname`"
					 echo
					 echo -e "Utilizando o endereço de: $DOMAIN"
					 echo
					 smbclient -L $DOMAIN -U%
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo
					 echo -e "38. Verificando o acesso aos compartilhamentos locais do SAMBA4 para o servidor: `hostname`"
					 echo
					 echo -e "Utilizando o endereço de: $HOSTNAME"
					 echo
					 smbclient -L $HOSTNAME -U%
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo
					 echo -e "39. Verificando o acesso aos compartilhamentos locais do SAMBA4 para o servidor: `hostname`"
					 echo
					 echo -e "Utilizando o endereço de: $FQDN"
					 echo
					 smbclient -L $FQDN -U%
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo
					 echo -e "40. Acessando o compartilhamento Netlogon com o usuário: $USER e listando seu contéudo para o servidor: `hostname`"
					 echo
					 echo -e "Utilizando o usuário $USER"
					 echo
					 smbclient //localhost/netlogon -U $USER%$PASSWORD -c 'ls'
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
 					 echo
					 echo -e "41. Verificando o Status de Conexões para o servidor: `hostname`"
					 echo
					 smbstatus -v
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-09.sh em: `date`" >> $LOG
					 echo -e "  Troubleshooting Pós-Instalação do SAMBA4, verificação de menssagens de error"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-09.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-09.sh: $TEMPO"
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
