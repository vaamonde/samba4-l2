#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 23/07/2020
# Versão: 0.11
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração dos serviços da sexta etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# Configuração do arquivo interfaces
#	vim /etc/network/interfaces
#
# Configuração do Serviço de SSHD, arquivo sshd_config
#	vim /etc/ssh/sshd_config
#
# Configuração dos arquivos hosts.allow e hosts.deny, utilizando a lib: libwrap.so.0
#	vim /etc/hosts.allow
#	vim /etc/hosts.deny
#
# Configuração do Serviço de DHCPD, arquivo dhcpd.conf
#	vim /etc/dhcp/dhcpd.conf
#
# Configuração do aviso de acesso remoto, arquivo issue.net
#	vim /etc/issue.net
#
# Configuração do aviso de acesso físico, arquivo issue
#	vim /etc/issue
#
# Utilizar o comando: sudo -i para executar o script
#
# Variável do caminho do Log dos Script utilizado nesse curso (VARIÁVEL MELHORADA)
# opções do comando cut: -d (delimiter), -f (fields)
# $0 (variável de ambiente do nome do comando)
LOG="/var/log/$(echo $0 | cut -d'/' -f2)"
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando date: +%T (Time)
HORAINICIAL=$(date +%T)
#
# Variáveis para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel (VARIÁVEL MELHORADA)
# opções do comando id: -u (user)
# opções do comando: lsb_release: -r (release), -s (short), 
# opões do comando uname: -r (kernel release)
# opções do comando cut: -d (delimiter), -f (fields)
# opção do shell script: piper | = Conecta a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opção do shell script: aspas duplas " " = Protege uma string, mas reconhece $, \ e ` como especiais
USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)
KERNEL=$(uname -r | cut -d'.' -f1,2)
#
# Verificando se o usuário é Root, Distribuição é >=16.04 e o Kernel é >=4.4 <IF MELHORADO)
# [ ] = teste de expressão, && = operador lógico AND, == comparação de string, exit 1 = A maioria dos erros comuns na execução
clear
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "16.04" ] && [ "$KERNEL" == "4.4" ]
	then
		echo -e "O usuário é Root $USUARIO, continuando com o script..."
		echo -e "Distribuição é >= $UBUNTU, continuando com o script..."
		echo -e "Kernel é >= $KERNEL, continuando com o script..."
		sleep 5
		clear
	else
		echo -e "Usuário não é Root ($USUARIO) ou Distribuição não é >=16.04.x ($UBUNTU) ou Kernel não é >=4.4 ($KERNEL)"
		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script $0 para verificar o ambiente e continuar com a instalação"
		exit 1
fi
#
# Exportando a variável do Debian Frontend Noninteractive para não solicitar interação com o usuário
export DEBIAN_FRONTEND="noninteractive"
#
# Script de instalação dos principais pacotes de rede e suporte ao sistema de arquivos (SCRIPT MELHORADO, REMOÇÃO DA TABULAÇÃO)
# opção do comando echo: -e (enable interpretation of backslash escapes), \n (new line)
# opção do comando hostname: -I (all IP address)
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
# opção do comando: &>> (redireciona a saída padrão, anexando)
echo -e "Início do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
#				 
echo -e "Usuário é `whoami`, continuando a executar o script $0"
echo
echo -e "Configurando as opções de Rede"
echo -e "Configuração do arquivo interfaces"
echo -e "Configuração do Serviço de SSHD"
echo -e "Configuração dos arquivos hosts.allow e hosts.deny"
echo -e "Configuração do Serviço de DHCPD"
echo
echo -e "Após o término do script $0 o Servidor não será reinicializado"
echo
echo ============================================================ >> $LOG

echo -e "Atualizando as Listas do Apt-Get, aguarde..."
	# Atualizando as listas do apt-get
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	apt-get update &>> $LOG
echo -e "Listas Atualizadas com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Atualizando o Sistema, aguarde..."
	# Fazendo a atualização de todos os pacotes instalados no servidor
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -o (option), -q (quiet), -y (yes)
	apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOGG
echo -e "Sistema Atualizado com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Serviços atualizados com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/network/interfaces para acrescentar as informações de endereçamento IP"
echo
echo -e "Linhas a serem editadas no arquivo /etc/network/interfaces"
echo -e "`cat -n /etc/network/interfaces | tail -n3`"
echo
echo -e "Obs: no Ubuntu 16.04 não é habilitado por padrão as configurações de ETHx nas interfaces"
echo -e "No procedimento: script-02.sh foi executado a mudança do GRUB"
echo
echo -e "Interface padrão no GNU/Linux Ubuntu Server versão: $UBUNTU: `lshw -class network | grep -i "logical name" | cut -d: -f2`"
echo
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo interfaces, aguarde..."
	# Fazendo o backup do arquivo de configuração interfaces
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/network/interfaces /etc/network/interfaces.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo interfaces, aguarde..."
	# Copiando o arquivo de configuração interfaces
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/interfaces /etc/network/interfaces >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo interfaces, aguarde..."
	sleep 3
	# Editando o arquivo de configuração interfaces
	# opção do comando vim: + (num line)
	vim +20 /etc/network/interfaces
echo

echo -e "Testando o arquivo de configuração das interfaces, aguarde..."
	echo
	# Verificando as informações das Interfaces
	ifup --verbose --no-act --force --all --interfaces=/etc/network/interfaces
	echo
