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
# Configuração dos compartilhamentos do SAMBA-4
# Recursos de Lixeira
# Veto de arquivos
# Ocultar arquivos e pastas
# Auditoria
# Impressoras
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-19.sh
LOG="/var/log/script-19.log"
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
					 #Variaveis de ambiente para o script
					 ADMIN="administrator"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-19.sh"
					 echo
					 echo -e "Rodando o Script-19.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "               Configuração dos Compartilhamentos do SAMBA4"
					 echo -e "================================================================================="
					 echo
					 
					 echo -e "Configurando o SAMBA-4, editando o arquivo: smb.conf"
					 echo -e "Pressione <Enter> para editra o arquvivo"
					 read
					 #Fazendo backup do arquivo de configuração do smb.conf
					 cp -v /etc/samba/smb.conf /etc/samba/smb.conf.bkp >> $LOG
					 #Copiando o arquivo de configuranção do smb.conf
					 cp -v conf/smb.conf /etc/samba/smb.conf >> $LOG
					 #Editando o arquivo de configuração smb.conf
					 vim /etc/samba/smb.conf
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Testando as configurações do SAMBA-4"
					 echo -e "Pressione <Enter> para executar o comando testparm, para sair pressione Q (quit)"
					 read
					 #Testando as configuração do arquivo smb.conf com o comando testparm, informações detalhadas: testparm -v
					 testparm | less
					 echo -e "Arquivo smb.conf testado com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Reinicializando os serviços do SAMBA-4"
					 #Reinicializando todas as alterações no arquivo de configuração smb.conf sem parar o serviço do SAMBA-4
					 smbcontrol all reload-config
					 echo -e "Serviços reinicializados com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Verificando todos compartilhamentos criados no smb.conf"
					 echo -e "Pressione <Enter> para continuar"
					 echo
					 read
					 #Listando todos os compartilhamento criados no smb.conf com o comando smbclient
					 smbclient -L localhost -N
					 echo
					 echo -e "Compartilhamentos listados com sucesso!!!"
					 echo -e "Pressione <Enter> para continuar o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Fim do Script-19.sh em: `date`" >> $LOG
					 echo -e "                Configuração dos Compartilhamentos do SAMBA4"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-19.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-19.sh: $TEMPO"
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
