#!/bin/bash
# Autor: DJ Lucas <dj_AT_linuxfromscratch_DOT_org>
# Site: https://github.com/djlucas/aur-samba-dhcpd-update
# Modificado por: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 30/07/2016
# Versão: 0.4
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x

# Início do script dhcpd-update-samba-dns.sh

. /etc/dhcp/dhcpd/dhcpd-update-samba-dns.conf || exit 1

ACTION=$1
IP=$2
HNAME=$3

export DOMAIN REALM PRINCIPAL NAMESERVER ZONE DHCPUSERNAME DHCPPASSWORD ACTION IP HNAME

/etc/dhcp/dhcpd/samba-dnsupdate.sh -m &

# Fim do script dhcpd-update-samba-dns.sh
