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
# Configuração do Rsync para replicação de pastas
# Configuração do sistema de Backup utilizando o Backupninja
# Configuração do sistema de Monitoramente utilizando o Netdata
# Configuração da limpeza da Pasta Público
# Configuração da limpeza da Pasta Lixeira
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-20.sh
LOG="/var/log/script-20.log"
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
					 # Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND="noninteractive"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-20.sh"
					 echo
					 echo -e "Rodando o Script-20.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "       Instalação e Configuração do Sistema de Backup e Monitoramento"
					 echo -e "================================================================================="
					 echo

					 echo -e "Instalação do Backupninja" >> $LOG
					 echo -e "Instalação do Backupninja no servidor: `hostname`"
					 echo -e "Pressione <Enter> para instalar"
					 read
					 echo
					 
					 echo -e "Atualização do Apt-Get"
					 #Fazendo a atualização das listas do apt-get
					 apt-get update &>> $LOG
					 echo -e "Atualização das lista do apt-get feita com sucesso!!!"
					 echo
					 
					 echo -e "Atualizando os Software instalados"
					 #Fazendo a atualização de todos os software do servidor
					 apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
					 echo -e "Atualização do sistema feita com sucesso!!!"
					 echo
					 
					 #Setando as configurações do debconf para o postfix funcionar no modo Noninteractive
					 echo -e "postfix postfix/mailname string ptispo01dc01.pti.intra" | debconf-set-selections &>> $LOG
					 echo -e "postfix postfix/main_mailer_type string Internet Site" | debconf-set-selections &>> $LOG
					 
					 echo -e "Instalando o Backupninja"
					 #Instalando o Backupninja
					 apt-get -y install backupninja &>> $LOG
					 echo -e "Instalação concluida com sucesso!!!" >> $LOG
					 echo -e "Instalação do Backupninja feita com sucesso!!!, pressione <Enter> para continuar"
					 sleep 2
					 clear

					 echo -e "Instalação do Netdata" &>> $LOG
					 echo -e "Instalação do sistema de monitoramente em tempo real Netdata"
					 echo -e "Após a instalação acessar a URL http://`hostname`:19999"
					 echo -e "Download e instalação das dependências do Netdata"
					 echo -e "Pressione <Enter> para instalar"
					 read
					 #Instalando as dependências do Netdata
					 apt-get -y install zlib1g-dev gcc make git autoconf autogen automake pkg-config uuid-dev &>> $LOG
					 echo -e "Instalação das dependêncais do Netdata feita com sucesso!!!"
					 echo
					 #Limpando o cache do apt-get
					 apt-get clean >> $LOG
					 echo -e "Limpeza do cache do apt-get feito com sucesso!!!"
					 echo
					 #Clonando o site do GitHub do Netdata
					 git clone https://github.com/firehol/netdata.git --depth=1 &>> $LOG
					 echo -e "Clonagem do software do Netdata feito com sucesso!!!"
					 echo
					 #Acessando o diretório do Netdata
					 cd netdata
					 #Compilando e instalando o Netdata
					 echo -e "Pressione <Enter> para compilar o software do NetData"
					 echo
					 read
					 ./netdata-installer.sh
					 #Saindo do diretório do Netdata
					 cd ..
					 #Removendo o diretório do Netdata
					 rm -Rfv netdata/ >> $LOG
					 echo -e "Instalação concluida com sucesso!!!" >> $LOG
					 echo
					 echo -e "Instalação do Netdata feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Configurando o Backupninja e criando os agendamentos"
					 echo -e "Pressione <Enter> para configurar o backup"
					 read
					 #Criando e agendando o backup do diretório /arquivos/pti.intra
					 #Utilização do wizard do Backupninja (mais fácil)
					 ninjahelper
					 echo -e "Backupninja agendando com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Configurando o serviço do Rsync"
					 echo -e "Alterar a linha: RSYNC_ENABLE=false para RSYNC_ENABLE=true"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Editando o arquivo do serviço do rsync
					 vim /etc/default/rsync +8
					 #Reinicializando o serviço do rsync
					 sudo service rsync restart
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo
					 echo -e "Criando o agendamento do sincronismo de pastas"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Copiando o script do sincronismo do rsync do samba
					 cp -v conf/rsync_samba /usr/sbin >> $LOG
					 #Aplicando as permissões
					 chmod -v 750 /usr/sbin/rsync_samba >> $LOG
					 #Copiando o agendamento do sincronismo do rsync do samba
					 cp -v conf/rsyncsamba /etc/cron.d/ >> $LOG
					 #Editando o arquivo do sincronismo
					 vim /etc/cron.d/rsyncsamba +13
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Agendamento da Limpeza da Pasta Público"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Copiando o script da limpeza da pasta público
					 cp -v conf/clean_public /usr/sbin >> $LOG
					 #Aplicando as permissões
					 chmod -v 750 /usr/sbin/clean_public >> $LOG
					 #Copiando o agendamento da limpeza da pasta público
					 cp -v conf/cleanpublic /etc/cron.d/ >> $LOG
					 #Editando o arquivo do agendamento
					 vim /etc/cron.d/cleanpublic +13
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Agendamento da Limpeza da Pasta Lixeira"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Copiando os script da limpeza da pasta lixeira
					 cp -v conf/clean_recycle /usr/sbin >> $LOG
					 #Aplicando as permissões
					 chmod -v 750 /usr/sbin/clean_recycle >> $LOG
					 #Copiando o agendamento da limpeza da pasta lixeira
					 cp -v conf/cleanrecycle /etc/cron.d/ >> $LOG
					 #Editando o arquivo do agendamento
					 vim /etc/cron.d/cleanrecycle +13
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-20.sh em: `date`" >> $LOG
					 echo -e "        Instalação e Configuração do Sistema de Backup e Monitoramento"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-20.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-20.sh: $TEMPO"
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
