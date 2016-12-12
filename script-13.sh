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
# Configuração do agendamento de Backup do SAMBA-4, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
# Configuração do CRONTAB para o agendamento de Backup do SAMBA-4
# Utilização do Script de Backup feito pelo Tean do SAMBA-4
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-13.sh
LOG="/var/log/script-13.log"
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
					 BACKUP="/backup/samba4"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-13.sh"
					 echo
					 echo -e "Rodando o Script-13.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "               Confguração do Agendamento de Backup do SAMBA4"
					 echo

					 echo -e "01. Copiando o Script de Backup do SAMBA-4 do servidor: `hostname`"
					 echo
					 #Copiando o arquivo de script do samba_backup
					 cp -v conf/samba_backup /usr/sbin >> $LOG
					 #Alterando suas permissões de dono, grupo e outros
					 chmod -v 750 /usr/sbin/samba_backup >> $LOG
					 #Criando o diretório de Backup para o SAMBA-4 em /backup/samba4
					 mkdir -v $BACKUP >> $LOG
					 #Criando o diretório /etc dentro da localização dos arquivos de configuraçao do SAMBA-4
					 mkdir -v /var/lib/samba/etc/ >> $LOG
					 echo -e "Copia feita com sucesso!!!, pressione <Enter> para continuando com o script"
					 read
					 sleep 2
					 clear
					 
					 echo
					 echo -e "Editando as configurações do arquivos SAMBA_BACKUP"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 #Editando o arquivo de script do samba_backup
					 vim /usr/sbin/samba_backup +39
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo
					 echo -e "Executando o Backup do SAMBA-4"
					 samba_backup
					 echo
					 echo -e "Backup do SAMBA-4 executado com sucesso!!!!"
					 echo
					 echo -e "Verificando os arquivos de Backup do SAMBA-4"
					 ls -lha $BACKUP
					 echo
					 echo -e "Backup feito com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "02. Agendando do Backup SAMBA-4 do servidor: `hostname`"
					 echo -e "Pressione <Enter> para editar o arquivo: /etc/cron.d/sambabackup"
					 read
					 #Copiando o arquivo de agendamento do sambabackup
					 cp -v conf/sambabackup /etc/cron.d/ >> $LOG
					 #Editando o arquivo de agendamento do sambabackup
					 vim /etc/cron.d/sambabackup +13
					 echo -e "Arquivo editado com sucesso!!! Pressione <Enter> para continuar"	 
					 read
					 sleep 2
					 clear	 

					 echo -e "Fim do Script-13.sh em: `date`" >> $LOG
					 echo -e "               Confguração do Agendamento de Backup do SAMBA-4"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-13.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-13.sh: $TEMPO"
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
