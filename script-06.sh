#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 31/05/2016
# Data de atualização: 30/12/2016
# Versão: 0.8
# Testado e homologado para a versão do Ubuntu Server 16.04 LTS x64
# Kernel >= 4.4.x
#
# Configuração dos serviços do SAMBA-4 da sétima etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# Opções do samba-tool domain provision
#
# --option=”interfaces=lo eth0″ --option=”bind interfaces only=yes” – Se seu controlador de domínios tem mais de uma interface de rede essa opção é obrigatória. Isso força o samba escutar e resolver corretamente o DNS para a interface da sua rede local;
#
# --option="allow dns updates = nonsecure and secure" --option="dns forwarder = 192.168.1.10"
#
# --option="winbind use default domain = yes" --option="winbind enum users  = yes" --option="winbind enum groups = yes" --option="winbind refresh tickets = yes" --option="winbind refresh tickets = rfc2307"
#
# --option="server signing = auto" --option="vfs objects = acl_xattr" --option="map acl inherit = yes" --option="store dos attibutes = yes" --option="client use spnego = no"
#
# --use-rfc2307 – O uso dessa opção ativa o Samba Active Directory para armazenar atributos posix. É também criado informações NIS (Network Information Service) no AD, permitindo a administração de UIDs/GIDs e outras funções Unix;
#
# --realm=PTI.INTRA – É onde setamos o domínio completo, no caso prefixo mais sufixo;
#
# --domain=PTI – Nessa opção, devemos setar apenas o prefixo do domínio;
#
# --dns-backend=BIND9_DLZ – Por padrão Samba4 utiliza o seu próprio DNS. Essa opção força o Samba4 utilizar o Bind como DNS Backend.
#
# --adminpass=’pti@2016’ – Aqui configuramos a senha do usuário “Administrator”, que será o administrador do sistema.
#
# --host-ip=192.168.1.10 - 
#
# Informações sobre tipos de DNS do SAMBA4
# SAMBA_INTERNAL	= Configurações de DNS interna no SAMBA4
# BIND9_FLATFILE	= Configurações de DNS utilizando arquivos de configurações
# BIND9_DLZ		= Configurações de DNS integrado em SAMBA4 é o BIND
# NONE			= Sem configuração de DNS
#
# Informações sobre o FSMO Roles (Flexible Single Master Operation Roles)
# 1. Schema Master (Mestre de Esquema);
# 2. Domain Name Master (Mestre de Nomeação de Domínio);
# 3. PDC Emulator (Emulador de Controlador de Domínio Primário);
# 4. RID Master (Mestre ID Relativo - SID);
# 5. Infra-Structure Master (Mestre de Infra-Estrutura);
# 6. GC Global Catalog (Catalog Global).
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
# Caminho para o Log do Script-06.sh
LOG="/var/log/script-06.log"
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
					 # Variáveis de configuração do SAMBA4
					 REALM="PTI.INTRA"
					 DOMAIN="PTI"
					 ROLE="dc"
					 DNS="BIND9_DLZ"
					 PASSWORD="pti@2016"
					 LEVEL="2008_R2"
					 SITE="PTI.INTRA"
					 IP="192.168.1.10"
					 #
					 echo -e "Usuário é `whoami`, continuando a executar o Script-06.sh"
					 echo
					 echo -e "Promovendo o SAMBA-4 como Controlador de Domínio"
					 echo
					 echo -e "Configurando o SAMBA-4 integrado com o BIND9-DNS-SERVER e ISC-DHCP-SERVER"
					 echo
					 echo -e "Nível Funcional do SAMBA-4 como Windows Server 2008 R2"
					 echo
					 echo -e "1. Schema Master (Mestre de Esquema);"
					 echo -e "2. Domain Name Master (Mestre de Nomeação de Domínio);"
					 echo -e "3. PDC Emulator (Emulador de Controlador de Domínio Primário);"
					 echo -e "4. RID Master (Mestre ID Relativo - SID);"
					 echo -e "5. Infra-Structure Master (Mestre de Infra-Estrutura);"
					 echo -e "6. GC Global Catalog (Catalogo Global)."
					 echo
					 echo -e "Aguarde..."
					 echo
					 echo -e "Rodando o Script-06.sh em: `date`" > $LOG
					 
					 echo -e "Atualizando as Listas do Apt-Get"
					 # Exportando o recurso de Noninteractive do Debconf
					 export DEBIAN_FRONTEND=noninteractive
					 #Atualizando as listas do apt-get
					 apt-get update &>> $LOG
					 echo -e "Listas Atualizadas com Sucesso!!!"
					 echo
					 echo ============================================================ >> $LOG

					 echo -e "Atualizando o Sistema"
					 #Fazendo a atualização de todos os pacotes instalados no servidor
					 apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
					 echo -e "Sistema Atualizado com Sucesso!!!"
					 echo
					 echo ============================================================ >> $LOG
					 
					 echo -e "Serviços atualizados com sucesso!!!, pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Promovendo o Servidor SAMBA-4 como AD-DC, pressione <Enter> para iniciar o processo de promoção"
					 echo 
					 read
					 echo
					 
					 echo -e "Parando o serviço do SAMBA-4"
					 #Parando o serviço do SAMBA-4
					 sudo service samba stop &>> $LOG
					 echo -e "Serviço parado com sucesso!!!"
					 sleep 2
					 echo 
					 
					 echo -e "Fazendo o backup do arquivo smb.conf"
					 #Fazendo o backup do arquivo de configuração smb.conf
					 mv -v /etc/samba/smb.conf /etc/samba/smb.conf.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Promovendo o controlador de domínio do SAMBA-4"
					 #Iniciando o processo de promoção do servidor utilizando o comando samba-tool domain provision
					 samba-tool domain provision --realm=$REALM --domain=$DOMAIN --server-role=$ROLE --dns-backend=$DNS --adminpass=$PASSWORD --function-level=$LEVEL --site=$SITE --host-ip=$IP --option="interfaces = lo eth0" --option="bind interfaces only = yes" --option="allow dns updates = nonsecure and secure" --option="dns forwarder = 192.168.1.10" --option="winbind use default domain = yes" --option="winbind enum users  = yes" --option="winbind enum groups = yes" --option="winbind refresh tickets = yes" --option="server signing = auto" --option="vfs objects = acl_xattr" --option="map acl inherit = yes" --option="store dos attributes = yes" --option="client use spnego = no" --option="use spnego = no" --option="client use spnego principal = no" --use-rfc2307 --use-xattrs=yes &>> $LOG
					 echo -e "Promoção do Servidor SAMBA-4 feita com Sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Verificando as informações do Controlador de Domínio do SAMBA-4"
					 echo
					 #Verificando informações do domínio.
					 tail -n6 $LOG | head -n5
					 echo
					 echo -e "Servidor SAMBA-4 promovido como Controlador de Domínio com Sucesso!!!"
					 echo -e "Pressione <Enter> para continuar com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG
					 
					 echo -e "Desabilitando a expiração da senha do usuário Administrator"
					 #Desativando a expiração da senha do usuário administrator
					 samba-tool user setexpiry administrator --noexpiry &>> $LOG
					 echo -e "Senha desabilitada com sucesso!!!, pressione <Enter> continuando com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Editando o arquivo NAMED.CONF"
					 echo -e "Acrescentar a linha: include "/var/lib/samba/private/named.conf" no final arquivo named.conf"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 
					 echo -e "Fazendo o backup do arquivo named.conf"
					 #Fazendo o backup do arquivo de configuração named.conf
					 mv -v /etc/bind/named.conf /etc/bind/named.conf.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo named.conf"
					 #Copiando o arquivo de configuração named.conf
					 cp -v conf/named.conf /etc/bind/named.conf >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração named.conf
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
					 
					 echo -e "Fazendo o backup do arquivo named.conf.options"
					 #Fazendo o backup do arquivo de configuração named.conf.options
					 mv -v /etc/bind/named.conf.options /etc/bind/named.conf.options.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo named.conf.options"
					 #Copiando o arquivo de configuração named.conf.options
					 cp -v conf/named.conf.options /etc/bind/named.conf.options >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração named.conf.options
					 vim /etc/bind/named.conf.options
					 
					 echo -e "NAMED.CONF.OPTIONS atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Editando o arquivo NAMED.CONF.LOCAL"
					 echo -e "Após a modificação do arquivo named.conf.local será gerado a chave novamente"
					 echo -e "Será criado um Link Simbolico para o serviço do DHCP utilizar a mesma chave"
					 echo -e "Acrescentar a linha: include "/etc/bind/rndc.key" no final do arquivo"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo
					 read
					 
					 echo -e "Fazendo o backup do arquivo named.conf.local"
					 #Fazendo o backup do arquivo de configuração named.conf.local
					 mv -v /etc/bind/named.conf.local /etc/bind/named.conf.local.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo named.conf.local"
					 #Copiando o arquivo de confguração named.conf.local
					 cp -v conf/named.conf.local /etc/bind/named.conf.local >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração named.conf.local
					 vim /etc/bind/named.conf.local +15
					 echo
					 
					 #Recurso de geração de chaves do Bind, recurso desativado em: 19/07/2016, falha na geração
					 #rndc-confgen -a
					 
					 echo -e "Alterando as permissões do arquivo rndc.key"
					 #Alterando as permissões de dono e grupo do arquivo de chaves rndc.key
					 chown -v root:bind /etc/bind/rndc.key >> $LOG
					 #Alterando as permissões de acesso do arquivo de chaves rndc.key
					 chmod -v 640 /etc/bind/rndc.key >> $LOG
					 #Criando um Link Simbólico do arquivo de chaves rndc.key
					 ln -v /etc/bind/rndc.key /etc/dhcp/ddns-keys/rndc.key >> $LOG
					 #Alterando as permissões de dono e grupo do link simbólico do arquivo de chaves rndc.key
					 chown -v root:bind /etc/dhcp/ddns-keys/rndc.key >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!"
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
					 
					 echo -e "Fazendo o backup do arquivo usr.sbin.named"
					 #Fazendo o backup do arquivo de configuração usr.sbin.named
					 mv -v /etc/apparmor.d/local/usr.sbin.named /etc/apparmor.d/local/usr.sbin.named.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo usr.sbin.named"
					 #Copiando o arquivo de configuração do usr.sbi.named
					 cp -v conf/usr.sbin.named /etc/apparmor.d/local/usr.sbin.named >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração usr.sbi.named
					 vim /etc/apparmor.d/local/usr.sbin.named
					 echo
					 
					 echo -e "Alterando as permissões do arquivo dns.keytab e named.conf"
					 #Alterando as permissões de dono e grupo do arquivo de chaves dns.keytab
					 chown -v bind:bind /var/lib/samba/private/dns.keytab >> $LOG
					 #Alterando as permissões de acesso ao grupo no arquivo de chves dns.keytab
					 chmod -v g+r /var/lib/samba/private/dns.keytab >> $LOG
					 #Alterando o dono grupo do arquivo de configuração do SAMBA4 named.conf
					 chown -v bind:bind /var/lib/samba/private/named.conf >> $LOG
					 echo -e "Permissões alteradas com sucesso!!!"
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
					 
					 echo -e "Fazendo o backup do arquivo sysctl.conf"
					 #Fazendo o backup do arquivo de configuração sysctl.conf
					 mv -v /etc/sysctl.conf /etc/sysctl.conf.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo sysctl.conf"
					 #Copiando o arquivo de configuração sysctl.conf
					 cp -v conf/sysctl.conf /etc/sysctl.conf >> $LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração sysctl.conf
					 vim /etc/sysctl.conf +73
					 
					 echo -e "SYSCTL.CONF atualizado com sucesso!!!, pressione <Enter> para continuando com o script!!!!"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG


					 echo -e "Editando o arquivo LIMITS.CONF para o servidor: `hostname`"
					 echo -e "Acrescentar no final do arquivo a linha: *		-	nofile		400000"
					 echo -e "Pressione <Enter> para editar o arquivo"
					 read
					 
					 echo -e "Fazendo o backup do arquivo limits.conf"
					 #Fazendo o backup do arquivo de configuração limits.conf
					 mv -v /etc/security/limits.conf /etc/security/limits.conf.old >> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 echo -e "Atualizando o arquivo limits.conf"
					 #Copiando o arquivo de configuração limits.conf
					 cp -v conf/limits.conf /etc/security/limits.conf >>$LOG
					 echo -e "Arquivo atualizado com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configuração limits.conf
					 vim /etc/security/limits.conf +70

					 echo -e "LIMITS.CONF atualizado com sucesso!!!, pressione <Enter> para continuando com o script!!!!"
					 read
					 sleep 2
					 clear
					 echo ============================================================ >> $LOG

					 echo -e "Editando o arquivo NAMED.CONF do SAMBA-4"
					 echo -e "Verificar as linhas referente a versão do BIND instalado"
					 echo
					 echo -e "Versão do BIND instalado: `named -v`"
					 echo
					 echo -e "Pressione <Enter> para editar o arquivo"
					 echo 
					 read
					 
					 echo -e "Fazendo o backup do arquivo named.conf"
					 cp -v /var/lib/samba/private/named.conf /var/lib/samba/private/named.conf.old &>> $LOG
					 echo -e "Backup feito com sucesso!!!"
					 sleep 2
					 echo
					 
					 #Editando o arquivo de configurando do SAMBA-4 named.conf
					 vim /var/lib/samba/private/named.conf +20

					 echo -e "NAMED.CONF do SAMBA4 atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
					 read
					 sleep 2
					 clear
					 
					 echo -e "Fim do Script-06.sh em: `date`" >> $LOG
					 echo ============================================================ >> $LOG

					 echo
					 echo -e "Configuração do SAMBA-4 como Controlador de Domínio feito com Sucesso!!!!!"
					 echo
					 # Script para calcular o tempo gasto para a execução do script-06.sh
						DATAFINAL=`date +%s`
						SOMA=`expr $DATAFINAL - $DATAINICIAL`
						RESULTADO=`expr 10800 + $SOMA`
						TEMPO=`date -d @$RESULTADO +%H:%M:%S`
					 echo -e "Tempo gasto para execução do script-06.sh: $TEMPO"
					 echo -e "Pressione <Enter> para concluir o processo e reiniciar o servidor."
					 sleep 3
					 read
					 reboot
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
