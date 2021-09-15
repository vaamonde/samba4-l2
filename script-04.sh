#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 23/07/2020
# Versão: 0.11
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
# PhpLDAPAdim está com falha para autenticar no SAMBA-4, fazendo os teste para finalização dessa configuração, 
# recurso retirado do script de instalação
# Mais informações: https://wiki.samba.org/index.php/Samba4/LDAP_Backend/OpenLDAP
#
# Indicação de outro software que tem mais recursos: Fusion Directory projeto fake do GOsa.
# Site: https://www.fusiondirectory.org/
#
# Outro software que está sendo testado para essa utilização o Easy LDAP Manager
# Site: https://www.ldap-account-manager.org/lamcms/
#
# Outro software que está sendo testado para essa utilização e o LDAPAdmin com suporte ao SAMBA-4 a partir da 
# versão 1.8.
# Site: http://www.ldapadmin.org/
#
# Outro software que está sendo testado para essa utilizando e o LDAP Account Manager com suporte ao SAMBA-4 a 
# partir da versão 6.0
# Site: https://www.ldap-account-manager.org/lamcms/
#
# Software para alteração de Senhas via Web
# Site: https://ltb-project.org/doku.php
#
# Configurações do Apache2 e MySQL customizadas para Alto-Desempenho (Tuning)
#
# Utilizar o comando: sudo -i para executar o script
#
# Variável do caminho do Log dos Script utilizado nesse curso (VARIÁVEL MELHORADA)
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel (VARIÁVEL MELHORADA)
# opções do comando id: -u (user)
# opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release)
# opções do comando cut: -d (delimiter), -f (fields)
# opção do shell script: piper | = Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opção do shell script: aspas duplas " " = Protege uma string, mas reconhece $, \ e ` como especiais
USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)
KERNEL=$(uname -r | cut -d'.' -f1,2)
#
# Verificando se o usuário é Root, Distribuição é >=16.04 e o Kernel é >=4.4 <IF MELHORADO)
# [ ] = teste de expressão, && = operador lógico AND, == comparação de string, exit 1 = A maioria dos erros comuns na execução
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "16.04" ] && [ "$KERNEL" == "4.4" ]
	then
		echo -e "O usuário é Root $USUARIO, continuando com o script..."
		echo -e "Distribuição é >= $UBUNTU, continuando com o script..."
		echo -e "Kernel é >= $KERNEL, continuando com o script..."
		sleep 5
		clear
	else
		echo -e "Usuário não é Root ($USUARIO) ou Distribuição não é >=16.04.x ($UBUNTU) ou Kernel não é >=4.4 ($KERNEL)"
		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script $0 para verificar o ambiente e continuar com a instalação"
		exit 1
fi
#
# Exportação da variável de configuração do MySQL
# opção do comando GRANT: grant (permissão), all (todos privilégios), on (em ou na | banco ou tabela), *.* (todos os bancos/tabelas)
# to (para), user@'%' (usuário @ localhost), identified by (identificado por - senha do usuário)
# opção do comando FLUSH: privileges (recarregar as permissões)
PASSWORD="pti@2016"
AGAIN="pti@2016"
USER="root"
GRANTALL="GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'pti@2016';"
FLUSH="FLUSH PRIVILEGES;"
#
# Exportação da variável de configuração do ProFTPD
INETD="standalone"
#
# Exportação da variável de configuração do PhpMyAdmin
APP_PASSWORD="pti@2016"
ADMIN_PASS="pti@2016"
APP_PASS="pti@2016"
WEBSERVER="apache2"
ADMINUSER="root"
#
#
# Exportando a variável do Debian Frontend Noninteractive para não solicitar interação com o usuário
export DEBIAN_FRONTEND="noninteractive"
#
# Script de instalação dos principais pacotes de rede e suporte ao sistema de arquivos (SCRIPT MELHORADO, REMOÇÃO DA TABULAÇÃO)
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando: &>> (redireciona a saída padrão, anexando)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
#				 
echo -e "Usuário é `whoami`, continuando a executar o script $0"
echo
echo -e "Instalando os Software para o Sistema de Gestão ERP"
echo
echo -e "APACHE (Apache HTTP Server) -Servidor de Hospedagem de Páginas web"
echo -e "Após a instalação do Apache2 acessar a URL: http://`hostname -I`/"
echo -e "MYSQL (SGBD) - Sistemas de Gerenciamento de Banco de Dados"
echo -e "PHP (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web"
echo -e "PERL - Linguagem de programação multi-plataforma"
echo -e "PYTHON - Linguagem de programação de alto nível"
echo -e "PhpMyAdmin - Aplicativo desenvolvido em PHP para administração do MySQL pela Internet"
echo -e "Após a instalação do PhpMyAdmin acessar a URL: http://`hostname -I`/phpmyadmin"
#echo -e "PhpLDAPAdmin - Aplicativo desenvolvido em PHP para administração do LDAP SAMBA4 pela Internet"
#echo -e "Após a instalação do PhpLDAPAdmin acessar a URL: http://`hostname -I`/phpldapadmin"
echo -e "ProFTPD - Servidor de Transferência de Arquivos"
echo
echo -e "Após o término do script $0 o Servidor não será reinicializado"
echo
echo ============================================================ >> $LOG

