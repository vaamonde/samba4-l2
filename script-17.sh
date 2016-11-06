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
# Criação da estrutura de Usuários do SAMBA-4.
# Utilizando do comando samba-tool para a criação dos usuários
# Utilizando arquivo de referência dos grupos
# samba-tool user add
# samba-tool user addmembers
# samba-tool user list
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-17.sh
LOG="/var/log/script-17.log"
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
					 USUARIOS="conf/usuarios.local"
					 USUARIOSGROUP="conf/usuarios.group"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-17.sh"
					 echo
					 echo -e "Rodando o Script-17.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                        Criação Usuários do Sistema"
					 echo -e "================================================================================="

					 echo -e "Criação dos usuários no servidor: `hostname`"
					 echo -e "Pressione <Enter> para editar o arquivo de usuarios"
					 read
					 #Editando o arquivo de usuários
					 vim $USUARIOS
					 echo -e "Arquivo editado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Criação dos grupos de usuários no servidor: `hostname`"
					 echo -e "Pressione <Enter> para editar o arquivo de usuarios"
					 read
					 #Editando o arquivo de associação de usuários e seus grupos
					 vim $USUARIOSGROUP
					 echo -e "Arquivo editado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Pressione <Enter> para criar os usuários"
					 read
					 echo -e "Criação de Usuários no Sistema" >> $LOG
					 #Utilizando o comando gawk (melhor que o cut) para listar o contéudo do arquivo usuarios.local
					 #Executando o laço de loop com o comando while para acrescentar todos os usuários a base de dados do SAMBA-4 utilizando o comando samba-tool
					 gawk -F ":" '{ print $2, $3, $4, $5, $6 }' $USUARIOS | while read LISTAUSER;
					 	do $(echo "/usr/bin/samba-tool user add $LISTAUSER --must-change-at-next-login --use-username-as-cn") &>> $LOG;
					 done;
					 echo >> $LOG
					 echo -e "Total de usuários criados: `wc -l $USUARIOS | cut -d ' ' -f1`"
					 echo
					 echo -e "Usuários criados com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Pressione <Enter> para associar os usuários ao seus grupos"
					 read
					 echo -e "Associação de Usuários nos Grupos" >> $LOG
 					 #Utilizando o comando gawk (melhor que o cut) para listar o contéudo do arquivo usuarios.group
					 #Executando o laço de loop com o comando while para associar todos os usuários ao seus grupos na base de dados do SAMBA-4 utilizando o comando samba-tool
					 gawk -F ":" '{ print $2, $3 }' $USUARIOSGROUP | while read LISTAUSERGROUP;
					 	do $(echo "/usr/bin/samba-tool group addmembers $LISTAUSERGROUP") &>> $LOG;
					 done;
					 echo >> $LOG
					 echo -e "Total de usuários criados: `wc -l $USUARIOSGROUP | cut -d ' ' -f1`"
					 echo
					 echo -e "Usuários associados com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Pressione <Enter> para listar os Usuários"
					 read
					 #Listando todos os usuários da base de dados SAMBA-4
					 samba-tool user list | less
					 echo
					 echo -e "Pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-17.sh em: `date`" >> $LOG
					 echo -e "                        Criação Usuários do Sistema"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-17.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-17.sh: $TEMPO"
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