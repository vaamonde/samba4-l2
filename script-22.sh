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
# DESENVOLVIMENTO DE NOVAS TECNOLOGIAS PARA O CURSO, SISTEMA DE MONITORAMENTO E BILHETAGEM, NÃO USAR ESSE SCRIPT
# DESENVOLVIMENTO: Configuração da Auditoria do Apache2 AWStats
# DESENVOLVIEMNTO: Configuração da Auditoria do CUPS W3Perl
#
# Limpeza da Pasta PDF
# Limpeza das configurações do CUPS
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
					 sleep 2
					 #Copiando o arquivo de limpeza da pasta PDF
					 cp -v conf/clean_pdf /usr/sbin >> $LOG
					 #Aplicando as permissões de execução
					 chmod -v +x /usr/sbin/clean_pdf >> $LOG
					 #Copiando o arquivo de agendamento da limpeza da pasta PDF
					 cp -v conf/cleanpdf /etc/cron.d/ >> $LOG
					 echo
					 echo -e "Arquivos copiados com sucesso!!!, pressione <Enter> para editar o arquivo: CLEANPDF
					 read
					 vim /etc/cron.d/cleanpdf
					 echo
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar."
					 
					 
					 echo -e "Configurando a Limpeza do CUPS, pressione <Enter> para continuar"
					 read
					 sleep 2
					 #Copiando o arquivo de limpeza do cups
					 cp -v conf/clean_cups /usr/sbin >> $LOG
					 #Aplicando as permissões de execução
					 chmod -v +x /usr/sbin/clean_cups >> $LOG
					 echo
					 echo -e "Arquivos copiados com sucesso!!!, pressione <Enter> para editar o arquivo: CLEAN_CUPS
					 read
					 vim /usr/sbin/clean_cups
					 echo
					 echo -e "Arquivo editado com sucesso!!!, pressione <Enter> para continuar."
					 


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
