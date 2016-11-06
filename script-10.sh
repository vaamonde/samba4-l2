#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 26/09/2016
# Versão: 0.6
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Troubleshooting de Disco da decima etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
# Utilização de vários comandos para a validação do ambiente.
# mdadm
# pvdisplay, lvdisplay e vgdisplay
# fdisk, tune2fs e df
# mount e repquota
#
# Utilizar o comando: sudo -i para executar o script
#
# Caminho para o Log do Script-10.sh
LOG="/var/log/script-10.log"
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
					 # Variáveis de configuração para o troubleshooting
					 RAID1="/dev/md0"
					 RAID2="/dev/md1"
					 ARQUIVOS="/arquivos"
					 MAPPER="/dev/mapper"

					 USER="administrator"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-10.sh"
					 echo
					 echo -e "Rodando o Script-10.sh em: `date`" > $LOG
					 echo -e "================================================================================="
					 echo -e "  Troubleshooting de Disco é verificação de menssagens de error"
					 echo

					 echo -e "01. Informação do RAID-1 do Sistema: `hostname`"
					 echo
					 mdadm --detail $RAID1
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "02. Informação do RAID-1 dos Arquivos: `hostname`"
					 echo
					 mdadm --detail $RAID2
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "03. Informação dos Volumes Físicos do LVM: `hostname`"
					 echo
					 pvdisplay -v
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "04. Informação dos Volumes Lógicos do LVM: `hostname`"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 lvdisplay -v | less
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "05. Informação dos Grupos de Volumes Lógicos do LVM: `hostname`"
					 echo -e "Pressione <Enter> para continuar"
					 read
					 vgdisplay -v | less
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "06. Utilizando dos discos no servidor: `hostname`"
					 echo
					 df -h | grep mapper
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "07. Verificando o suporte a ACL e XATTR na partição /arquivos do servidor: `hostname`"
					 echo
					 tune2fs -l $MAPPER/*-arquivos | grep "Default mount options:"
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "08. Informações das partições do servidor: `hostname`"
					 echo
					 fdisk -l | grep $MAPPER
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "09. Informações dos pontos de montagem do servidor: `hostname`"
					 echo
					 mount | grep $MAPPER
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "10. Informações de Quota servidor: `hostname`"
					 echo
					 repquota -vs $ARQUIVOS
					 echo
					 echo -e "Pressione <Enter> para continuar"
					 read
					 sleep 2
					 clear

					 echo -e "Fim do Script-10.sh em: `date`" >> $LOG
					 echo -e "  Troubleshooting de Disco é verificação de menssagens de error"
					 echo -e "================================================================================="
					 echo
					 # Script para calcular o tempo gasto para a execução do script-10.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-10.sh: $TEMPO"
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