#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 30/11/2016
# Data de atualização: 30/11/2016
# Versão: 0.5
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Criando as váriaveis de validação do diretório
LOG="/var/log/samba/log.pesquisa_arquivos"
DIRETORIO="/arquivos/pti.intra/gestao"
cd $DIRETORIO
LOCAL="`pwd`"

#Fazendo o teste lógico para a localização de arquivos
if [ $DIRETORIO == $LOCAL ]; then
	echo -e "Localizando arquivos indevidos na Pasta: $DIRETORIO em: `date`" > $LOG
	echo >> $LOG
	  find -type f -print0 | xargs -0 file -s | egrep -i ‘(audio file|video|executable)’ >> $LOG
	echo >> $LOG
	echo -e "Finalização da localização de arquivos feita com sucesso!!!" >> $LOG
else
	echo -e "Diretório $DIRETORIO inexistente, verificar as configurações da váriavél de ambiente, localização dos arquivos, etc" >> $LOG
fi
