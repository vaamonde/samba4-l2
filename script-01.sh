#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 23/07/2020
# Versão: 0.13
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Instalação dos pacotes principais para a segunda etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# NTP (Network Time Protocol) Servidor de Data/Hora
# KRB5 (Kerberos) Protocolo de Autenticação Segura
# NFS (Network File System) Protocolo de Transferência de Arquivos
# ACL (Access Control List) Permissões de Arquivos e Diretórios
# ATTR (Extended Attributes) Atributos Estendidos
#
# Após o reboot fazer as mudanças do arquivo /etc/fstab para suportar os recursos de ACL e XATTR EXT4
#	vim /etc/fstab
#	defaults,barrier=1
#
# Se tiver utilizando o sistema de arquivos BTRFS, deixar o padrão
#	vim /etc/fstab
#	defaults,subvol=@
#
# Após o reboot configurar o arquivo /etc/ntp.conf para atualizar data e hora dos servidores do NTP.br
#	 mv /etc/ntp.conf /etc/ntp.conf.old
#	 cp ntp.drift /var/lib/ntp/ntp.drift
#	 cp ntp.conf /etc/
#
# Na instalação fazer a criação do REALM do Kerberos
#	REALM: 	PTI.INTRA
#	SERVER:	ptispo01dc01.pti.intra	
#	ADMIN:	ptispo01dc01.pti.intra
#	debconf-show krb5-config
#
# Configuração do NFS será feita no final do curso
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
# Variáveis de configuração do Kerberos
REALM="PTI.INTRA"
SERVERS="ptispo01dc01.pti.intra"
ADMIN="ptispo01dc01.pti.intra"
NTP="a.st1.ntp.br"
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
echo -e "Instalação dos principais pacotes de rede e suporte ao sistema de arquivos"
echo
echo -e "NTP (Network Time Protocol) Servidor de Data é Hora"
echo -e "KRB5 (Kerberos) Protocolo de Autenticação Segura"
echo -e "NFS (Network File System) Protocolo de Transferência de Arquivos"
echo -e "ACL (Access Control List) Permissões de Arquivos e Diretórios"
echo -e "ATTR (Extended Attributes) Atributos Estendidos"
echo -e "Configuração do FSTAB para suporte a ACL e XATTR"
echo
echo -e "Após o término do script $0 o Servidor será reinicializado"
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
	apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
echo -e "Sistema Atualizado com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Instalando as Dependências da Parte de Rede, aguarde..."
	# Instalando os principais pacotes para o funcionamento correto dos serviços de rede
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes), \ (bar left) quebra de linha na opção do apt-get
	apt-get -y install ntp ntpdate build-essential libacl1-dev libattr1-dev libblkid-dev libgnutls-dev libreadline-dev \
	python-dev libpam0g-dev python-dnspython gdb pkg-config libpopt-dev libldap2-dev dnsutils libbsd-dev docbook-xsl \
	libcups2-dev nfs-kernel-server nfs-common acl attr debconf-utils screenfetch figlet sysv-rc-conf &>> $LOG
echo -e "Instalação das Dependências Feita com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Configurando os parâmetros do apt-get para a instalação do Kerberos, aguarde..."
	# Configurando o Debconf para a configurações do Kerberos trabalhar com Nointeractive
	# Exibindo as configurações do Debconf do Kerberos
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando: | (piper - conecta a saída padrão com a entrada padrão de outro comando)
	echo "krb5-config krb5-config/default_realm string $REALM" |  debconf-set-selections
	echo "krb5-config krb5-config/kerberos_servers string $SERVERS" |  debconf-set-selections
	echo "krb5-config krb5-config/admin_server string $ADMIN" |  debconf-set-selections
	echo "krb5-config krb5-config/add_servers_realm string $REALM" |  debconf-set-selections
	echo "krb5-config krb5-config/add_servers boolean true" |  debconf-set-selections
	echo "krb5-config krb5-config/read_config boolean true" |  debconf-set-selections
	echo  >> $LOG
	debconf-show krb5-config >> $LOG
echo -e "Parâmetros configurado com sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Instalando o Kerberos, aguarde..."
	# Instalando o Kerberos
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes),
	apt-get -y install krb5-user krb5-config &>> $LOG
echo -e "Kerberos instalado com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Limpando o Cache do Apt-Get, aguarde..."
	# Limpando o diretório de cache do apt-get
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	apt-get -y autoremove &>> $LOG
	apt-get -y autoclean &>> $LOG
	apt-get -y clean &>> $LOG
echo -e "Cache Limpo com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Instalação dos principais software de rede feita com sucesso!!!, pressione <Enter> para continuar."
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Configurando o Serviço do Servidor NTPD, Pressione <Enter> para continuar"
echo
read

echo -e "Fazendo o Backup do arquivo ntp.conf, aguarde..."
	# Fazendo o backup do arquivos de configuração do NTP Server
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/ntp.conf /etc/ntp.conf.old >> $LOG
echo -e "Backup do arquivo ntp.conf feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Criando o arquivo ntp.drift, aguarde..."
	# Copiando o arquivo ntp.drift
	# Adicionando o conteúdo de 0.0 dentro do arquivo ntp.drift
	# Alterando o dono e grupo de arquivo ntp.drift
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando: > (redireciona a saída padrão (STDOUT))
	# opção do comando cp: -v (verbose)
	# opção do comando chown: -v (verbose)
	cp -v conf/ntp.drift /var/lib/ntp/ntp.drift >> $LOG
	echo 0.0 > /etc/ntp.drift
	chown -v ntp.ntp /var/lib/ntp/ntp.drift >> $LOG
