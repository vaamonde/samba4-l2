#!/bin/sh
# Modificado por: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 28/12/2016
# Versão: 0.4
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração do Firewall através do iptables
# Autoria do Script
# Site: https://www.vivaolinux.com.br/artigo/Script-de-firewall-completissimo?pagina=1

#Declaração de variáveis
PATH=/sbin:/bin:/usr/sbin:/usr/bin
FIREWALL="/etc/firewall"
IPTABLES="/sbin/iptables"
PROGRAMA="/etc/init.d/firewall.sh"

#Portas liberadas e bloqueadas
PORTSLIB="$FIREWALL/portslib"
PORTSBLO="$FIREWALL/portsblo"
RANGEPORT="$FIREWALL/rangeport"

#Interfaces de Rede
LAN=eth1
REDE="192.168.1.0/24"

case "$1" in
start)

#Mensagem de inicialização
echo "=========================================================|"
echo "|:INICIANDO A CONFIGURAÇÃO DO FIREWALL NETFILTER ATRAVÉS:|"
echo "|:                    DO IPTABLES                       :|"
echo "=========================================================|"

#Limpando todas as regras das tabelas do iptables
$IPTABLES -F
$IPTABLES -F INPUT
$IPTABLES -F OUTPUT
$IPTABLES -F FORWARD
$IPTABLES -t mangle -F
$IPTABLES -t nat -F
$IPTABLES -X
echo "limpeza das tabelas do iptables"
echo "ON .................................................[ OK ]"

#Zerando os contadores das cadeias
$IPTABLES -t nat -Z
$IPTABLES -t mangle -Z
$IPTABLES -t filter -Z
echo "zerando os contadores das cadeiras"
echo "ON .................................................[ OK ]"

#Setando as políticas padrão das tabelas do iptables
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD DROP
echo "setando as políticas padrão das tabelas do iptables"
echo "ON .................................................[ OK ]"

#Habilitando o fluxo interno entre os processos
$IPTABLES -I INPUT -i lo -j ACCEPT
$IPTABLES -I OUTPUT -o lo -j ACCEPT
echo "ativado o fluxo interno entre os processos"
echo "ON .................................................[ OK ]"

#Liberar as portas principais do servidor
for i in `cat $PORTSLIB`; do
	$IPTABLES -A INPUT -p tcp --dport $i -j ACCEPT
	$IPTABLES -A FORWARD -p tcp --dport $i -j ACCEPT
	$IPTABLES -A OUTPUT -p tcp --sport $i -j ACCEPT
done
	$IPTABLES -I INPUT -m state --state ESTABLISHED -j ACCEPT
	$IPTABLES -I INPUT -m state --state RELATED -j ACCEPT
	$IPTABLES -I OUTPUT -p icmp -o $LAN -j ACCEPT
	$IPTABLES -I INPUT -p icmp -j ACCEPT
echo "ativado as portas abertas para estabelecer conexões"
echo "ativado a liberação das portas principais do servidor $HOSTNAME"
echo "ON .................................................[ OK ]"

#Bloqueio ping da morte
echo "0" > /proc/sys/net/ipv4/icmp_echo_ignore_all
$IPTABLES -N PING-MORTE
$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j PING-MORTE
$IPTABLES -A PING-MORTE -m limit --limit 1/s --limit-burst 4 -j RETURN
$IPTABLES -A PING-MORTE -j DROP
echo "ativado o bloqueio a tentativa de ataque do tipo ping da morte"
echo "ON .................................................[ OK ]"

#Bloquear ataque do tipo SYN-FLOOD
echo "0" > /proc/sys/net/ipv4/tcp_syncookies
$IPTABLES -N syn-flood
$IPTABLES -A INPUT -i $WAN -p tcp --syn -j syn-flood
$IPTABLES -A syn-flood -m limit --limit 1/s --limit-burst 4 -j RETURN
$IPTABLES -A syn-flood -j DROP
echo "ativado o bloqueio a tentativa de ataque do tipo SYN-FLOOD"
echo "ON .................................................[ OK ]"

#Bloqueio de ataque ssh de força bruta
$IPTABLES -N SSH-BRUT-FORCE
$IPTABLES -A INPUT -i $WAN -p tcp --dport 22 -j SSH-BRUT-FORCE
$IPTABLES -A SSH-BRUT-FORCE -m limit --limit 1/s --limit-burst 4 -j RETURN
$IPTABLES -A SSH-BRUT-FORCE -j DROP
echo "ativado o bloqueio a tentativa de ataque do tipo SSH-BRUT-FORCE"
echo "ON .................................................[ OK ]"

#Bloqueio de portas
for i in `cat $PORTSBLO`; do
	$IPTABLES -A INPUT -p tcp -i $WAN --dport $i -j DROP
	$IPTABLES -A INPUT -p udp -i $WAN --dport $i -j DROP
	$IPTABLES -A FORWARD -p tcp --dport $i -j DROP
done

#Bloqueio Anti-Spoofings
$IPTABLES -A INPUT -s 10.0.0.0/8 -i $WAN -j DROP
$IPTABLES -A INPUT -s 127.0.0.0/8 -i $WAN -j DROP
$IPTABLES -A INPUT -s 172.16.0.0/12 -i $WAN -j DROP
$IPTABLES -A INPUT -s 192.168.1.0/16 -i $WAN -j DROP
echo "ativado o bloqueio de tentativa de ataque do tipo Anti-spoofings"
echo "ON .................................................[ OK ]"

#Bloqueio de scanners ocultos (Shealt Scan)
$IPTABLES -A FORWARD -p tcp --tcp-flags SYN,ACK, FIN,  -m limit --limit 1/s -j ACCEPT
echo "bloqueado scanners ocultos"
echo "ON .................................................[ OK ]"

echo
echo "==========================================================|"
echo "::TERMINADA A CONFIGURAÇÃO DO FIREWALL NETFILTER ATRAVÉS::|"
echo "::                  DO IPTABLES                         ::|"
echo "==========================================================|"
echo "FIREWALL ATIVADO - SISTEMA PREPARADO"
echo "SCRIPT DE FIREWALL CRIADO POR :-) MARCELO MAGNO :-)"
;;

stop)
$IPTABLES -F
$IPTABLES -F INPUT
$IPTABLES -F OUTPUT
$IPTABLES -F FORWARD
$IPTABLES -t mangle -F
$IPTABLES -t nat -F
$IPTABLES -X
$IPTABLES -Z

$IPTABLES -P INPUT ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT

echo "FIREWALL DESCARREGADO - SISTEMA LIBERADO"
;;

restart)
$PROGRAMA stop
$PROGRAMA start
;;
*)
echo "Use: $N {start|stop|restart}" >&2
echo -e "\033[01;31mATENÇÃO";tput sgr0
echo "Você não colocou nenhum argumento ou algum conhecido, então Por Padrão será dado em 5 segundos um restart no firewall"
sleep 5
$PROGRAMA restart
exit 1
esac
exit 0
