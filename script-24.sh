#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 02/10/2018
# Data de atualização: 02/10/2018
# Versão: 0.1
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Instalação e Configuração LogAnalyzer
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-24.sh
LOG="/var/log/script-24.log"
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
					 #
					 USER="root"
					 PASSWORD="pti@2016"
					 RSYSLOG="rsyslog"
					 LOGANALYZER="loganalyzer-4.1.6.tar.gz"
					 
					 echo -e "Usuário é `whoami`, continuando a executar o Script-24.sh"
					 echo
					 echo -e "Rodando o Script-24.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                     Instalação do LogAnalyzer"
					 echo -e "================================================================================="
					 echo
					 echo -e "Pressione <Enter> para iniciar a instalação e configuração"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Instalando as Dependências do LogAnalyzer, aguarde..."
					 
					 echo -e "Atualizando as listas do apt-get, aguarde..."
					 apt-get update &>> $LOG
					 echo -e "Listas atualizadas com sucesso!!!!, continuando o script"
					 
					 echo -e "Instalando as dependências do LogAnalyzer, aguarde..."
					 #Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND="noninteractive"
					 #Configuração as variáveis do deconf para não aparecer a tela de confirmação da base dedados
					 echo "rsyslog-mysql rsyslog-mysql/dbconfig-install boolean false" |  debconf-set-selections
					 #Instalando a dependência do LogAnalyzer
					 apt-get -y install rsyslog-mysql &>> $LOG
					 echo -e "Dependências instaladas com sucesso, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Criando a base de dados do Rsyslog e setando as permissões, aguarde..."
					 #Criando a variável da criação da Base de Dados do Rsyslog
					 #Variaveis utilizada pelo MySQL para a criação do Bando de Dados
					 DATABASE1="CREATE DATABASE syslog;"
					 USERDATABASE1="CREATE USER 'syslog' IDENTIFIED BY 'syslog';"
					 GRANTDATABASE1="GRANT USAGE ON *.* TO 'syslog' IDENTIFIED BY 'syslog';"
					 GRANTALL1="GRANT ALL PRIVILEGES ON syslog.* TO 'syslog';"
					 FLUSH1="FLUSH PRIVILEGES;"
					 #Criando o Banco de Dados e setando as informações de usuários e senha utilizando o comando mysql
					 mysql -u $USER -p$PASSWORD -e "$DATABASE1" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$USERDATABASE1" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$GRANTDATABASE1" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$GRANTALL1" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$FLUSH1" mysql &>> $LOG
					 echo -e "Base de dados do Rsyslog criada com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Criando a base de dados do LogAnalyzer e setando as permissões, aguarde..."
					 #Criando a variável da criação da Base de Dados do LogAnalyzer
					 #Variaveis utilizada pelo MySQL para a criação do Bando de Dados
					 USER="root"
					 DATABASE2="CREATE DATABASE loganalyzer;"
					 USERDATABASE2="CREATE USER 'loganalyzer' IDENTIFIED BY 'loganalyzer';"
					 GRANTDATABASE2="GRANT USAGE ON *.* TO 'loganalyzer' IDENTIFIED BY 'loganalyzer';"
					 GRANTALL2="GRANT ALL PRIVILEGES ON loganalyzer.* TO 'loganalyzer';"
					 FLUSH2="FLUSH PRIVILEGES;"
					 #Criando o Banco de Dados e setando as informações de usuários e senha utilizando o comando mysql
					 mysql -u $USER -p$PASSWORD -e "$DATABASE2" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$USERDATABASE2" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$GRANTDATABASE2" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$GRANTALL2" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$FLUSH2" mysql &>> $LOG
					 echo -e "Base de dados do LogAnalyzer criada com sucesso!!!"
					 sleep 2
					 echo					 
					 
					 echo -e "Listando os Bancos de Dados criado do Rsyslog e LogAnalyzer, aguarde..."
					 #Criando a variável para exibição da Base de Dados do Rsyslog e LogAnalyzer
					 SHOWSQL="SHOW DATABASES;"
					 echo
					 #Listando a Base de Dados criada do Rsyslog e LogAnalyzer
					 mysql -u $USER -p$PASSWORD -e "$SHOWSQL" mysql
					 echo
					 echo -e "Base de dados listadas com sucesso!!!"
					 echo
					 echo -e "Criação da Base de Dados do Rsyslog e LogAnalyzer feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Atualizando os arquivos de Configuração do Rsyslog, aguarde..."
					 echo
					 
					 echo -e "Atualizando a Base de Dados do Rsyslog, aguarde..."
					 #Importando as tabelas da base de dados do Rsyslog
					 mysql -u $RSYSLOG -D syslog -p$RSYSLOG < /usr/share/dbconfig-common/data/rsyslog-mysql/install/mysql
					 echo -e "Atualização da Base de Dados feita com sucesso!!!, continuando o script"
					 echo
					 
					 echo -e "Atualizando o arquivo de configuração do Rsyslog.conf, aguarde..."
					 #Fazendo o backup de arquivo de configuração Rsyslog
					 cp -v /etc/rsyslog.conf /etc/rsyslog.conf.old  >> $LOG
					 #Atualizando o arquivo de configuração Rsyslog
					 cp -v conf/rsyslog.conf /etc/rsyslog.conf  >> $LOG
					 #Atualizando o arquivo de configuração do mysql
					 cp -v conf/mysql.conf /etc/rsyslog.d/mysql.conf >> $LOG
					 #Reinicializando o serviço do Rsyslog
					 sudo service rsyslog restart
					 echo
					 echo -e "Atualização dos arquivos de configuração do Rsyslog feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Baixando, instalando e configurando o LogAnalyzer, aguarde..."
					 #Download do LogAnalyzer
					 wget http://download.adiscon.com/loganalyzer/$LOGANALYZER >> $LOG
					 #Descompactando LogAnalyzer
					 tar -xzvf $LOGANALYZER >> $LOG
					 #Movendo o LogAnalyzer para o diretório /var/www/html/loganalyzer/
					 mv -v $LOGANALYZER/src/* /var/www/html/loganalyzer/ >> $LOG
					 #Atualização do arquivo config.php
					 cp -v conf/config.php /var/www/html/loganalyzer/ >> $LOG
					 #Alterando as permissões do arquico config.php
					 chmod -v 666 /var/www/html/loganalyzer/config.php >> $LOG
					 #Alterando o dono e grupo do diretório loganalyzer
					 chown -Rv www-data.www-data /var/www/html/loganalyzer/ >> $LOG
					 echo -e "Instalação feita com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Fim do Script-24.sh em: `date`" >> $LOG
					 echo -e "                Finalização da Configuração do LogAnalyzer"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-24.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-24.sh: $TEMPO"
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
