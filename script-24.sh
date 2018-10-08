#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 02/10/2018
# Data de atualização: 08/10/2018
# Versão: 0.4
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
					 RSYSLOG="syslog"
					 LOGANALYZER="loganalyzer-4.1.6.tar.gz"
					 FILELOGANALYZER="loganalyzer-4.1.6"
					 
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
					 echo
					 
					 echo -e "Atualizando as listas do apt-get, aguarde..."
					 apt-get update &>> $LOG
					 echo -e "Listas atualizadas com sucesso!!!!, continuando o script.."
					 echo
					 
					 echo -e "Instalando as dependências do LogAnalyzer, aguarde..."
					 #Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND="noninteractive"
					 #Configuração as variáveis do deconf para não aparecer a tela de confirmação da base dedados
					 echo "rsyslog-mysql rsyslog-mysql/dbconfig-install boolean false" |  debconf-set-selections
					 #Instalando a dependência do LogAnalyzer
					 apt-get -y install rsyslog-mysql &>> $LOG
					 echo -e "Dependências instaladas com sucesso!!!, pressione <Enter> para continuar"
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
					 echo -e "Base de dados do Rsyslog criada com sucesso!!!, continuando o script..."
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
					 echo -e "Base de dados do LogAnalyzer criada com sucesso!!!, continuando o script..."
					 sleep 2
					 echo					 
					 
					 echo -e "Listando os Bancos de Dados criado do Rsyslog e LogAnalyzer, aguarde..."
					 #Criando a variável para exibição da Base de Dados do Rsyslog e LogAnalyzer
					 SHOWSQL="SHOW DATABASES;"
					 echo
					 #Listando a Base de Dados criada do Rsyslog e LogAnalyzer
					 mysql -u $USER -p$PASSWORD -e "$SHOWSQL" mysql
					 echo
					 echo -e "Base de dados listadas com sucesso!!!, continuando o script..."
					 echo
					 echo -e "Criação da Base de Dados do Rsyslog e LogAnalyzer feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Atualizando os arquivos de Configuração do Rsyslog, aguarde..."
					 echo
					 
					 echo -e "Atualizando a Base de Dados do Rsyslog, aguarde..."
					 #Importando as tabelas da base de dados do Rsyslog
					 mysql -u$RSYSLOG -D syslog -p$RSYSLOG < /usr/share/dbconfig-common/data/rsyslog-mysql/install/mysql
					 echo -e "Atualização da Base de Dados feita com sucesso!!!, continuando o script"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando os arquivos de configuração do Rsyslog.conf, aguarde..."
					 
					 echo -e "Fazendo o backup do arquivo de configuração Rsyslog, aguarde..."
					 #Fazendo o backup do arquivo de configuração Rsyslog
					 cp -v /etc/rsyslog.conf /etc/rsyslog.conf.old  >> $LOG
					 echo -e "Backup do arquivo feito com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo de configuração Rsyslog, aguarde..."
					 #Atualizando o arquivo de configuração Rsyslog
					 cp -v conf/rsyslog.conf /etc/rsyslog.conf  >> $LOG
					 echo -e "Atualização do arquivo feito com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Fazendo o backup do arquivo de configuração do MySQL, aguarde..."
					 #Fazendo o backup do arquivo de configuração do MySQL
					 cp -v /etc/rsyslog.d/mysql.conf /etc/rsyslog.d/mysql.conf.old >> $LOG
					 echo -e "Backup do arquivo feito com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo de configuração do MySQL, aguarde..."
					 #Atualizando o arquivo de configuração do mysql
					 cp -v conf/mysql.conf /etc/rsyslog.d/mysql.conf >> $LOG
					 echo -e "Atualização do arquivo feito com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Reinicializando o serviço do Rsyslog, aguarde..."
					 #Reinicializando o serviço do Rsyslog
					 sudo service rsyslog restart
					 echo -e "Reinicialização do serviço feita com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualização dos arquivos de configuração do Rsyslog e MySQL feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo de configuração do Rsyslog, pressione <Enter> para continuar..."
					 read
					 sleep 2
					 
					 #Editando o arquivo de configuração
					 vim /etc/rsyslog.conf
					 
					 echo -e "Arquivo editado com successo!!!!, pressione <Enter> para continuar..."
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo de configuração do MySQL, pressione <Enter> para continuar..."
					 read
					 sleep 2
					 
					 #Editando o arquivo de configuração
					 vim /etc/rsyslog.d/mysql.conf
					 
					 echo -e "Arquivo editado com successo!!!!, pressione <Enter> para continuar..."
					 read
					 sleep 2
					 clear
					 
					 echo -e "Baixando, instalando e configurando o LogAnalyzer, aguarde..."
					 sleep 2
					 echo
					 
					 echo -e "Download do arquivo do LogAnalyzer, aguarde..."
					 #Download do LogAnalyzer
					 wget http://download.adiscon.com/loganalyzer/$LOGANALYZER &>> $LOG
					 echo -e "Download feito com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Descompactando o arquivo do LogAnalyzer, aguarde..."
					 #Descompactando LogAnalyzer
					 tar -xzvf $LOGANALYZER &>> $LOG
					 echo -e "Descompactação feita com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Criando o diretório do LogAnalyzer, aguarde..."
					 #Criando o diretório do LogAnalyzer
					 mkdir -v /var/www/html/loganalyzer/ >> $LOG
					 echo -e "Diretório criado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Movendo o diretório do LogAnalyzer, aguarde..."
					 #Movendo o LogAnalyzer para o diretório /var/www/html/loganalyzer/
					 mv -v $FILELOGANALYZER/src/* /var/www/html/loganalyzer/ >> $LOG
					 echo -e "Diretório movido com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Criando o arquivo de configuração do LogAnalyzer, aguarde..."
					 #Criando o arquivo config.php
					 touch /var/www/html/loganalyzer/config.php >> $LOG
					 echo -e "Arquivo criado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do arquivo de configuração do LogAnalyzer, aguarde..."
					 #Alterando as permissões do arquico config.php
					 chmod -v 666 /var/www/html/loganalyzer/config.php >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do diretório do LogAnalyzer, aguarde..."
					 #Alterando o dono e grupo do diretório loganalyzer
					 chown -Rv www-data.www-data /var/www/html/loganalyzer/ >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Instalação feita com sucesso!!!, pressione <Enter> para continuar com o script"
					 echo -e "Finalizar a instalação acessando a URL: http://`hostname`/loganalyzer/"
					 read
					 sleep 2
					 
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