echo -e "Interface testada com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "INTERFACES atualizado com sucesso!!!, pressione <Enter> continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/hosts.allow para acrescentar as informações de liberação de acesso remoto"
echo
echo -e "Linhas a serem editadas no arquivo /etc/hosts.allow, aguarde..."
echo -e "`cat -n /etc/hosts.allow`"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo hosts.allow, aguarde..."
	# Fazendo o backup do arquivo de configuração hosts.allow
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/hosts.allow /etc/hosts.allow.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo hosts.allow, aguarde..."
	# Copiando o arquivo de configuração hosts.allow
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/hosts.allow /etc/hosts.allow >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo hosts.allow, aguarde..."
	sleep 3
	# Editando o arquivo de configuração hosts.allow
	# opção do comando vim: + (num line)
	vim +24 /etc/hosts.allow
echo -e "HOSTS.ALLOW atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/hosts.deny para acrescentar as informações de bloqueio de acesso remoto"
echo
echo -e "Linhas a serem editadas no arquivo /etc/hosts.deny"
echo -e "`cat -n /etc/hosts.deny`"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo hosts.deny, aguarde..."
	# Fazendo o backup do arquivo de configuração hosts.deny
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/hosts.deny /etc/hosts.deny.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo hosts.deny, aguarde..."
	# Copiando o arquivo de configuração hosts.deny
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/hosts.deny /etc/hosts.deny >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo hosts.deny, aguarde..."
	sleep 3
	# Editando o arquivo de configuração hosts.deny
	# opção do comando vim: + (num line)
	vim +32 /etc/hosts.deny
echo -e "HOSTS.DENY atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/ssh/sshd_config para acrescentar as informações de acesso remoto seguro"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo sshd_config, aguarde..."
	# Fazendo o backup do arquivo de configuração sshd_config
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/ssh/sshd_config /etc/ssh/sshd_config.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo sshd_config, aguarde..."
	# Copiando o arquivo de configuração do sshd_config
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/sshd_config /etc/ssh/sshd_config >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo sshd_config, aguarde..."
	sleep 3
	# Editando o arquivo de configuração do sshd_config
	vim /etc/ssh/sshd_config
echo

echo -e "Atualização feita com sucesso!!!, pressione <Enter> para testar o arquivo sshd_config"
echo -e "Pressione Q para sair"
read
echo
	# Verificando as configurações do sshd
	# opção do comando: | piper (conecta a saída padrão com a entrada padrão de outro comando)
	# opção do comando sshd: -T (test)
	sshd -T | less
echo
echo -e "SSHD_CONFIG atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/dhcp/dhcpd.conf para acrescentar as informações de rede"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo dhcpd.conf, aguarde..."
	# Fazendo o backup do arquivo de configuração dhcpd.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo dhcpd.conf, aguarde..."
	# Copiando o arquivo de configuração do dhcpd.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/dhcpd.conf /etc/dhcp/dhcpd.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."

echo -e "Editando o arquivo dhcpd.conf, aguarde..."
	sleep 3
	# Editando o arquivo de configuração do dhcpd.conf
	vim /etc/dhcp/dhcpd.conf
echo -e "Atualização feita com sucesso!!!, pressione <Enter> para testar o arquivo dhcpd.conf"
echo -e "Pressione Q para sair"
read
echo
	# Verificando as configurações do dhcpd
	# opção do comando: | piper (conecta a saída padrão com a entrada padrão de outro comando)
	# opção do comando dhcpd: -t (test)
	dhcpd -t | less
echo
echo -e "DHCPD.CONF atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/issue.net para acrescentar as informações de acesso remoto"
echo -e "Geração do logo do Ubuntu no arquivo /etc/issue utilizando o screenfetch"
echo
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo issue.net, aguarde..."
	# Fazendo o backup do arquivo de configuração do issue.net
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/issue.net /etc/issue.net.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo issue.net, aguarde..."
	# Copiando o arquivo de configuração do issue.net
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/issue.net /etc/issue.net >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo issue com o comando screenfetch, aguarde..."
	# Atualizando o arquivo de configuração issue para o comando screenfetch, gerando uma imagem do Ubuntu com códigos ASCII
	# opção do comando: > (redireciona a saída padrão)
	screenfetch > /etc/issue
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo issue.net, aguarde..."
	sleep 3
	# Editando o arquivo de configuração do /etc/issue.net utilizado pelo SSH
	vim /etc/issue.net
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo issue, aguarde..."
	sleep 3
	# Editando o arquivo de configuração do /etc/issue utilizado no Login via TTY
	vim /etc/issue
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo					 

echo -e "ISSUE.NET ISSUE atualizados com sucesso!!!, pressione <Enter> continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Fim do script $0 em: `date`" >> $LOG
echo
echo -e "Configuração de Rede feita com sucesso!!!"
echo
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando date: +%T (Time)
	HORAFINAL=$(date +%T)
	# opção do comando date: -u (utc), -d (date), +%s (second since 1970)
	HORAINICIAL01=$(date -u -d "$HORAINICIAL" +"%s")
	HORAFINAL01=$(date -u -d "$HORAFINAL" +"%s")
	# opção do comando date: -u (utc), -d (date), 0 (string command), sec (force second), +%H (hour), %M (minute), %S (second), 
	TEMPO=$(date -u -d "0 $HORAFINAL01 sec - $HORAINICIAL01 sec" +"%H:%M:%S")
	# $0 (variável de ambiente do nome do comando)
	echo -e "Tempo gasto para execução do script $0: $TEMPO"
echo -e "Pressione <Enter> para concluir o processo de configuração do Servidor."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
read
sleep 5
