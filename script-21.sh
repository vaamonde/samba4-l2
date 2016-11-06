#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 26/09/2016
# Data de atualização: 26/09/2016
# Versão: 0.6
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração da Auditoria de Arquivos do SAMBA-4
# Configuração dos Recursos do Rsyslog
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-21.sh
LOG="/var/log/script-21.log"
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
					 echo -e "Usuário é `whoami`, continuando a executar o Script-21.sh"
					 echo
					 echo -e "Rodando o Script-21.sh em: `date`" > $LOG
					 
					 echo -e "Configurando o Módulo VFS Full Audit do SAMBA-4 no Rsyslog"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Criando o arquivo para armazenar os Logs do Módulo VFS do Full Audit do SAMBA-4
					 touch /var/log/samba/log.samba_fullaudit
					 #Mudando as permissões de dono e grupo do arquivo
					 chown -v syslog.adm /var/log/samba/log.samba_fullaudit &>> $LOG
					 #Copiando o arquivo de configuração do Rsyslog para o Full Audit
					 cp -v conf/sambaaudit.conf /etc/rsyslog.d/ &>> $LOG
					 #Editando o arquivo de configuração
					 vim /etc/rsyslog.d/sambaaudit.conf +13
					 #Reinicializando o serviço do Rsyslog
					 sudo service rsyslog restart &>> $LOG
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2

					 echo -e "Fim do Script-21.sh em: `date`" >> $LOG
					 echo
					 # Script para calcular o tempo gasto para a execução do script-21.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-21.sh: $TEMPO"
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