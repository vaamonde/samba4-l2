#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 06/10/2018
# Versão: 0.10
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Criação da estrutura de Unidades Organizacionais.
# Modificação da Base de Dados do SAMBA-4 utilizando comandos de LDAP
# Base de Dados: /var/lib/samba/private/sam.ldb
# Opções do changetype: add, modify ou delete
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-15.sh
LOG="/var/log/script-15.log"
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
					 OULDIF="conf/ou.ldif"
					 SAMBA4LDB="/var/lib/samba/private/sam.ldb"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-15.sh"
					 echo
					 echo -e "Rodando o Script-15.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                 Criação da estrutura de Unidades Organizacionais"
					 echo -e "================================================================================="
					 echo
					 echo -e "Para criar unidades orgazinacionais no SAMBA-4 será necessário fazer alterações no"
					 echo -e "arquivo sam.ldb localizado em: /var/lib/samba/private/sam.ldb"
					 echo
					 echo -e "Utilizando os comandos de manipulação de Base de Dados LDAP - ldbmodify"
					 echo
					 echo -e "Será necessário criar o arquivo ldif (arquivo de modificação) que tem os parâmetros"
					 echo -e "necessário para a criação das Unidades Organizacionais"
					 echo
					 echo -e "Pressione <Enter> para editar o arquivo ou.ldif"
					 read
					 #Editando o arquivo de Unidades Organizacionais
					 vim $OULDIF
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Criação das Unidades Organizacionais na Base do SAMBA-4"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 echo
					 #Modificando o contéudo da base de dados do SAMBA-4, acrescentando os objetos das unidades organizacionais na base de dados do SAMBA-4 utilizando o comando ldbmodify
					 ldbmodify -H $SAMBA4LDB $OULDIF &>> $LOG
					 echo -e "Total de OU's criadas: `cat $OULDIF | sort | grep top | uniq -c`"
					 echo
					 echo -e "Criação feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Listando as Unidades Organizacionais criadas na Base do SAMBA4"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 echo
					 #Localizando os objetivos das unidades organizacionais da base de dados do SAMBA-4 utilizando o comando ldbsearch filtrando sua saída
					 ldbsearch -H $SAMBA4LDB | grep "dn: OU" | cat -n | less
					 echo
					 echo -e "Listas das Unidades Organizacionais feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-15.sh em: `date`" >> $LOG
					 echo -e "                 Criação da estrutura de Unidades Organizacionais"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-15.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-15.sh: $TEMPO"
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
