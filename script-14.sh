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
# Criação da árvore de diretórios para o armazenamento das informações da empresa.
# Utilização da partição /arquivos para a montagem da estrutura de diretórios
# /arquivos/pti.intra
#					/publico		= Pasta pública da rede;
#					/gestao			= Pasta dos departamentos da rede;
#					/sistema		= Pasta do sistema de gestão;
#					/usuarios		= Pasta dos usuários da rede;
#						/home		= Pasta home dos usuários
#						/profiles	= Pasta perfil dos usuários
#					/lixeira		= Pasta da Lixeira
# /backup/pti.intra
#					/rsync			= Pasta do sincronismo dos arquivos da rede;
#					/bkp			= Pasta de Backup do Backupninja
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-14.sh
LOG="/var/log/script-14.log"
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
					 ARQUIVOS="/arquivos"
					 DIRBASE="pti.intra"
					 BACKUP="/backup"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-14.sh"
					 echo
					 echo -e "Rodando o Script-14.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                     Criação da estrutura de diretórios"
					 echo -e "================================================================================="

					 echo -e "Criando a estrutura de diretórios para o servidor: `hostname`"
					 echo -e "Diretório $DIRBASE em: $ARQUIVOS/$DIRBASE"
					 #Criando os diretórios para armazenar as informações da rede
					 #Criação da raiz do diretório /arquivos/pti.intra
					 mkdir -v $ARQUIVOS/$DIRBASE >> $LOG
					 echo -e "Diretório criado com sucesso"
					 
					 echo -e "Diretório publico em: $ARQUIVOS/$DIRBASE/publico"
					 #Criação do diretório público, será utilizado como pasta temporária na rede, seus arquivos deverão ser deletados todos os domingos
					 mkdir -v $ARQUIVOS/$DIRBASE/publico >> $LOG
					 echo -e "Diretório criado com sucesso"

					 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao"
					 #Criação do diretório gestão, que vai armazenar todos as informações dos departamentos da empresa, será utilizado recursos como Access Based Enumerator e quebra de Herança nas permissões
					 mkdir -v $ARQUIVOS/$DIRBASE/gestao >> $LOG
					 echo -e "Diretório criado com sucesso"

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Vendas"
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Vendas >> $LOG
						 echo -e "Diretório criado com sucesso"

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Compras"
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Compras >> $LOG
						 echo -e "Diretório criado com sucesso"

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Desenvolvimento"
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Desenvolvimento >> $LOG
						 echo -e "Diretório criado com sucesso"

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/RH"
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/RH >> $LOG
						 echo -e "Diretório criado com sucesso"

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Gerencia"
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Gerencia >> $LOG
						 echo -e "Diretório criado com sucesso"

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Diretoria"
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Diretoria >> $LOG
						 echo -e "Diretório criado com sucesso"

					 echo -e "Diretório sistema em: $ARQUIVOS/$DIRBASE/sistema"
					 #Criação do diretório sistema, onde vai ficar o sistema de gestão empresarial da empresa instalado
					 mkdir -v $ARQUIVOS/$DIRBASE/sistema >> $LOG
					 echo -e "Diretório criado com sucesso"

					 echo -e "Diretório usuarios em: $ARQUIVOS/$DIRBASE/usuarios"
					 #Criação da pasta raiz dos usuários na rede, vai armazenar o Perfil dos Usuários, Pasta Base e Redirecionamento de Pastas.
					 mkdir -v $ARQUIVOS/$DIRBASE/usuarios >> $LOG
					 echo -e "Diretório criado com sucesso"
					 
						 echo -e "Diretório usuarios em: $ARQUIVOS/$DIRBASE/usuarios/home"
						 #Criação da pasta Home dos usuários.
						 mkdir -v $ARQUIVOS/$DIRBASE/usuarios/home >> $LOG
						 echo -e "Diretório criado com sucesso"
						 
 						 echo -e "Diretório usuarios em: $ARQUIVOS/$DIRBASE/usuarios/profile"
						 #Criação da pasta Home Profile.
						 mkdir -v $ARQUIVOS/$DIRBASE/usuarios/profile >> $LOG
						 echo -e "Diretório criado com sucesso"

					 echo -e "Diretório lixeira em: $ARQUIVOS/$DIRBASE/lixeira"
					 #Criação da pasta para armazenar os arquivos deletados nos compartilhamentos
					 mkdir -v $ARQUIVOS/$DIRBASE/lixeira >> $LOG
					 echo -e "Diretório criado com sucesso"

					 echo -e "Diretório $DIRBASE em: $BACKUP/$DIRBASE"
					 #Criação da pasta raiz do backup
					 mkdir -v $BACKUP/$DIRBASE >> $LOG
					 echo -e "Diretório criado com sucesso"

						 echo -e "Diretório rsync em: $BACKUP/$DIRBASE"
						 #Criação da pasta utilizada pelo rsync para fazer o sincronismo dos arquivos de backup
						 mkdir -v $BACKUP/$DIRBASE/rsync >> $LOG
						 echo -e "Diretório criado com sucesso"

						 echo -e "Diretório bkp em: $BACKUP/$DIRBASE"
						 #Criação da pasta utilizada pelo Backupninja para fazer o  backup dos arquivos
						 mkdir -v $BACKUP/$DIRBASE/bkp >> $LOG
						 echo -e "Diretório criado com sucesso"
					 
					 echo -e "Criação dos diretórios feita com sucesso, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Listando o contéudo do diretório: $ARQUIVOS/$DIRBASE"
					 echo
					 #Listando o contéudo do diretório /arquivos/pti.intra
					 ls -lha $ARQUIVOS/$DIRBASE
					 echo

					 echo -e "Listando o contéudo do diretório: $ARQUIVOS/$DIRBASE/gestao"
					 echo
					 #Listando o contéudo do diretório /arquivos/pti.intra/gestao
					 ls -lha $ARQUIVOS/$DIRBASE/gestao
					 echo

					 echo -e "Listando o contéudo do diretório: $BACKUP/$DIRBASE"
					 echo
					 #Listando o contéudo do diretório /backup/pti.intra
					 ls -lha $BACKUP/$DIRBASE
					 echo

					 echo -e "Fim do Script-14.sh em: `date`" >> $LOG
					 echo -e "               Criação da estrutura de diretórios"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-14.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-14.sh: $TEMPO"
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