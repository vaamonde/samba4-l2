#!/bin/bash
#Atualização das Listas do Apt-Get
apt-get update

#Atualização do Sistema
apt-get upgrade

#Atualização da Versão do Kernel
apt-get dist-upgrade

#Instalação do Servidor LAMP com suporte ao Perl e PHP para o Servidor OCS Inventory
apt-get install make lamp-server^ perl libapache2-mod-perl2 libapache2-mod-php snmp libio-compress-perl libxml-simple-perl libdbi-perl libdbd-mysql-perl libapache-dbi-perl libsoap-lite-perl libnet-ip-perl php-mysql php-gd php7.0-dev php-mbstring php-soap php7.0-zip php7.0-gd

#Configuração das Dependências do Perl
perl -MCPAN -e 'install XML::Entities'
perl -MCPAN -e 'install SOAP::Lite'
perl -MCPAN -e 'install XML::Simple'
perl -MCPAN -e 'install Compress::Zlib'
perl -MCPAN -e 'install DBD::Mysql'
perl -MCPAN -e 'install Apache::DBI'
perl -MCPAN -e 'install Net::IP'

#Baixando o OCS Inventory do Github
wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/2.2.1/OCSNG_UNIX_SERVER-2.2.1.tar.gz

#Descompactando o OCS Inventory
tar -zxvf OCSNG_UNIX_SERVER-2.2.1.tar.gz

#Acessando a pasta do OCS Inventory
cd OCSNG_UNIX_SERVER-2.2.1

#Executando o instalador do OCS Inventory
./setup.sh

#Atualizando as informações do Apache2
a2dissite 000-default
a2enconf ocsinventory-reports
a2enconf z-ocsinventory-server
sudo service apache2 restart
