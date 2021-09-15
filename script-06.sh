#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 17/07/2019
# Versão: 0.12
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração dos serviços do SAMBA 4 da sétima etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# Opções do samba-tool domain provision
#
# --option=”interfaces=lo eth0″ --option=”bind interfaces only=yes” – Se seu controlador de domínio tem mais de uma 
# interface de rede essa opção é obrigatória. Isso força o SAMBA 4 a escutar e resolver corretamente o DNS para a interface
# da sua rede local;
#
# --option="allow dns updates = nonsecure and secure" 
# --option="dns forwarder = 192.168.1.10"
# --option="winbind use default domain = yes" 
# --option="winbind enum users  = yes" 
# --option="winbind enum groups = yes" 
# --option="winbind refresh tickets = yes" 
# --option="winbind refresh tickets = rfc2307"
# --option="server signing = auto" 
# --option="vfs objects = acl_xattr" 
# --option="map acl inherit = yes" 
# --option="store dos attibutes = yes" 
# --option="client use spnego = no"
#
# --use-rfc2307 – O uso dessa opção ativa o SAMBA 4 Active Directory para armazenar atributos posix. É também cria
# informações do NIS (Network Information Service) no AD, permitindo a administração de UIDs/GIDs e outras funções Unix;
#
# --realm=PTI.INTRA – É onde setamos o domínio completo, no caso prefixo mais sufixo, obrigatório ser em MAIÚSCULA;
#
# --domain=PTI – Nessa opção, devemos setar apenas o prefixo do domínio, obrigatório ser em MAIÚSCULA;
#
# --dns-backend=BIND9_DLZ – Por padrão SAMBA 4 utiliza o seu próprio DNS. Essa opção força o SAMBA 4 utilizar o Bind como DNS 
# Backend.
#
# --adminpass=’pti@2016’ – Aqui configuramos a senha do usuário “Administrator”, que será o administrador do sistema.
#
# --host-ip=192.168.1.10 - Aqui configuramos o endereço IP do servidor do SAMBA 4
#
# Informações sobre tipos de DNS do SAMBA 4
# SAMBA_INTERNAL	= Configurações de DNS interna no SAMBA 4
# BIND9_FLATFILE	= Configurações de DNS utilizando arquivos de configurações
# BIND9_DLZ		= Configurações de DNS integrado em SAMBA 4 é o BIND
# NONE			= Sem configuração de DNS
#
# Versões do Schema do Active Directory suportador pelo SAMBA 4
#
# Informações sobre o FSMO Roles (Flexible Single Master Operation Roles)
# 1. Schema Master (Mestre de Esquema);
# 2. Domain Name Master (Mestre de Nomeação de Domínio);
# 3. PDC Emulator (Emulador de Controlador de Domínio Primário);
# 4. RID Master (Mestre ID Relativo - SID);
# 5. Infra-Structure Master (Mestre de Infra-Estrutura);
# 6. GC Global Catalog (Catalog Global).
# Mais informações: https://wiki.samba.org/index.php/AD_Schema_Version_Support
#
# AppArmor configurações:
# r = permissões de leitura
# w = permissões de gravação
# k = permissões de lock
# m = ativação da flag PROT_EXEC
# Ux = permissão de execução de scripts
# Mais informações: http://manpages.ubuntu.com/manpages/xenial/en/man5/apparmor.d.5.html
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
# Exportação da variável de configuração do SAMBA 4
REALM="PTI.INTRA"
DOMAIN="PTI"
ROLE="dc"
DNS="BIND9_DLZ"
PASSWORD="pti@2016"
LEVEL="2008_R2"
SITE="PTI.INTRA"
IP="192.168.1.10"
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
echo -e "Promovendo o SAMBA 4 como Controlador de Domínio"
echo -e "Configurando o SAMBA 4 integrado com o BIND9-DNS-SERVER e ISC-DHCP-SERVER"
echo -e "Nível Funcional do SAMBA 4 como Windows Server 2008 R2"
echo
echo -e "1. Schema Master (Mestre de Esquema);"
echo -e "2. Domain Name Master (Mestre de Nomeação de Domínio);"
echo -e "3. PDC Emulator (Emulador de Controlador de Domínio Primário);"
echo -e "4. RID Master (Mestre ID Relativo - SID);"
echo -e "5. Infra-Structure Master (Mestre de Infra-Estrutura);"
echo -e "6. GC Global Catalog (Catálogo Global)."
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

echo -e "Serviços atualizados com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Promovendo o Servidor SAMBA 4 como AD-DC, pressione <Enter> para iniciar o processo de promoção"
echo 
read
echo

echo -e "Parando o serviço do SAMBA 4, aguarde..."
	# Parando o serviço do SAMBA 4
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	sudo service samba stop &>> $LOG
echo -e "Serviço parado com sucesso!!!, continuando o script..."
sleep 2
echo 

