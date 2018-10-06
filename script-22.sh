#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 07/12/2016
# Data de atualização: 06/10/2018
# Versão: 0.10
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração da Auditoria do Apache2 AWStats
# Após a configuração acessar a URL: http://pti.intra/cgi-bin/awstats.pl?config=pti.intra
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
					 
					 echo -e "Atualizando o arquivo clean_pdf, aguarde..."
					 #Copiando o arquivo de limpeza da pasta PDF
					 cp -v conf/clean_pdf /usr/sbin >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do arquivo clean_pdf, aguarde..."
					 #Aplicando as permissões de execução
					 chmod -v +x /usr/sbin/clean_pdf >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo cleanpdf, aguarde..."
					 #Copiando o arquivo de agendamento da limpeza da pasta PDF
					 cp -v conf/cleanpdf /etc/cron.d/ >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
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
					 
					 echo -e "Atualizando o arquivo clean_cups, aguarde..."
					 #Copiando o arquivo de limpeza do cups
					 cp -v conf/clean_cups /usr/sbin >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do arquivo clean_cups, aguarde..."
					 #Aplicando as permissões de execução
					 chmod -v +x /usr/sbin/clean_cups >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
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
					 
					 echo -e "Atualizando as listas do apt-get, aguarde..."
					 #Atualizando as listas do apt-get
					 apt-get update >> $LOG
					 echo -e "Listas do apt-get atualizadas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Instalando o AWStats e suas dependências, aguarde..."
					 #Instalando o pacote do awstats
					 apt-get -y install awstats libgeo-ipfree-perl libnet-ip-perl libgeoip1 >> $LOG
					 echo -e "Instalação concluída com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Habilitando o módulo do CGI no Apache, aguarde..."
					 #Habilitar o recurso de CGI no Apache2
					 a2enmod cgi >> $LOG
					 echo -e "Módulo habilitado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o diretório cgi-bin para o html, aguarde..."
					 #Copiando o diretório do CGI para o Apache
					 cp -r /usr/lib/cgi-bin /var/www/html/ >> $LOG
					 echo -e "Diretório atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do diretório cgi-bin, aguarde..."
					 #Mudando o dono e grupo do diretório cgi
					 chown -Rv www-data:www-data /var/www/html/cgi-bin/ >> $LOG
					 #Alterando as permissões do diretório
					 chmod -Rv 755 /var/www/html/cgi-bin/ >> $LOG
					 echo -e "Permissões atualizadas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo awstats.pti.intra.conf, aguarde..."
					 #Atualizando o arquivo de configuração personalizado do awstats
					 cp -v conf/awstats.pti.intra.conf /etc/awstats/awstats.pti.intra.conf >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo awstatsupdate, aguarde..."
					 #Copiando o arquivo de agendamento das atualizações do awstats
					 cp -v conf/awstatsupdate /etc/cron.d/ >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Copia dos arquivos feita com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo awstats.pti.intra.conf, pressione <Enter> para continuar"
					 read
					 
					 #Editando o arquivo awstats.pti.intra.conf
					 vim /etc/awstats/awstats.pti.intra.conf
					 
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo awstatsupdate, pressione <Enter> para continuar"
					 read
					 
					 #Editando o arquivo awstatsupdate
					 vim /etc/cron.d/awstatsupdate
					 
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Reinicializando o serviço do Apache2, aguarde..."
					 #Reinicializando o Apache2
					 sudo service apache2 restart >> $LOG
					 echo -e "Serviço reinicializado com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Atualizando as estatísticas do AWStats, aguarde..."
					 #Atualizando as estatística do AWStats
					 /usr/lib/cgi-bin/awstats.pl -config=pti.intra -update >> $LOG
					 echo -e "Estatísticas atualizadas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Instalação concluída com sucesso!!!!, pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Configurando os Scripts das Impressoras PDF, pressione <Enter> para continuar"
					 read
					 sleep 2
					 
					 echo -e "Atualizando o arquivo printpdf e sambapdf, aguarde..."
					 #Copiando os arquivos para /usr/sbin
					 cp -v conf/printpdf conf/sambapdf /usr/sbin >> $LOG
					 echo -e "Arquivos atualizados com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo -e "Alterando as permissões do arquivo printpdf e sambapdf, aguarde..."
					 #Aplicando as permissões de execução
					 chmod -v +x /usr/sbin/printpdf >> $LOG
					 chmod -v +x /usr/sbin/sambapdf >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
					 sleep 2
					 echo
					 
					 echo
					 echo -e "Arquivos copiados com sucesso!!!, pressione <Enter> continuar"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo printpdf, pressione <Enter> para continuar"
					 read
					 
					 #Editando o arquivo printpdf
					 vim /usr/sbin/printpdf
					 
					 echo
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear
 					 
					 echo
					 echo -e "Editando o arquivo sambapdf, pressione <Enter> para continuar"
					 read
					 
					 #Editando o arquivo sambapdf
					 vim /usr/sbin/sambapdf
					 echo
					 
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar."
					 read
					 sleep 2
					 clear
					 
					 echo -e "Arquivos copiados e editados com sucesso!!!, continuando o script..."
					 echo
					 
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
