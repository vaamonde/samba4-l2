#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 30/07/2016
# Versão: 0.4
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Script de criação de usuários em lote.

gawk -F ":" '{ print $2,$3 }' usuario.txt | while read LISTA; 
	do $(echo "/usr/bin/samba-tool user add $LISTAUSER --must-change-at-next-login --use-username-as-cn");
done;