echo -e "Fazendo o backup do arquivo smb.conf, aguarde..."
	# Fazendo o backup do arquivo de configuração smb.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/samba/smb.conf /etc/samba/smb.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Promovendo o controlador de domínio do SAMBA 4, aguarde..."
	# Iniciando o processo de promoção do servidor utilizando o comando samba-tool domain provision
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando:  \ (bar left) quebra de linha na opção do samba-tool
	samba-tool domain provision --realm=$REALM --domain=$DOMAIN --server-role=$ROLE --dns-backend=$DNS --adminpass=$PASSWORD \
	--function-level=$LEVEL --site=$SITE --host-ip=$IP --option="interfaces = lo eth0" --option="bind interfaces only = yes" \
	--option="allow dns updates = nonsecure and secure" --option="dns forwarder = $IP" \
	--option="winbind use default domain = yes" --option="winbind enum users  = yes" --option="winbind enum groups = yes" \
	--option="winbind refresh tickets = yes" --option="server signing = auto" --option="vfs objects = acl_xattr" \
	--option="map acl inherit = yes" --option="store dos attributes = yes" --option="client use spnego = no" \
	--option="use spnego = no" --option="client use spnego principal = no" --use-rfc2307 --use-xattrs=yes &>> $LOG
echo -e "Promoção do Servidor SAMBA 4 feita com Sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Verificando as informações do Controlador de Domínio do SAMBA 4, aguarde..."
echo
	# Verificando informações do log domínio.
	# opção do comando tail: -n (lines)
	# opção do comando head: -n (lines)
	tail -n6 $LOG | head -n6
echo
echo -e "Servidor SAMBA 4 promovido como Controlador de Domínio com Sucesso!!!"
echo -e "Pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Desabilitando a expiração da senha do usuário Administrator, aguarde..."
	# Desativando a expiração da senha do usuário administrator
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	samba-tool user setexpiry administrator --noexpiry &>> $LOG
echo -e "Senha desabilitada com sucesso!!!, pressione <Enter> continuando com o script"
read
sleep 2
clear

echo -e "Editando o arquivo NAMED.CONF, aguarde..."
echo -e "Acrescentar a linha: include "/var/lib/samba/private/named.conf" no final arquivo named.conf"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo named.conf, aguarde..."
	# Fazendo o backup do arquivo de configuração named.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/bind/named.conf /etc/bind/named.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo named.conf, aguarde..."
	# Copiando o arquivo de configuração named.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/named.conf /etc/bind/named.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo named.conf, aguarde..."
	sleep 3
	# Editando o arquivo de configuração named.conf
	# opção do comando vim: + (num line)
	vim /etc/bind/named.conf +19
echo -e "NAMED.CONF atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo NAMED.CONF.OPTIONS"
echo -e "Acrescentar as linhas depois de: listen-on-v6 { any; };"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Criando o diretório e arquivo de Estatísticas do Bind9 RNDC, aguarde..."
	# Criando o diretório para estatísticas do bind9 rndc
	# Criando o arquivo de estatísticas do bind9 rndc
	# Alterando as permissões do diretório e do arquivo
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mkdir: -v (verbose)
	# opção do comando chown: -R (recursive), -v (verbose)
	mkdir -v /var/log/named >> $LOG
	touch /var/log/named/named.stats
	chown -Rv bind.bind /var/log/named/ >> $LOG
echo -e "Diretório e arquivo criado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Fazendo o backup do arquivo named.conf.options, aguarde..."
	# Fazendo o backup do arquivo de configuração named.conf.options
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/bind/named.conf.options /etc/bind/named.conf.options.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo named.conf.options, aguarde..."
	# Copiando o arquivo de configuração named.conf.options
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/named.conf.options /etc/bind/named.conf.options >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo named.conf.options, aguarde..."
	sleep 3
	# Editando o arquivo de configuração named.conf.options
	vim /etc/bind/named.conf.options
	echo
echo -e "NAMED.CONF.OPTIONS atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo NAMED.CONF.LOCAL"
echo -e "Após a modificação do arquivo named.conf.local será gerado a chave novamente"
echo -e "Será criado um Link Simbólico para o serviço do DHCP utilizar a mesma chave"
echo -e "Acrescentar a linha: include "/etc/bind/rndc.key" no final do arquivo"
echo -e "Pressione <Enter> para editar o arquivo"
echo
read

echo -e "Fazendo o backup do arquivo named.conf.local, aguarde..."
	# Fazendo o backup do arquivo de configuração named.conf.local
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/bind/named.conf.local /etc/bind/named.conf.local.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo named.conf.local, aguarde..."
	# Copiando o arquivo de configuração named.conf.local
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/named.conf.local /etc/bind/named.conf.local >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo named.conf.local, aguarde..."
	sleep 3
	# Editando o arquivo de configuração named.conf.local
	# opção do comando vim: + (num line)
	vim /etc/bind/named.conf.local +15
	echo
