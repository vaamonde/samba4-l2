#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 13/03/2017
# Data de atualização: 13/03/2017
# Versão: 0.8
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração das regras de Firewall utilizando o IPTables
# Usar o script-08.sh para analiar as portas antes da configuração dos arquivos liberação
# Utilziar o arquivo /etc/firewall/portslibtcp para as portas liberadas do protocolo TCP
# Utilizar o arquivo /etc/firewall/portslibudp para as portas liberadas do protocolo UDP 
# Utilizar o arquivo /etc/firewall/portsblo para as portas bloqueadas TCP/UDP
# Utilizar o arquivo /etc/firewall/dnsseerver para os IP do Servidores de DNS liberados
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-23.sh
LOG="/var/log/script-23.log"
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
					 echo -e "Rodando o Script-23.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "                     Configuração da Regra de Firewall"
					 echo -e "================================================================================="
					 echo
					 echo -e "Pressione <Enter> para iniciar as configurações"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Copiando o arquivo firewall.sh"
					 cp -v conf/firewall /etc/init.d/ >> $LOG
					 echo -e "Arquivo copiado com sucesso!!!"
					 echo
					 sleep 2
					 
					 echo -e "Alterando os permissões do arquivo firewall.sh"
					 chmod -v +x /etc/init.d/firewall >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!"
					 echo
					 sleep 2
					 
					 echo -e "Criando o diretório firewall em: /etc"
					 mkdir -v /etc/firewall >> $LOG
					 echo -e "Diretório criado com sucesso!!!"
					 echo
					 sleep 2
					 
					 echo -e "Copiando os arquivos de configuração do firewall"
					 cp -v conf/portslibtcp /etc/firewall >> $LOG
					 cp -v conf/portslibudp /etc/firewall >> $LOG
					 cp -v conf/portsblo /etc/firewall >> $LOG
					 cp -v conf/dnsserver /etc/firewall >> $LOG
					 echo -e "Arquivos copiados com sucesso!!!"
					 echo
					 sleep 2
					 
					 echo -e "Atualizando as listas do apt-get"
					 apt-get update >> $LOG
					 echo -e "Listas atualziadas com sucesso!!!"
					 echo
					 sleep 2
					 
					 echo -e "Instalando o sysv-rc-conf"
					 apt-get -y install sysv-rc-conf >> $LOG
					 echo -e "sysv-rc-conf instalado com sucesso!!!"
					 echo
					 sleep 2
					 
					 echo -e "Configurando a inicialização do Firewall, pressione <Enter>"
					 echo -e "Na tela de configuração do sysv-rc-conf, marque as opções: 2, 3, 4 e 5"
					 echo -e "Pressione Q (quit) para sair"
					 read
					 sleep 2
					 sysv-rc-conf
					 echo -e "sysv-rc-conf atualizado com sucesso!!!"
					 sleep 2
					 
					 echo -e "Inicializando o Firewall"
					 echo
					 . /etc/init.d/firewall start
					 echo
					 echo -e "Firewall inicializado com sucesso!!!"
					 sleep 2
					 
					 echo -e "Fim do Script-23.sh em: `date`" >> $LOG
					 echo -e "                Finalização da Configuração da Regra de Firewall"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-23.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-23.sh: $TEMPO"
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
