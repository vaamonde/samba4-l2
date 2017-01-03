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
# Instalação do Wordpress para simulação de Sistema de ERP
# Criação de Base de Dados no MySQL
# Criação de Registros CNAME no DNS
# Criação do Virtual Host no Apache2
# Configuração do ProFTPD
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-18.sh
LOG="/var/log/script-18.log"
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
					 #Declarando as variaveis para o ambiente
					 ADMIN="administrator"
					 PASSWORD="pti@2016"
					 FQDN="`hostname`"
					 ZONE="`hostname -d`"
					 WORDPRESS="https://wordpress.org/latest.zip"
					 TAMANHO="8.0 MB"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-18.sh"
					 echo
					 echo -e "Rodando o Script-18.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                 Instalação e Configuração do Sistema de ERP"
					 echo -e "================================================================================="
					 echo
					 
					 echo -e "Criação dos CNAME: WWW, FTP, SSH e MYSQL no DNS do SAMBA4"
					 echo -e "Pressione <Enter> para criar os CNAME"
					 read
					 #Criando os CNAMES (apelidos) no DNS do SAMBA-4 utilizando o comando samba-tool
					 samba-tool dns add $FQDN $ZONE www CNAME $FQDN -U $ADMIN --password=$PASSWORD &>> $LOG
					 samba-tool dns add $FQDN $ZONE ftp CNAME $FQDN -U $ADMIN --password=$PASSWORD &>> $LOG
					 samba-tool dns add $FQDN $ZONE ssh CNAME $FQDN -U $ADMIN --password=$PASSWORD &>> $LOG
					 samba-tool dns add $FQDN $ZONE mysql CNAME $FQDN -U $ADMIN --password=$PASSWORD &>> $LOG
					 #Listando os CNAMEs (apelidos) criados no DNS do SAMBA-4 utilizando o comando samba-tool com filtro
					 echo
					 samba-tool dns query $FQDN $ZONE @ ALL -U $ADMIN --password=$PASSWORD | grep 'Name=[wfsm]'
					 echo
					 echo -e "Criação feita com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Download e instalação básica do Wordpress no servidor: `hostname`"
					 echo -e "Tamanho do arquivo: $TAMANHO, pressione <Enter> para continuar"
					 read
					 echo
					 
					 echo -e "Fazendo o download do: $WORDPRESS aguarde..."
					 #Fazendo o download do arquivo do Wordpress
					 wget $WORDPRESS &>> $LOG
					 echo -e "Download feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Descompactando o arquivo latest.zip"
					 #Descompactando o arquivo do Wordpress
				     	 unzip latest.zip &>> $LOG
					 echo -e "Descompactação feita com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Copiando os arquivo do Wordpress para a pasta de sistema/erp"
					 #Movendo o contéudo da pasta do wordpress para o diretório erp
					 mv -v wordpress/ /arquivos/pti.intra/sistema/erp &>> $LOG
					 #Copiando o arquivo htaccess customizado
					 cp -v conf/htaccess /arquivos/pti.intra/sistema/erp/.htaccess &>> $LOG
					 #Copiando o arquivo de configuração wp-config.php
					 cp -v conf/wp-config.php /arquivos/pti.intra/sistema/erp/ &>> $LOG
					 echo -e "Arquivos copiados com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões dos arquivos da pasta sistema/erp"
					 #Alterando as permissões de dono, grupo e outros recursivo no diretório erp
					 chmod -Rfv 755 /arquivos/pti.intra/sistema/erp &>> $LOG
					 #Alterando o dono é o grupo recursivo no diretório erp
					 chown -Rfv www-data.www-data /arquivos/pti.intra/sistema/erp &>> $LOG
					 echo -e "Permissões alteradas com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e ""
					 #Removendo o arquivo de download zipado do Wordpress
					 rm -v latest.zip >> $LOG
					 echo
					 echo -e "Instalação Básica do Wordpress feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Criação da Base de Dados do Wordpress no servidor: `hostname`"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 #Criando a variável da criação da Base de Dados do Wordpress
					 #Variaveis utilizada pelo MySQL para a criação do Bando de Dados
					 USER="root"
					 DATABASE="CREATE DATABASE wordpress;"
					 USERDATABASE="CREATE USER 'wordpress' IDENTIFIED BY 'wordpress';"
					 GRANTDATABASE="GRANT USAGE ON *.* TO 'wordpress' IDENTIFIED BY 'wordpress';"
					 GRANTALL="GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress';"
					 FLUSH="FLUSH PRIVILEGES;"
					 #Criando o Banco de Dados e setando as informações de usuários e senha utilizando o comando mysql
					 mysql -u $USER -p$PASSWORD -e "$DATABASE" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$USERDATABASE" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$GRANTDATABASE" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
					 mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG
					 echo
					 echo -e "Listando o Banco de Dados Criado"
					 #Criando a variável para exibição da Base de Dados do Wordpress
					 SHOWSQL="SHOW DATABASES;"
					 echo
					 #Listando a Base de Dados criada do Wordpress
					 mysql -u $USER -p$PASSWORD -e "$SHOWSQL" mysql
					 echo
					 echo -e "Criação da Base de Dados do Wordpress feita com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo de conexão com o Banco de Dados do Wordpress"
					 echo -e "Editando as variaveis do arquivos wp-config.php com as informações"
					 echo -e "DB_NAME='wordpress'       base de dados do MySQL"
					 echo -e "DB_USER='wordpress'       usuário de conexão a bade de dados"
					 echo -e "DB_PASSWORD='wordpress'   senha do usuário de conexão"
					 echo -e "DB_HOST='localhost'       endereço do servidor, recomendado localhost"
					 echo -e "DB_CHARSET='utf8'         configurações de caracteres"
					 echo -e "DB_COLLATE=''             sem collate"
					 echo -e "Pressione <Enter> para editar o arquivo: wp-config.php"
					 read
					 #Editando o arquivo de configuração wp-config.php
					 vim /arquivos/pti.intra/sistema/erp/wp-config.php +16
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Criando o Virtual Host no Apache2"
					 echo -e "Pressione <Enter> para criar é editar o arquivo do Virtual Host ERP"
					 #Copiando o arquivo de configuração pti-intra.conf
					 cp -v conf/pti-intra.conf /etc/apache2/sites-available/ >> $LOG
					 #Editando o arquivo de configuração pti-intra.conf
					 vim /etc/apache2/sites-available/pti-intra.conf +12
					 echo -e "Ativando o Virtual Host no Apache2"
					 #Ativando o Virtual Host no Apache2 Server
					 a2ensite pti-intra.conf &>> $LOG
					 #Reinicializando o serviço do Apache Server
					 sudo service apache2 restart &>> $LOG
					 #Atualizando o arquivo apache2.conf com a variável ServerName
					 echo ServerName localhost >> /etc/apache2/apache2.conf
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para testar o Apache2"
					 read
					 echo
					 apache2ctl -V
					 echo
					 echo -e "Finalização da configuração do Apache2 com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear

					 echo -e "Configuração do Servidor ProFTPD"
					 echo -e "Pressione <Enter> para editar o arquivos de configuração"
					 read
					 sleep 2
					 #Fazendo o backup do arquivo de configuração proftpd.conf
					 mv -v /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.old >> $LOG
					 #Copiando o arquivo de configuração do proftpd.conf
					 cp -v conf/proftpd.conf /etc/proftpd/ >> $LOG
					 #Editando o arquivo de configuração do proftpd.conf
					 vim /etc/proftpd/proftpd.conf
					 #Reinicializando o serviço do ProFTPD Server
					 sudo service proftpd restart
					 echo -e "Verificando as configurações do ProFTPD, pressione <Enter>"
					 read
					 echo
					 proftpd -t				 
					 echo
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Criando o usuário Wordpress com pasta base no sistema de ERP e Grupo www-data"
					 #Criando o usuário que será utilizado para acessar o FTP no servidor, utilizando o comando useradd
					 useradd -d /arquivos/pti.intra/sistema/erp -s /bin/bash -M wordpress -G www-data &>> $LOG
					 echo
					 echo -e "Usuário criando com sucesso!!!, continuando o script"
					 echo
					 echo -e "Setando a senha para o usuário: wordpress - senha padrão: wordpress"
					 #Setando a senha padrão para o usuário wordpress com o comando passwd
					 echo -e "wordpress\nwordpress" | passwd wordpress &>> $LOG
					 echo
					 echo -e "Senha setada com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-18.sh em: `date`" >> $LOG
					 echo -e "                 Instalação e Configuração do Sistema de ERP"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-18.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-18.sh: $TEMPO"
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
