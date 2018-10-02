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
           
					 echo -e "Usuário é `whoami`, continuando a executar o Script-23.sh"
					 echo
					 echo -e "Rodando o Script-24.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                     Instalação do LogAnalyzer"
					 echo -e "================================================================================="
					 echo
					 echo -e "Pressione <Enter> para iniciar as configurações"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Copiando o arquivo firewall.sh, aguarde..."
					 cp -v conf/firewall /etc/init.d/ >> $LOG
					 echo -e "Arquivo copiado com sucesso!!!"
					 echo
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