echo -e "Atualizando as Listas do Apt-Get, aguarde..."
	# Atualizando as listas do apt-get
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	apt-get update &>> $LOG
echo -e "Listas Atualizadas com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Atualizando o Sistema, aguarde..."
	# Fazendo a atualização de todos os pacotes instalados no servidor
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -o (option), -q (quiet), -y (yes)
	apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
echo -e "Sistema Atualizado com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Instalando o LAMP-SERVER, aguarde..."
echo

echo -e "Configurando as variáveis do MySQL para o apt-get, aguarde..."
	# Configurando as variáveis do Debconf para a instalação do MySQL em modo Noninteractive
	# Mostrando as configuração do Debconf para o MySQL
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando: | piper (conecta a saída padrão com a entrada padrão de outro comando)
	echo "mysql-server-5.7 mysql-server/root_password password $PASSWORD" |  debconf-set-selections
	echo "mysql-server-5.7 mysql-server/root_password_again password $AGAIN" |  debconf-set-selections
	debconf-show mysql-server-5.7 >> $LOG
echo -e "Variáveis configuradas com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Instalando o LAMP Server, aguarde..."
	# Instalando o LAMP-Server com as variáveis do MySQL
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes)
	apt-get -y install lamp-server^ perl python links2 &>> $LOG
echo -e "Instalação do LAMP-SERVER Feito com Sucesso!!!, continuando o script..."
echo
sleep 2
echo ============================================================ >> $LOG

echo -e "Instalação do Servidor de ProFTPD, aguarde..."
echo

echo -e "Configurando as variáveis do ProFTPD para o apt-get, aguarde..."
	# Configurando as variáveis do Debconf para a instalação do ProFTPD em modo Noninteractive
	# Mostrando as configuração do Debconf para o ProFTPD
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando: | piper (conecta a saída padrão com a entrada padrão de outro comando)
	echo "proftpd-basic shared/proftpd/inetd_or_standalone select $INETD" |  debconf-set-selections
	debconf-show proftpd-basic >> $LOG
echo -e "Variáveis configuradas com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Instalando o ProFTPD, aguarde..."
	# Instalando o ProFTPD Server
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes)
	apt-get -y install proftpd &>> $LOG
echo -e "Instalação do ProFTPD Feito com Sucesso!!!, continuando o script..."
echo
sleep 2
echo ============================================================ >> $LOG

echo -e "Instalando o PhpMyAdmin, aguarde..."
echo

echo -e "Configurando as variáveis do PhpMyAdmin para o apt-get, aguarde..."
	# Configurando as variáveis do Debconf para a instalação do PhpMyAdmin em modo Noninteractive
	# Mostrando as configuração do Debconf para o PhpMyAdmin
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando: | piper (conecta a saída padrão com a entrada padrão de outro comando
	echo "phpmyadmin phpmyadmin/internal/skip-preseed boolean true" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/app-password-confirm password $APP_PASSWORD" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect $WEBSERVER" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-user string $ADMINUSER" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/admin-pass password $ADMIN_PASS" |  debconf-set-selections
	echo "phpmyadmin phpmyadmin/mysql/app-pass password $APP_PASS" |  debconf-set-selections
	debconf-show phpmyadmin >> $LOG
echo -e "Variáveis configuradas com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Instalando o PhpMyAdmin, aguarde..."
	# Instalando o PhpMyAdmin
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes)
	apt-get -y install phpmyadmin php-mbstring php-gettext &>> $LOG
echo -e "Instalação do PhpMyAdmin feita com sucesso!!!, continuando o script..."
sleep 2
echo
					
echo -e "Atualizando as Dependências do PHP para o PhpMyAdmin, aguarde..."
	# Atualizando as dependências do PhpMyAdmin, ativando os recursos de módulos do PHP no Apache2
	phpenmod mcrypt
	phpenmod mbstring
echo -e "Atualização feita com sucesso!!!, continuando o script..."
sleep 2
echo
		
echo -e "Serviços instalando com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Atualizando as configurações do Apache2, aguarde..."
echo -e "Pressione <Enter> para continuar"
read
sleep 2

