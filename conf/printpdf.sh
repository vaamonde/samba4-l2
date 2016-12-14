#!/bin/sh
# Modificado por: Robson Vaamonde
# Autor original: BjTechNews
# Site: https://bjtechnews.org/2012/02/08/pdf-printer-on-a-samba-server/
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização:09/08/2016
# Versão: 0.4
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x

# Opções dos parametros do Shell Script para Impressão do Arquivo em PDF
# Parameters $1 = spool file (smbprn . . . )
# $2 = user name
# $3 = user home directory
# $4 = print job name

OUTDIR =/arquivos/pti.intra/pdf
  echo Convertendo $1 para “$4” for user $2 in $3 >> /var/log/cups/pdfprint.log
  ps2pdf $1 “$OUTDIR/$4.pdf”
rm $1