echo -e "Arquivo editado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Alterando as permissões do arquivo rndc.key, aguarde..."
	# Recurso de geração de chaves do Bind, recurso desativado em: 19/07/2016, falha na geração
	# Alterando as permissões de dono e grupo do arquivo de chaves rndc.key
	# Alterando as permissões de acesso do arquivo de chaves rndc.key
	# Criando um Link Simbólico do arquivo de chaves rndc.key
	# Alterando as permissões de dono e grupo do link simbólico do arquivo de chaves rndc.key
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando chown: -v (verbose)
	# opção do comando chmod: -v (verbose), 6 (user), 4 (group), 0 (other)
	# opção do comando ln: -v (verbose)
	#rndc-confgen -a
	chown -v root:bind /etc/bind/rndc.key >> $LOG
	chmod -v 640 /etc/bind/rndc.key >> $LOG
	ln -v /etc/bind/rndc.key /etc/dhcp/ddns-keys/rndc.key >> $LOG
	chown -v root:bind /etc/dhcp/ddns-keys/rndc.key >> $LOG
echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "NAMED.CONF.LOCAL atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo APPARMOR.D para permitir o BIND9 acessar os arquivos do SAMBA4"
echo -e "Acrescentar as informações no final do arquivo"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo usr.sbin.named, aguarde..."
	# Fazendo o backup do arquivo de configuração usr.sbin.named
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/apparmor.d/local/usr.sbin.named /etc/apparmor.d/local/usr.sbin.named.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo usr.sbin.named, aguarde..."
	# Copiando o arquivo de configuração do usr.sbi.named
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/usr.sbin.named /etc/apparmor.d/local/usr.sbin.named >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo usr.sbin.named, aguarde..."
	sleep 3
	# Editando o arquivo de configuração usr.sbi.named
	vim /etc/apparmor.d/local/usr.sbin.named
	echo
echo -e "Arquivo editado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Alterando as permissões do arquivo dns.keytab e named.conf, aguarde..."
	# Alterando as permissões de dono e grupo do arquivo de chaves dns.keytab
	# Alterando as permissões de acesso ao grupo no arquivo de chaves dns.keytab
	# Alterando o dono grupo do arquivo de configuração do SAMBA 4 named.conf
	# opção do comando chown: -v (verbose)
	# opção do comando chmod: -v (verbose), g (group), + (add), r (read)
	chown -v bind:bind /var/lib/samba/private/dns.keytab >> $LOG
	chmod -v g+r /var/lib/samba/private/dns.keytab >> $LOG
	chown -v bind:bind /var/lib/samba/private/named.conf >> $LOG
echo -e "Permissões alteradas com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "APPARMOR.D atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo SYSCTL.CONF para o servidor: `hostname`"
echo -e "Acrescentar no final do arquivo a linha: fs.file-max=500000"
echo -e "Aumentar o número de arquivos que o BIND9 vai gerenciar"
echo -e "Pressione <Enter> para editar o arquivo"
read

echo -e "Fazendo o backup do arquivo sysctl.conf, aguarde..."
	# Fazendo o backup do arquivo de configuração sysctl.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/sysctl.conf /etc/sysctl.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo sysctl.conf, aguarde..."
	# Copiando o arquivo de configuração sysctl.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/sysctl.conf /etc/sysctl.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo sysctl.conf, aguarde..."
	sleep 3
	# Editando o arquivo de configuração sysctl.conf
	# opção do comando vim: + (num line)
	vim /etc/sysctl.conf +73
	echo

echo -e "SYSCTL.CONF atualizado com sucesso!!!, pressione <Enter> para continuando com o script!!!!"
read
sleep 2
clear
echo ============================================================ >> $LOG


echo -e "Editando o arquivo LIMITS.CONF para o servidor: `hostname`"
echo -e "Acrescentar no final do arquivo a linha: *		-	nofile		400000"
echo -e "Pressione <Enter> para editar o arquivo"
read

echo -e "Fazendo o backup do arquivo limits.conf, aguarde..."
	# Fazendo o backup do arquivo de configuração limits.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/security/limits.conf /etc/security/limits.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo limits.conf, aguarde..."
	# Copiando o arquivo de configuração limits.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/limits.conf /etc/security/limits.conf >>$LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo limits.conf, aguarde..."
	sleep
	# Editando o arquivo de configuração limits.conf
	# opção do comando vim: + (num line)
	vim /etc/security/limits.conf +70
	echo
echo -e "LIMITS.CONF atualizado com sucesso!!!, pressione <Enter> para continuando com o script!!!!"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo NAMED.CONF do SAMBA 4"
echo -e "Verificar as linhas referente a versão do BIND instalado"
echo
echo -e "Versão do BIND instalado: `named -v`"
echo
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo named.conf, aguarde..."
	# Backup do arquivo de configuração named.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v /var/lib/samba/private/named.conf /var/lib/samba/private/named.conf.old &>> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando arquivo named.conf, aguarde..."
	sleep 3
	# Editando o arquivo de configurando do SAMBA 4 named.conf
	# opção do comando vim: + (num line)
	vim /var/lib/samba/private/named.conf +20
	echo
echo -e "NAMED.CONF do SAMBA 4 atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Fim do script $0 em: `date`" >> $LOG
echo
echo -e "Configuração do SAMBA 4 como Controlador de Domínio feito com Sucesso!!!"
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
reboot