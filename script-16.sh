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
# Criação da estrutura de Grupos Globais e Domínio Local.
# Utilizando do comando samba-tool para a criação
# Utilizando arquivo de referência dos grupos
# samba-tool group add
# samba-tool group addmembers
# samba-tool group list -v
# Scope: Domain ou Global
# Type: Security 
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-16.sh
LOG="/var/log/script-16.log"
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
					 GRUPOGLOBAL="conf/group.global"
					 GRUPOLOCAL="conf/group.local"
					 MEMBERS="conf/members.group"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-16.sh"
					 echo
					 echo -e "Rodando o Script-16.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                        Criação da estrutura de Grupos"
					 echo -e "================================================================================="

					 echo -e "Criação da estrutura de grupos Globais para o servidor: `hostname`"
					 echo -e "Pressione <Enter> para editar o arquivo de Grupos Globais"
					 read
					 #Editando o arquivo de grupos globais
					 vim $GRUPOGLOBAL
					 echo -e "Arquivo editado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Criação da estrutura de grupos Domínio Local para o servidor: `hostname`"
					 echo -e "Pressione <Enter> para editar o arquivo de Grupos Globais"
					 read
					 #Editando o arquivo de grupos domínio local
					 vim $GRUPOLOCAL
					 echo -e "Arquivo editado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Criação da estrutura de Membros de Grupos: `hostname`"
					 echo -e "Pressione <Enter> para editar o arquivo de Members Group "
					 read
					 #Editando o arquivo de membro de grupos globais e domínio local
					 vim $MEMBERS
					 echo -e "Arquivo editado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear					 

					 echo -e "Pressione <Enter> para criar os Grupos Globais"
					 read
					 echo -e "Criação dos Grupos Globais" >> $LOG
					 #Utilizando o comando gawk (melhor que o cut) para listar o contéudo do arquivo group.global
					 #Executando o laço de loop com o comando while para acrescentar todos os grupos a base de dados do SAMBA-4 utilizando o comando samba-tool
					 gawk -F ":" '{ print $2, $3, $4 }' $GRUPOGLOBAL | while read LISTAGG;
					 	do $(echo "/usr/bin/samba-tool group add $LISTAGG --group-scope=Global --group-type=Security") &>> $LOG;
					 done;
					 echo >> $LOG
					 echo
					 echo -e "Total de Grupos Globais criados: `wc -l $GRUPOGLOBAL | cut -d ' ' -f1`"
					 echo
					 echo -e "Grupos criado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Pressione <Enter> para criar os Grupos Locais"
					 read
					 echo -e "Criação dos Grupos Locais" >> $LOG
					 #Utilizando o comando gawk (melhor que o cut) para listar o contéudo do arquivo group.locais
					 #Executando o laço de loop com o comando while para acrescentar todos os grupos a base de dados do SAMBA-4 utilizando o comando samba-tool
					 gawk -F ":" '{ print $2, $3, $4 }' $GRUPOLOCAL | while read LISTAGL;
					 	do $(echo "/usr/bin/samba-tool group add $LISTAGL --group-scope=Domain --group-type=Security") &>> $LOG;
					 done;
					 echo >> $LOG
					 echo
					 echo -e "Total de Grupos Globais criados: `wc -l $GRUPOLOCAL | cut -d ' ' -f1`"
					 echo
					 echo -e "Grupos criado com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Pressione <Enter> para associar os Grupos Globais com Locais"
					 read
					 echo -e "Associação dos Grupos Globais com Grupos Locais" >> $LOG
					 #Utilizando o comando gawk (melhor que o cut) para listar o contéudo do arquivo members.group
					 #Executando o laço de loop com o comando while para associar todos os grupos a base de dados do SAMBA-4 utilizando o comando samba-tool
					 gawk -F ":" '{ print $2, $3 }' $MEMBERS | while read LISTAMG;
					 	do $(echo "/usr/bin/samba-tool group addmembers $LISTAMG") &>> $LOG;
					 done;
					 echo >> $LOG
					 echo
					 echo -e "Total de Grupos Associados: `wc -l $MEMBERS | cut -d ' ' -f1`"
					 echo
					 echo -e "Associação de grupos feita com sucesso, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Pressione <Enter> para listar os Grupos Globais"
					 read
					 #Listando todos dos grupos globais utilizando o comando samba-tool com filtro
					 samba-tool group list -v | grep GG
					 echo
					 echo -e "Pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Pressione <Enter> para listar os Grupos Locais"
					 read
					 #Listando todos dos grupos domínio local utilizando o comando samba-tool com filtro
					 samba-tool group list -v | grep ACL
					 echo
					 echo -e "Pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Pressione <Enter> para listar os Membros de Grupos"
					 read
					 #Utilizando o comando gawk (melhor que o cut) para listar o contéudo do arquivo members.group e criar um arquivo temporario
					 gawk -F ":" '{ print $2 }' $MEMBERS &>> /tmp/members.group
					 echo
					 #Utilizando o comando gawk (melhor que o cut) para listar o contéudo do arquivo members.group e criar um laço de loop para verificar os membros ds grupos e criar um arquivo temporario
					 gawk -F ":" '{ print $2 }' $MEMBERS | while read LISTAMG;
					 	do $(echo "/usr/bin/samba-tool group listmembers $LISTAMG") &>> /tmp/listmembers;
					 done;
					 echo
					 #Concatenar os arquivos temporários e mostrar o resultado
					 paste -d' ' /tmp/members.group /tmp/listmembers
					 echo -e "Pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-16.sh em: `date`" >> $LOG
					 echo -e "                        Criação da estrutura de Grupos"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-16.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-16.sh: $TEMPO"
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