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
# Troubleshooting de ACL e ATTR no ponto de Montagem /arquivos, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
# Utilização de vários comandos para testar o ambiente de ACL e ATTR
# touch
# getfacl e getfattr
# setfacl e setfattr
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-12.sh
LOG="/var/log/script-12.log"
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
					 # Variaveis para os teste de ACL e XATTR
					 PATHFILE="/arquivos"
					 FILEACL="arquivo_acl.txt"
					 FILEATTR="arquivo_attr.txt"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-12.sh"
					 echo
					 echo -e "Rodando o Script-12.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                 Troubleshooting de Permissões de Disco"
					 echo

					 echo -e "01. Criando os arquivos de testes no ponto de montagem: $PATHFILE"
					 echo
					 #Criando os arquivos utilizando o comando touch
					 touch $PATHFILE/$FILEACL
					 touch $PATHFILE/$FILEATTR
					 #Listando o contéudo do diretório /arquivos
					 ls -lha $PATHFILE
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "02. Verificando as ACL e ATTR dos arquivos criado em: $PATHFILE"
					 echo
					 echo -e "ACL's do arquivo $FILEACL"
					 echo
					 #Verificando as ACL's do arquivo utilizando o comando getfacl
					 getfacl $PATHFILE/$FILEACL
					 echo
					 echo -e "ATTR do arquivo $FILEATTR"
					 #Verificando os atributos do arquivo utilizando o comando getfattr
					 getfattr $PATHFILE/$FILEATTR
					 echo
					 echo -e "Por padrão todos arquivos GNU/Linux não tem Atributos Extendidos criados"
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "03. Criando as ACL para o arquivo: $FILEACL em: $PATHFILE"
					 echo
					 echo -e "Antes das ACL's"
					 #Verificando as ACL's do arquivo utilizando o comando getfacl
					 getfacl $PATHFILE/$FILEACL
					 #Setando as ACL's do arquivo utilizando o comando setfacl para usuários e grupos
					 setfacl -R -m user:"PTI\Guest":rwx -d $PATHFILE/$FILEACL
					 setfacl -R -m group:"PTI\Domain Admins":rwx -d $PATHFILE/$FILEACL
					 setfacl -R -m group:"PTI\Domain Guests":rwx -d $PATHFILE/$FILEACL
					 echo
					 echo -e "Depois das ACL's"
					 #Verificando as ACL's do arquivo utilizando o comando getfacl
					 getfacl $PATHFILE/$FILEACL
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "03. Criando as ACL para o arquivo: $FILEATTR em: $PATHFILE"
					 echo
					 echo -e "Antes dos Atributos Extendidos"
					 #Verificando os atributos do arquivo utilizando o comando getfattr
					 getfattr $PATHFILE/$FILEATTR
					 echo
					 echo -e "Não existe atributos extendidos por padrão"
					 echo
					 echo -e "Criando as atributos Autor e Depto"
					 #Setando os atributos do arquivo utilizando o comando setfattr para autor de departamento
					 setfattr -n user.autor -v "Robson Vaamonde" $PATHFILE/$FILEATTR
					 setfattr -n user.depto -v "Bora para Prática" $PATHFILE/$FILEATTR
					 echo -e "Depois dos Atributos Extendidos"
					 #Verificando os atributos do arquivo utilizando o comando getfattr
					 getfattr $PATHFILE/$FILEATTR
					 echo
					 echo -e "Atributo de Autor"
					 #Verificando os atributos do arquivo utilizando o comando getfattr
					 getfattr -n user.autor $PATHFILE/$FILEATTR
					 echo
					 echo -e "Atributor de Depto"
					 #Verificando os atributos do arquivo utilizando o comando getfattr
					 getfattr -n user.depto $PATHFILE/$FILEATTR
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2

					 echo -e "Fim do Script-12.sh em: `date`" >> $LOG
					 echo -e "               Troubleshooting de Permissões de Disco"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-12.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-12.sh: $TEMPO"
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