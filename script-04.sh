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
# Instalação dos pacotes principais para a quinta etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# APACHE (Apache HTTP Server) -Servidor de Hospedagem de Páginas web
# MYSQL (SGBD) - Sistemas de Gerenciamento de Banco de Dados
# PHP (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web
# PERL - Linguagem de programação multiplataforma
# PYTHON - Linguagem de programação de alto nível
# PhpMyAdmin - Aplicativo desenvolvido em PHP para administração do MySQL pela Internet
# PhpLDAPAdmin - Aplicativo desenvlvido em PHP para administração do LDAP SAMBA4 pela Internet
#
# Configuração do MySQL
#	será solicitado a senha do ROOT do MySQL
#
# Configuração do ProFTPD
#	será solicitado o tipo de inicialização do sistema, escolha: standalone
#
# Configuração do PhpMyAdmin
#	será solicitado o tipo do servidor web, escolha: apache2
#	será solicitado para configurar a base de dados do PhpMyAdmin, escolha: yes
#	será solicitado a senha do PhpMyAdmin, digite uma senha
#
# PhpLDAPAdim está com falha para autenticar no SAMBA-4, fazendo os teste para finalização dessa configuração.
# Mais informações: https://wiki.samba.org/index.php/Samba4/LDAP_Backend/OpenLDAP
# Indicação de outro software que tem mais recursos: Fusion Directory projeto fake do GOsa.
# Site: https://www.fusiondirectory.org/
# Outro software que está sendo testado para essa utilização o Easy LDAP Manager
# Site: https://www.ldap-account-manager.org/lamcms/
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-04.sh
LOG="/var/log/script-04.log"
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
					 # Variáveis de configuração do MySQL
					 PASSWORD="pti@2016"
					 AGAIN="pti@2016"
					 #
					 # Variáveis de configuração do ProFTPD
					 INETD="standalone"
					 #
					 # Variáveis de configuração do PhpMyAdmin
					 APP_PASSWORD="pti@2016"
					 ADMIN_PASS="pti@2016"
					 APP_PASS="pti@2016"
					 WEBSERVER="apache2"
					 ADMINUSER="root"
					 #
					 # Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND="noninteractive"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-04.sh"
					 echo
					 echo -e "Instalando os software para o Sistema de Gestão ERP"
					 echo -e "APACHE (Apache HTTP Server) -Servidor de Hospedagem de Páginas web"
					 echo -e "Após a instalação do Apache2 acessar a URL: http://`hostname -I`/"
					 echo -e "MYSQL (SGBD) - Sistemas de Gerenciamento de Banco de Dados"
					 echo -e "PHP (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web"
					 echo -e "PERL - Linguagem de programação multi-plataforma"
					 echo -e "PYTHON - Linguagem de programação de alto nível"
					 echo -e "PhpMyAdmin - Aplicativo desenvolvido em PHP para administração do MySQL pela Internet"
					 echo -e "Após a instalação do PhpMyAdmin acessar a URL: http://`hostname -I`/phpmyadmin"
					 echo -e "PhpLDAPAdmin - Aplicativo desenvlvido em PHP para administração do LDAP SAMBA4 pela Internet"
					 echo -e "Após a instalação do PhpLDAPAdmin acessar a URL: http://`hostname -I`/phpldapadmin"
					 echo -e "ProFTPD - Servidor de Transferência de Arquivos"
					 echo -e "Aguarde..."
					 echo
					 echo -e "Rodando o Script-04.sh em: `date`" > $LOG
					 
					 echo -e "Atualizando as Listas do Apt-Get" >> $LOG
					 echo -e "Atualizando as Listas do Apt-Get"
					 #Atualizando as listas do apt-get
					 apt-get update &>> $LOG
					 echo -e "Listas Atualizadas com Sucesso!!!"
					 echo
					 echo -e "Listas Atualizadas com Sucesso!!!" >> $LOG
					 echo >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o Sistema" >> $LOG
					 echo -e "Atualizando o Sistema"
					 #Fazendo a atualização de todos os pacotes instalados no servidor
					 apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
					 echo -e "Sistema Atualizado com Sucesso!!!"
					 echo
					 echo -e "Sistema Atualizado com Sucesso!!!" >> $LOG
					 echo >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Instalando o LAMP-SERVER" >> $LOG
					 echo -e "Instalando o LAMP-SERVER"
					 #Configurando as variáveis do Debconf para a instalação do MySQL em modo Noninteractive
					 echo "mysql-server-5.7 mysql-server/root_password password $PASSWORD" |  debconf-set-selections
					 echo "mysql-server-5.7 mysql-server/root_password_again password $AGAIN" |  debconf-set-selections
					 echo  >> $LOG
					 #Mostrando as configuração do Debconf para o MySQL
					 debconf-show mysql-server-5.7 >> $LOG
					 echo  >> $LOG
					 #Instalando o MySQL Server
					 apt-get -y install lamp-server^ perl python phpldapadmin links2 &>> $LOG
					 echo -e "Instalação do LAMP-SERVER Feito com Sucesso!!!"
					 echo
					 echo -e "Instalação do LAMP-SERVER Feito com Sucesso!!!" >> $LOG
					 echo >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Instalando o ProFTPD" >> $LOG
					 echo -e "Instalando o ProFTPD"
					 #Configurando as variáveis do Debconf para a instalação do ProFTPD em modo Noninteractive
					 echo "proftpd-basic shared/proftpd/inetd_or_standalone select $INETD" |  debconf-set-selections
					 echo  >> $LOG
					 #Mostrando as configuração do Debconf para o ProFTPD
					 debconf-show proftpd-basic >> $LOG
					 echo  >> $LOG
					 #Instalando o ProFTPD Server
					 apt-get -y install proftpd &>> $LOG
					 echo -e "Instalação do ProFTPD Feito com Sucesso!!!"
					 echo
					 echo -e "Instalação do ProFTPD Feito com Sucesso!!!" >> $LOG
					 echo >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Instalando o PhpMyAdmin" >> $LOG
					 echo -e "Instalando o PhpMyAdmin"
					 #Configurando as variáveis do Debconf para a instalação do PhpMyAdmin em modo Noninteractive
					 echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" |  debconf-set-selections
					 echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" |  debconf-set-selections
					 echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASSWORD" |  debconf-set-selections
					 echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect $WEBSERVER" |  debconf-set-selections
					 echo "phpmyadmin phpmyadmin/mysql/admin-user string $ADMINUSER" |  debconf-set-selections
					 echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ADMIN_PASS" |  debconf-set-selections
					 echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_PASS" |  debconf-set-selections
					 echo  >> $LOG
					 #Mostrando as configuração do Debconf para o PhpMyAdmin
					 debconf-show phpmyadmin >> $LOG
					 echo  >> $LOG
					 #Instalando o PhpMyAdmin
					 apt-get -y install phpmyadmin php-mbstring php-gettext &>> $LOG
					 echo  >> $LOG
					 echo -e "Atualizando as Dependências do PHP para o PhpMyAdmin" >> $LOG
					 #Atualizando as dependências do PhpMyAdmin, ativando os recursos de módulos do PHP no Apache2
					 phpenmod mcrypt
					 phpenmod mbstring
					 #Reinicializando o serviço do Apache2 Server
					 sudo service apache2 restart
					 echo -e "Instalação do PhpMyAdmin Feito com Sucesso!!!"
					 echo
					 echo -e "Instalação do PhpMyAdmin Feito com Sucesso!!!" >> $LOG
					 echo >> $LOG
					 
					 echo -e "Serviços instalando com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG
					 
					 echo -e "Permitir acesso remoto ao MySQL Server"
					 echo -e "Comente a linha: bind-address 127.0.0.1"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 #Fazendo o backup do arquivo mysqld.conf
					 cp -v /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.old
					 #Editando o arquivo do mysqld.conf
					 vim /etc/mysql/mysql.conf.d/mysqld.cnf +43
					 #Permitindo o usuário Root acessar o servidor do MySQL remoto
					 #Criando as variáveis para o MySQL
					 USER="root"
					 GRANTALL="GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'pti@2016';"
					 #Alterando o Banco de Dados do MySQL
					 mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
					 #Reinicializando o serviço do MySQL Server
					 sudo service mysql restart
					 echo -e "MySQL configurado com sucesso, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Testando o Apache2 Server é o suporte ao PHP"
					 echo -e "Pressione <Enter> para abrir a página de teste"
					 echo -e "Pressione Q para sair"
					 read
					 echo >> $LOG
					 #Copiando o arquivo phpinfo.php para testar o servidor Apache2 e também o suporte ao PHP
					 cp -v conf/phpinfo.php /var/www/html >> $LOG
					 #Utilizando o navegador de modo texto links2 para testar a página em PHP
					 links2 http://localhost/phpinfo.php
					 echo -e "Teste do Apache e PHP feito com sucesso, pressione <Enter> para continuar"
					 read
					 sleep 2
					 echo >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Fim do Script-04.sh em: `date`" >> $LOG

					 echo
					 echo -e "Instalação do LAMP-SERVER Feito com Sucesso!!!!!"
					 echo
					 # Script para calcular o tempo gasto para a execução do script-04.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-04.sh: $TEMPO"
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