echo -e "Fazendo o backup do arquivo apache2.conf, aguarde..."
	# Fazendo o backup do Apache2.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v /etc/apache2/apache2.conf /etc/apache2/apache2.conf.old &>> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo apache2.conf, aguarde..."
	# Atualizando o arquivo do Apache2.conf customizado
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/apache2.conf /etc/apache2/apache2.conf &>> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Fazendo o backup do arquivo 000-default.conf, aguarde..."
	# Fazendo o backup do 000-default.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.old &>> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo 000-default.conf, aguarde..."
	# Atualizando o arquivo 00-default.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/000-default.conf /etc/apache2/sites-available/000-default.conf &>> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Fazendo o backup do arquivo php.ini, aguarde..."
	# Backup do arquivo php.ini
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v /etc/php/7.0/apache2/php.ini /etc/php/7.0/apache2/php.ini.old &>> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo php.ini, aguarde..."
	# Atualizando o arquivo do php.ini
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/php.ini /etc/php/7.0/apache2/php.ini &>> $LOG
echo -e "Atualização feita com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Arquivos atualizado com sucesso!!!, pressione <Enter> para continuar."
read
clear

echo -e "Editando o arquivo apache2.conf, pressione <Enter> para continuar"
read
	# Editando o arquivo apache2.conf
	vim /etc/apache2/apache2.conf
echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
read
sleep 2
clear

echo -e "Editando o arquivo 000-default.conf, pressione <Enter> para continuar"
read
	# Editando o arquivo 000-default.conf
	vim /etc/apache2/sites-available/000-default.conf
echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
read
sleep 2
clear

echo -e "Editando o arquivo php.ini, pressione <Enter> para continuar"
read
	# Editando o arquivo php.ini
	vim /etc/php/7.0/apache2/php.ini
echo
sleep 2

echo -e "Reinicializando o serviço do Apache2, aguarde..."
	# Reinicializando o serviço do Apache2 Server
	sudo service apache2 restart
echo -e "Serviço reinicializado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "APACHE2 configurado com sucesso!!!, pressione <Enter> para continuar"
read
sleep 2
clear

echo ============================================================ &>> $LOG
echo -e "Permitir acesso remoto ao MySQL Server"
echo
echo -e "Comente a linha: bind-address 127.0.0.1"
echo
echo -e "Pressione <Enter> para editar o arquivo"
read
echo

echo -e "Fazendo o backup do arquivo mysqld.cnf, aguarde..."
	# Fazendo o backup do arquivo mysqld.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	mv -v /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.old &>> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo do mysqld.cnf, aguarde..."
	# Atualizando o arquivo das configuração do mysqld.cnf customizado
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf &>> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo mysqld.cnf, aguarde..."
	sleep 3
	# Editando o arquivo do mysqld.conf
	vim /etc/mysql/mysql.conf.d/mysqld.cnf
	sleep 3
echo

echo -e "Permitindo o usuário Root se logar remotamente no servidor de MySQL, aguarde..."
	# Permitindo o usuário Root acessar o servidor do MySQL remoto
	# Alterando o Banco de Dados do MySQL
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mysql: -u (user), -p (password), -e (execute)
	mysql -u $USER -p$PASSWORD -e "$GRANTALL" mysql &>> $LOG
	mysql -u $USER -p$PASSWORD -e "$FLUSH" mysql &>> $LOG
echo -e "Permissão aplicada com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Testando as configurações do MySQLD, aguarde..."
	echo
	# Verificando as configurações do servidor de MySQL
	# opção do comando: | piper (conecta a saída padrão com a entrada padrão de outro comando)
	mysqld --help --verbose | grep /etc 
	echo
echo -e "Arquivo testado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Reinicializando o servidor do MySQL, aguarde..."
	# Reinicializando o serviço do MySQL Server
	sudo service mysql restart
echo -e "Serviços do MySQL reinicializado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "MYSQLD configurado com sucesso!!!, pressione <Enter> para continuar"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Testando o Apache2 Server é o suporte ao PHP"
echo
echo -e "Pressione <Enter> para abrir a página de teste"
echo
echo -e "Pressione Q para sair"
read
echo

echo -e "Copiando o arquivo phpinfo.php, aguarde..."
	# Copiando o arquivo phpinfo.php para testar o servidor Apache2 e também o suporte ao PHP
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/phpinfo.php /var/www/html >> $LOG
echo -e "Arquivo copiado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Abrindo o arquivo phpinfo.php, aguarde..."
sleep 3
	# Utilizando o navegador de modo texto links2 para testar a página em PHP
	links2 http://localhost/phpinfo.php
echo

echo -e "Teste do Apache2 e PHP feito com sucesso!!!, pressione <Enter> para continuar"
read
sleep 2
echo ============================================================ >> $LOG

echo -e "Fim do script $0 em: `date`" >> $LOG
echo
echo -e "Instalação do LAMP-SERVER Feito com Sucesso!!!!!"
echo
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=$(date +%T)
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=$(date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S")
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo de configuração do Servidor."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
read
sleep 5