echo -e "Arquivo ntp.drift criado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo ntp.conf, aguarde..."
	# Copiando o arquivo de configuração do NTP Server
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/ntp.conf /etc/ntp.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Parando o serviço do ntp server, aguarde..."
	# Parando o serviço do NTP Server para fazer a sua configuração
	sudo service ntp stop
echo -e "Serviço parado com sucesso!!!, continuando o script..."
sleep 5
clear

echo -e "Editando o arquivo /etc/ntp.conf para acrescentar as informações de Servidores NTP"
echo -e "Pressione <Enter> para editar o arquivo"
read
sleep 2
	# Editando o arquivo ntp.conf
	vim /etc/ntp.conf
echo
echo -e "Arquivo ntp.conf editado com sucesso!!!"
echo -e "Pressione <Enter> para continuar"
read
sleep 2
clear

echo -e "Atualizando Data/Hora do Servidor utilizando ntpdate, aguarde..."
echo
	# Atualizando data/hora do servidor NTP.br
	# Iniciando o serviço do NTP Server
	# opção do comando ntpdate: d (debug), q (query), u (unprivileged), v (verbose)
	ntpdate -dquv $NTP
	sudo service ntp start
	echo
echo -e "Data/Hora atualizada com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Verificação dos servidores NTP, aguarde..."
	echo
	# Verificando as informações de Servidores NTP e seu sincronismo
	# opção do comando ntpq: p (print), n (all andress)
	ntpq -pn
	echo
echo -e "Verificação feita com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Data/Hora do Hardware do servidor, aguarde..."
	# Atualizando a data/hora do hardware com a data/hora do sistema operacional
	# Verificando data/hora de hardware (BIOS)
	hwclock --systohc
	hwclock
	sleep 2
	echo
echo -e "Data/Hora do Sistema Operacional do servidor"
	# Verificando data/hora de sistema operacional
	date
	sleep 2
echo

echo -e "NTP.CONF atualizado com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/fstab para acrescentar as informações de ACL e XATTR"
echo
echo -e "Informações de ACL e XATTR na Raiz, Var e no diretório Arquivos"
echo 
echo -e "Linhas a serem editadas no arquivo /etc/fstab" 
	# Listando a linha 8
	# opção do comando: | (piper - conecta a saída padrão com a entrada padrão de outro comando)
	# opção do comando cat: -n (number)
	# opção do comando sed: -n (quiet or silent)
	echo -e "`cat -n /etc/fstab | sed -n '8p'`"
	echo
	# Listando a linha 9
	echo -e "`cat -n /etc/fstab | sed -n '9p'`"
	echo
	# Listando a linha 12
	echo -e "`cat -n /etc/fstab | sed -n '12p'`"
	echo
echo -e "Informações a serem acrescentadas depois de ext4: defaults,barrier=1"
echo
echo -e "Se estiver utilizando o BTRFS, deixar o padrão"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read
sleep 2

echo -e "Fazendo o backup do arquivo fstab, aguarde..."
	# Fazendo o backup do arquivo fstab
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v /etc/fstab /etc/fstab.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2

echo -e "Editando o arquivo fstab, aguarde..."
	# Editando o arquivo fstab
	vim /etc/fstab
echo

echo -e "FSTAB atualizado com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/krb5.conf para acrescentar as informações SAMBA-4"
echo
echo -e "Linha a ser editada no arquivo /etc/krb5.conf" 
echo -e "`cat -n /etc/krb5.conf | head -n2`"
echo
echo -e "Informações a serem acrescentadas depois de default_realm"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read
sleep 2

echo -e "Fazendo o Backup do arquivo krb5.conf, aguarde..."
	# Fazendo o backup do arquivo de configuração do Kerberos
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/krb5.conf /etc/krb5.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo krb5.conf, aguarde..."
	#Atualizando o arquivo de configuração do Kerberos
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/krb5.conf /etc/krb5.conf >> $LOG
echo -e "Atualizado com sucesso!!!, continuando o script..."
sleep 2
echo 

echo -e "Editando o arquivo /etc/krb5.conf para acrescentar as informações de Servidores de Kerberos"
echo -e "Pressione <Enter> para editar o arquivo"
read
	# Editando o arquivo de configuração do Kerberos
	vim /etc/krb5.conf
echo
echo -e "KRB5.CONF atualizado com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Fim do script $0 em: `date`" >> $LOG
echo
echo -e "Instalação das Dependências de Rede Feita com Sucesso!!!" 
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
echo -e "Pressione <Enter> para concluir o processo e reinicializar o Servidor."
# opção do comando date: + (format), %d (day), %m (month), %Y (year 1970), %H (hour 24), %M (minute 60)
echo -e "Fim do script $0 em: `date +%d/%m/%Y-"("%H:%M")"`\n" &>> $LOG
read
sleep 5
reboot