#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 01/10/2018
# Versão: 0.9
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
#						/home		= Pasta home dos usuários;
#						/profiles	= Pasta perfil dos usuários;
#					/lixeira		= Pasta dos links simbólicos das lixeiras;
#					/pdf			= Pasta das impressões de arquivos PDF;
# /backup/pti.intra
#					/rsync			= Pasta do sincronismo dos arquivos da rede;
#					/bkp			= Pasta de Backup do Backupninja.
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
					 echo -e "                      Pressione <Enter> para continuar"
					 echo -e "================================================================================="
					 read
					 clear

					 echo -e "Criando a estrutura de diretórios para o servidor: `hostname`"
					 echo
					 echo -e "Diretório $DIRBASE em: $ARQUIVOS/$DIRBASE, aguarde..."
					 #Criando os diretórios para armazenar as informações da rede
					 #Criação da raiz do diretório /arquivos/pti.intra
					 mkdir -v $ARQUIVOS/$DIRBASE >> $LOG
					 echo -e "Diretório criado com sucesso"
					 sleep 2
					 echo
					 
					 echo -e "Diretório publico em: $ARQUIVOS/$DIRBASE/publico, aguarde..."
					 #Criação do diretório público, será utilizado como pasta temporária na rede, seus arquivos deverão ser deletados todos os domingos
					 mkdir -v $ARQUIVOS/$DIRBASE/publico >> $LOG
					 echo -e "Diretório criado com sucesso"
					 sleep 2
					 echo
					 
					 echo -e "Diretório pdf em: $ARQUIVOS/$DIRBASE/pdf, aguarde..."
					 #Criação do diretório pdf, será utilizado como pasta dos arquivos impressos pela impressora PDF do Cups
					 mkdir -v $ARQUIVOS/$DIRBASE/pdf >> $LOG
					 #Alterando as permissões da pasta
					 chmod -v 0777 $ARQUIVOS/$DIRBASE/pdf >> $LOG
					 #Alterando dono e grupo da pasta
					 chgrp -v lpadmin $ARQUIVOS/$DIRBASE/pdf >> $LOG
					 echo -e "Diretório criado com sucesso"
					 sleep 2
					 echo

					 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao, aguarde..."
					 #Criação do diretório gestão, que vai armazenar todos as informações dos departamentos da empresa, será utilizado recursos como Access Based Enumerator e quebra de Herança nas permissões
					 mkdir -v $ARQUIVOS/$DIRBASE/gestao >> $LOG
					 echo -e "Diretório criado com sucesso"
					 sleep 2
					 echo

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Vendas, aguarde..."
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Vendas >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Compras, aguarde..."
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Compras >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Desenvolvimento, aguarde..."
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Desenvolvimento >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/RH, aguarde..."
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/RH >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Gerencia, aguarde..."
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Gerencia >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo

						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/Diretoria, aguarde..."
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/Diretoria >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo
						 
 						 echo -e "Diretório gestao em: $ARQUIVOS/$DIRBASE/gestao/.lixeira, aguarde..."
						 mkdir -v $ARQUIVOS/$DIRBASE/gestao/.lixeira >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo

					 echo -e "Diretório sistema em: $ARQUIVOS/$DIRBASE/sistema, aguarde..."
					 #Criação do diretório sistema, onde vai ficar o sistema de gestão empresarial da empresa instalado
					 mkdir -v $ARQUIVOS/$DIRBASE/sistema >> $LOG
					 echo -e "Diretório criado com sucesso"
					 sleep 2
					 echo

					 echo -e "Diretório usuarios em: $ARQUIVOS/$DIRBASE/usuarios, aguarde..."
					 #Criação da pasta raiz dos usuários na rede, vai armazenar o Perfil dos Usuários, Pasta Base e Redirecionamento de Pastas.
					 mkdir -v $ARQUIVOS/$DIRBASE/usuarios >> $LOG
					 echo -e "Diretório criado com sucesso"
					 sleep 2
					 echo
					 
						 echo -e "Diretório usuarios em: $ARQUIVOS/$DIRBASE/usuarios/home, aguarde..."
						 #Criação da pasta Home dos usuários.
						 mkdir -v $ARQUIVOS/$DIRBASE/usuarios/home >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo
						 
 						 echo -e "Diretório usuarios em: $ARQUIVOS/$DIRBASE/usuarios/profile, aguarde..."
						 #Criação da pasta Home Profile.
						 mkdir -v $ARQUIVOS/$DIRBASE/usuarios/profile >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo

					 echo -e "Diretório lixeira em: $ARQUIVOS/$DIRBASE/lixeira, aguarde..."
					 #Criação da pasta para armazenar os arquivos deletados nos compartilhamentos
					 mkdir -v $ARQUIVOS/$DIRBASE/lixeira >> $LOG
					 #Criação dos Links Simbólicos das Lixeiras das Pastas
					 ln -sv $ARQUIVOS/$DIRBASE/publico/.lixeira/ $ARQUIVOS/$DIRBASE/lixeira/Lixeira_Publico >> $LOG
					 ln -sv $ARQUIVOS/$DIRBASE/gestao/.lixeira/ $ARQUIVOS/$DIRBASE/lixeira/Lixeira_Gestao >> $LOG
					 ln -sv $ARQUIVOS/$DIRBASE/sistema/.lixeira/ $ARQUIVOS/$DIRBASE/lixeira/Lixeira_Sistema >> $LOG
					 echo -e "Diretório criado com sucesso"
					 sleep 2
					 echo

					 echo -e "Diretório $DIRBASE em: $BACKUP/$DIRBASE, aguarde..."
					 #Criação da pasta raiz do backup
					 mkdir -v $BACKUP/$DIRBASE >> $LOG
					 echo -e "Diretório criado com sucesso"
					 sleep 2
					 echo

						 echo -e "Diretório rsync em: $BACKUP/$DIRBASE/rsync, aguarde..."
						 #Criação da pasta utilizada pelo rsync para fazer o sincronismo dos arquivos de backup
						 mkdir -v $BACKUP/$DIRBASE/rsync >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo

						 echo -e "Diretório bkp em: $BACKUP/$DIRBASE/bkp, aguarde..."
						 #Criação da pasta utilizada pelo Backupninja para fazer o  backup dos arquivos
						 mkdir -v $BACKUP/$DIRBASE/bkp >> $LOG
						 echo -e "Diretório criado com sucesso"
						 sleep 2
					 	 echo
					 
					 echo -e "Criação dos diretórios feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Listando o contéudo do diretório: $ARQUIVOS/$DIRBASE, aguarde..."
					 echo
					 #Listando o contéudo do diretório /arquivos/pti.intra
					 tree -f $ARQUIVOS/$DIRBASE
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
