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
# Instalação dos pacotes principais para a quarta etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# Instalando as dependências para Webmin - WebAdmin
# Baixando o Webmin do site Oficial (versão: 1.801)
# Instalando o Webmin via dpkg
# Porta padrão de acesso ao Webmin: https://SEU_ENDEREÇO_IP:10000
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-03.sh
LOG="/var/log/script-03.log"
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
					 # Versão do Webmin para ser feito download
					 VERSAO="webmin_1.801_all.deb"
					 TAMANHO="15.1 MB"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-03.sh"
					 echo
					 echo -e "Instalando as dependências para Webmin - WebAdmin"
					 echo -e "Baixando o Webmin do site Oficial (versão: $VERSAO tamanho: $TAMANHO)"
					 echo -e "Instalando o Webmin via dpkg -i $VERSAO"
					 echo -e "Porta padrão de acesso ao Webmin: https://`hostname -I`:10000"
					 echo -e "Aguarde..."
					 echo
					 echo -e "Rodando o Script-03.sh em: `date`" > $LOG
					 
					 echo -e "Atualizando as Listas do Apt-Get" >> $LOG
					 echo -e "Atualizando as Listas do Apt-Get"
					 #Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND=noninteractive
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

					 echo -e "Instalando as Dependências do Webmin" >> $LOG
					 echo -e "Instalando as Dependências do Webmin"
					 #Instalando as dependências do Webmin
					 apt-get -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python &>> $LOG
					 echo -e "Instalação das Dependências do Webmin Feito com Sucesso!!!"
					 echo
					 echo -e "Instalação das Dependências do Webmin Feito com Sucesso!!!" >> $LOG
					 echo >> $LOG
					 echo ============================================================ >> $LOG

					 echo -e "Limpando o Cache do Apt-Get" >> $LOG
					 echo -e "Limpando o Cache do Apt-Get"
					 #Limpando o diretório de cache do apt-get
					 apt-get clean &>> $LOG
					 echo -e "Cache Limpo com Sucesso!!!"
					 echo
					 echo -e "Cache Limpo com Sucesso!!!" >> $LOG
					 echo >> $LOG
					 echo -e "Pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Baixando o Webmin do Site Oficial, download de: $TAMANHO, aguarde..."
					 echo -e "Baixando o Webmin do Site Oficial, download de: $TAMANHO, aguarde..." >> $LOG
					 #Fazendo o download do instalador do Webmin do site oficial
					 wget http://prdownloads.sourceforge.net/webadmin/$VERSAO &>> $LOG
					 #Listando o arquivo após fazer o download
					 ls -lha $VERSAO >> $LOG
					 echo -e "Download feito com sucesso!!!"
					 echo
					 echo -e "Instalando o Webmin" >> $LOG
					 echo -e "Instalando o Webmin, aguarde..."
					 #Instalando o webmin utilizando o comando dpkg
					 dpkg -i $VERSAO &>> $LOG
					 #Removendo o arquivo de instalação do webmin
					 rm -v $VERSAO >> $LOG
					 echo -e "Instalação do Webmin Feito com Sucesso!!!" >> $LOG
					 echo >> $LOG
					 echo ============================================================ >> $LOG
					 echo -e "Fim do Script-03.sh em: `date`" >> $LOG

					 echo
					 echo -e "Instalação do Webmin Feito com Sucesso!!!"
					 echo
					 # Script para calcular o tempo gasto para a execução do script-03.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					echo -e "Tempo gasto para execução do script-03.sh: $TEMPO"
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
