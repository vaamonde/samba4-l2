#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 07/12/2016
# Data de atualização: 17/12/2016
# Versão: 0.7
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração da Auditoria do Apache2 AWStats, após a configuração acessar a URL: http://pti.intra/cgi-bin/awstats.pl?config=pti.intra
# Limpeza da Pasta PDF
# Limpeza das configurações do CUPS
# Script de Impressoras PDF
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-22.sh
LOG="/var/log/script-22.log"
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
					 echo -e "Usuário é `whoami`, continuando a executar o Script-21.sh"
					 echo
					 echo -e "Rodando o Script-22.sh em: `date`" > $LOG
					 echo
					 
					 echo -e "Configurando a Limpeza da Pasta PDF, pressione <Enter> para continuar"
					 read
					 #Copiando o arquivo de limpeza da pasta PDF
					 cp -v conf/clean_pdf /usr/sbin >> $LOG
					 #Aplicando as permissões de execução
					 chmod -v +x /usr/sbin/clean_pdf >> $LOG
					 #Copiando o arquivo de agendamento da limpeza da pasta PDF
					 cp -v conf/cleanpdf /etc/cron.d/ >> $LOG
					 echo
					 echo -e "Arquivos copiados com sucesso!!!, pressione <Enter> para editar o arquivo: CLEAN_PDF"
					 read
					 sleep 2
					 #Editando o arquivo cleanpdf
					 vim /etc/cron.d/cleanpdf +13
					 echo
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear
					 
					 echo -e "Configurando a Limpeza do CUPS, pressione <Enter> para continuar"
					 read
					 sleep 2
					 #Copiando o arquivo de limpeza do cups
					 cp -v conf/clean_cups /usr/sbin >> $LOG
					 #Aplicando as permissões de execução
					 chmod -v +x /usr/sbin/clean_cups >> $LOG
					 echo
					 echo -e "Arquivos copiados com sucesso!!!, pressione <Enter> para editar o arquivo: CLEAN_CUPS"
					 read
					 sleep 2
					 #Editando o arquivo clean_cups
					 vim /usr/sbin/clean_cups
					 echo
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear

					 echo -e "Instalando é configurando o AWStats, pressione <Enter> para continuar, aguarde..."
					 read
					 sleep 2
					 #Atualizando as listas do apt-get
					 apt-get update >> $LOG
					 #Instalando o pacote do awstats
					 apt-get -y install awstats libgeo-ipfree-perl libnet-ip-perl libgeoip1 >> $LOG
					 #Habilitar o recurso de CGI no Apache2
					 a2enmod cgi >> $LOG
					 #Copiando o diretório do CGI para o Apache
					 cp -r /usr/lib/cgi-bin /var/www/html/ >> $LOG
					 #Mudando o dono e grupo do diretório cgi
					 chown -Rv www-data:www-data /var/www/html/cgi-bin/ >> $LOG
					 #Alterando as permissões do diretório
					 chmod -Rv 755 /var/www/html/cgi-bin/ >> $LOG
					 #Atualizando o arquivo de configuração personalizado do awstats
					 cp -v conf/awstats.pti.intra.conf /etc/awstats/awstats.pti.intra.conf >> $LOG
					 #Fazendo o backup do arquivo 000-default.conf
					 cp -v /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.old >> $LOG
					 #Atualizando o arquivo 000-default.conf
					 cp -v conf/000-default.conf /etc/apache2/sites-available/000-default.conf >> $LOG
					 #Reinicializando o Apache2
					 sudo service apache2 restart >> $LOG
					 #Copiando o arquivo de agendamento das atualizações do awstats
					 cp -v conf/awstatsupdate /etc/cron.d/ >> $LOG
					 #Atualizando as estatística do AWStats
					 /usr/lib/cgi-bin/awstats.pl -config=pti.intra -update >> $LOG
					 echo -e "Instalação concluida com sucesso!!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Configurando os Scripts das Impressoras PDF, pressione <Enter> para continuar"
					 read
					 sleep 2
					 #Copiando os arquivos para /usr/sbin
					 cp -v conf/printpdf conf/sambapdf /usr/sbin >> $LOG
					 #Aplicando as permissões de execução
					 chmod -v +x /usr/sbin/printpdf >> $LOG
					 chmod -v +x /usr/sbin/sambapdf >> $LOG
					 echo
					 echo -e "Arquivos copiados com sucesso!!!, pressione <Enter> para editar o arquivo: PRINTPDF"
					 read
					 vim /usr/sbin/printpdf
					 echo
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear
 					 echo -e "Arquivos copiados com sucesso!!!, pressione <Enter> para editar o arquivo: SAMBAPDF"
					 read
					 vim /usr/sbin/sambapdf
					 echo
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear
					 
					 echo -e "Fim do Script-22.sh em: `date`" >> $LOG
					 echo
					 # Script para calcular o tempo gasto para a execução do script-22.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-22.sh: $TEMPO"
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
