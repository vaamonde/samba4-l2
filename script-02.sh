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
# Instalação dos pacotes principais para a terceira etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# SAMBA4 (Server Message Block) Serviço de Armazenamento e Gerenciamento de Arquivos e Usuários
# DNS (Domain Name System) Serviço de Domínio de Nomes
# CUPS (Common Unix Printing System) Serviços de Impressão
# DHCP (Dynamic Host Configuration Protocol) Configuração Dinâmica de Computadores
# WINBIND Integração SAMBA-4 + Linux
# PAM (Pluggable Authentication Modules for Linux)
# QUOTA Criação de Quotas de Discos
# CLAMAV - sistema de anti-vírus
#
# Após o reboot fazer as mudanças do arquivo /etc/nsswitch.conf para suportar a autenticação via Winbind
#	vim /etc/nsswitch.conf
#	passwd:		files compat winbind
#	group:		files compat winbind
#	shadown:	files compat winbind
#	hosts:		files dns mdns4_minimal [NOTFOUND=return]
#
# Configurações de suporte a Quota, Acl e Xattr no arquivo /etc/fstab
# Utilizar essas configuração apenas para o sistema de arquivos EXT4
# Se tiver utilizando o BTRFS deixar o padrão
#
#	vim /etc/fstab
#	defaults,barrier=1,grpquota,usrquota
#
# Comando para confirmar as modificações feitas no FSTAB
#	tune2fs -l /dev/sda6 | grep "Default mount options:"
#
# Editando o arquivo /etc/hostname para acrescentar o FQDN
#	vim /etc/hostname
#	ptispo01dc01.pti.intra
#
# Editando o arquivo /etc/hosts
#	vim /etc/hosts
#	192.168.1.10	ptispo01dc01.pti.intra	ptispo01dc01
#
# Editando o arquivo /etc/defaults/grub
#	GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0" 
#	update-grub
#
# Atualizando o ClamAV
#	freshclam
#	service clamav-daemon start
#	service clamav-freshclam start
#
# Melhor anti-vírus para GNU/Linux, indicação: Sophos Antivirus for GNU/Linux
# Download: https://www.sophos.com/en-us/products/free-tools/sophos-antivirus-for-linux.aspx
# Instalação: https://www.sophos.com/en-us/support/knowledgebase/14378.aspx
# No Level-3 estarei utilizando ele nas configurações
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
# Exportação da variável de configuração do FQDN
FQDN=".pti.intra"
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
echo -e "Instalação dos software: SAMBA-4, DNS, CUPS, DHCP, WINBIND e QUOTA"
echo
echo -e "SAMBA-4 (Server Message Block) Serviço de Armazenamento e Gerenciamento de Arquivos e Usuários"
echo -e "DNS (Domain Name System) Serviço de Domínio de Nomes"
echo -e "CUPS (Common Unix Printing System) Serviços de Impressão"
echo -e "Para testar o CUPS após a instalação acesse a URL: http://`hostname -I`:631"
echo -e "DHCP (Dynamic Host Configuration Protocol) Configuração Dinâmica de Computadores"
echo -e "PAM (Pluggable Authentication Modules for Linux) Autenticação integrada"
echo -e "WINBIND Integração SAMBA-4 + Linux"
echo -e "QUOTA Criação de Quotas de Discos"
echo -e "CLAMAV Sistema de Anti-Vírus Open Source"
echo
echo -e "Configuração do FSTAB para suporte a Quota"
echo -e "Configuração do NSSWITCH para suporte a Winbind"
echo -e "Configuração do CLAMAV para suporte a Anti-vírus"
echo -e "Configuração do HOSTNAME para suporte a FQDN"
echo -e "Configuração do HOSTS para suporte a DNS local"
echo -e "Configuração do GRUB para ativar o recurso de Alias de Rede"
echo -e "Configuração do CUPS para suporte a configuração remota"
echo
echo -e "Após o término do script $0 o Servidor não será reinicializado"
echo
echo ============================================================ >> $LOG

echo -e "Atualizando as Listas do Apt-Get (apt-get update), aguarde..."
	# Atualizando as listas do apt-get
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	apt-get update &>> $LOG
echo -e "Listas Atualizadas com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Atualizando os Software instlados (apt-get upgrade), aguarde..."
	# Fazendo a atualização de todos os pacotes instalados no servidor
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -o (option), -q (quiet), -y (yes)
	apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
echo -e "Sistema Atualizado com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Instalação do SAMBA-4, CUPS, DHCP, QUOTA, BIND-DNS e CLAMAV e suas dependências, aguarde..."
	# Instalando os principais pacotes para o funcionamento correto dos serviços de rede
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes), \ (bar left) quebra de linha na opção do apt-get
	apt-get -y install samba samba-common smbclient cifs-utils samba-vfs-modules samba-testsuite samba-dbg \
	samba-dsdb-modules cups cups-bsd cups-common cups-core-drivers cups-pdf printer-driver-gutenprint \
	printer-driver-hpcups hplip openprinting-ppds cups-pk-helper antiword docx2txt gutenprint-doc gutenprint-locales \
	isc-dhcp-server winbind quota quotatool ldb-tools libnss-winbind libpam-winbind nmap bind9 bind9utils clamav \
	clamav-base clamav-daemon clamav-freshclam clamdscan clamfs clamav-testfiles clamav-unofficial-sigs arc cabextract \
	p7zip unzip unrar libclamunrar7 kcc tree &>> $LOG
echo -e "Instalação dos Serviços de Rede Feito com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG 

echo -e "Limpando o Cache do Apt-Get (apt-get autoremove && apt-get autoclean && apt-get clean), aguarde..."
	# Limpando o diretório de cache do apt-get
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes)
	apt-get -y autoremove &>> $LOG
	apt-get -y autoclean &>> $LOG
	apt-get -y clean &>> $LOG
echo -e "Cache Limpo com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Serviços instalados/atualizados com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Atualizando a Base de Vírus do ClamAV, aguarde esse processo demora alguns minutos..."
echo
echo -e "Para verificar o andamento do download, digite em outro terminal o comando:"
echo -e "tail -f /var/log/$0"
echo
echo -e "Caso o processo demora mais que o previsto, execute os comandos:"
echo -e "ps -aux | grep freshclam"
echo -e "kill ID_PROCESSO_FRESHCLAM"
	# Atualizando a base de dados de vírus do ClamAV, esse processo demora um pouco
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	freshclam &>> $LOG
echo
echo -e "Base de dados atualizada com sucesso!!!, continuando o script..."
echo

echo -e "Atualizando a Base de Vírus do ClamAV não oficial, aguarde esse processo demora alguns minutos..."
echo
echo -e "Para verificar o andamento do download, digite em outro terminal o comando:"
echo -e "tail -f /var/log/script-02.log"
echo
echo -e "Caso o processo demora mais que o previsto, execute os comandos:"
echo -e "ps -aux | grep clamav-unofficial"
echo -e "kill ID_PROCESSO_CLAMAV-UNOFFICIAL"
	# Atualizando a base de dados de vírus do ClamAV não Ofícial, esse processo demora um pouco
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	clamav-unofficial-sigs &>> $LOG
echo
echo -e "Base de dados não oficial atualizada com sucesso!!!, continuando o script..."
echo

echo -e "Iniciando o Serviço do ClamAV-Daemon, aguarde..."
	# Iniciando o serviço do ClamAV Antivírus
	sudo service clamav-daemon restart
	echo
echo -e "Iniciando o Serviço do ClamAV-Freshclam, aguarde..."
	# Iniciando o serviço do Freshclam que faz a atualização do ClamAV
	sudo service clamav-freshclam restart
	echo
echo -e "Serviços reinicializados com sucesso!!!, continuando o script..."
sleep 2
echo 

echo -e "Criando o diretório de quarentena em: /backup/quarentena, aguarde..."
	# Criando o diretório para armazenar os arquivos com vírus
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mkdir: -p (parents), -v (verbose)
	mkdir -pv /backup/quarentena >> $LOG
echo -e "Diretório de quarentena criado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Base de dados de vírus atualizadas com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Agendamento do escaneamento do ClamAV no diretório /arquivos ás 22:30hs, todos os dias"
echo
echo -e "30 22  * * *    root     clamscan -r -i -v /arquivos --move=/backup/quarentena --log=/var/log/scan-arquivos.log"
echo
echo
echo -e "Agendamento das atualizações do Freshclam ás 21:30hs, todos os dias"
echo
echo -e "30 21  * * *    root     freshclam"
echo
echo
echo -e "Editando o arquivo /etc/cron.d/clamav para acrescentar informações de agendamento do ClamAV"
echo -e "Pressione <Enter> para editar o arquivo"
read
sleep 2

echo -e "Copiando o arquivo de agendamento do clamav para diretório do cron.d, aguarde..."
	# Copiando o arquivo de agendamento do ClamAV
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/clamav /etc/cron.d/ >> $LOG
echo -e "Arquivo copiado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Copiando o arquivo de agendamento do freshclam para diretório do cron.d, aguarde..."
	# Copiando o arquivo de agendamento do Freshclam
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/freshclam /etc/cron.d/ >> $LOG
echo -e "Arquivo copiado com sucesso!!!, continuando o script..."
sleep 2
echo 

echo -e "Editando o arquivo clamav, aguarde..."
	# Editando o arquivo de agendamento de vírus do ClamAV
	vim /etc/cron.d/clamav +14
	echo
echo -e "CLAMAV atualizado com sucesso!!!, pressione <Enter> para continuando com o script"
read
sleep 2
clear

echo -e "Editando o arquivo /etc/cron.d/freshclam para acrescentar informações de agendamento das atualizações"
echo -e "Pressione <Enter> para editar o arquivo"
read
sleep 2

echo -e "Editando o arquivo freshclam, aguarde..."
	# Editando o arquivo de agendamento de atualização da base de dados do ClamAV
	# opção do comando vim: + (num line)
	vim /etc/cron.d/freshclam +15
echo
echo -e "FRESHCLAM atualizado com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 2
clear

echo -e "Editando o arquivo /etc/cron.d/clamav-unofficial-sigs para acrescentar informações de agendamento do ClamAV"
echo -e "Alterar o tempo para 45 20 - 20:45hs"
echo -e "Pressione <Enter> para editar o arquivo"
read
echo

echo -e "Fazendo backup do arquivo de agendamento do clamav-unofficial-sigs, aguarde..."
	# Fazendo o backup do arquivo de agendamento do ClamAV Não Oficial
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/cron.d/clamav-unofficial-sigs /etc/cron.d/clamav-unofficial-sigs.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo de agendamento do clamav-unofficial-sigs, aguarde..."
	# Copiando o arquivo de agendamento do ClamAV Não Oficial
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/clamav-unofficial-sigs /etc/cron.d/ >> $LOG
echo -e "Atualização feita com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo clamav-unofficial-sigs, aguarde..."
	# Editando o arquivo de agendamento do ClamAV Não Oficial
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando vim: + (num line)
	vim /etc/cron.d/clamav-uno* +27
echo

echo -e "CLAMAV-UNOFFICIAL-SIGS atualizado com sucesso!!!, pressione <Enter> para continuar com o script"
read
sleep 3
clear

echo -e "Testando o Anti-Vírus ClamAV, utilizando o site: www.eicar.org"
echo
echo -e "Baixando os arquivos *.com e *.zip com o vírus: Eicar-Test-Signature"
echo
echo -e "Movendo o conteúdo infectado para o diretório de quarentena em: /backup/quarentena"
echo
sleep 2

echo -e "Fazendo o download do arquivo eicar.com, aguarde..."
	# Fazendo o download do arquivo eicar.com e armazenando no diretório /arquivos
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando wget: -c (continue), -P (prefix)
	wget -c -P /arquivos https://www.eicar.org/download/eicar.com &>> $LOG
echo -e "Download feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Fazendo o download do arquivo eicar_com.txt, aguarde..."
	# Fazendo o download do arquivo eicar_com.txt e armazenando no diretório /arquivos
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando wget: -c (continue), -P (prefix)
	wget -c -P /arquivos https://www.eicar.org/download/eicar_com.txt &>> $LOG
echo -e "Download feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Copiando o arquivo eicar.com para diretório /arquivos e alterando sua extensão para .bat, aguarde..."
	# Copiando o arquivo eicar.com e criando um arquivo com extensão .bat
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v /arquivos/eicar.com /arquivos/eicar.bat &>> $LOG
echo -e "Arquivo copiado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Zipando o arquivo eicar.bat, aguarde..."
	# Zipando o arquivo eicar.bat
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando bzip2: -v (verbose)
	bzip2 -v /arquivos/eicar.bat &>> $LOG
echo -e "Arquivo zipado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Executando a verificação de vírus no diretório /arquivos, aguarde..."
	echo
	# Executando a varredura de vírus no diretório /arquivos, caso encontre vírus, mover para o diretório /backup/quarentena
	# opção do comando clamscan: -r (recursive), -i (infected), -v (verbose)
	clamscan -r -i -v /arquivos --move=/backup/quarentena
	echo
echo -e "Verificação feita com sucesso!!!, continuando o script..."
sleep 2
echo


echo -e "Listando o conteúdo do diretório /backup/quarentena, aguarde..."
	# Listando o conteúdo do diretório /backup/quarentena
	# opção do comando ls: -l (list), -h (human-readable), -a (all)
	ls -lha /backup/quarentena
	echo
echo -e "Listagem feita com sucesso!!!, continuando o script..."
sleep 3
echo

echo -e "Teste de análise vírus realizada com sucesso!!!, pressione <Enter> para continuar o script"
read
sleep 2
clear

echo -e "Removendo o conteúdo infectado do diretório de quarentena em: /backup/quarentena"
echo
echo -e "Executando a remoção do vírus do diretório /backup/quarentena"
echo

echo -e "Verificando o diretório quarentena, aguarde..."
	# Verificando o diretório quarentena e removendo os vírus
	# opção do comando clamscan: -r (recursive), -i (infected), -v (verbose)
	clamscan -r -i -v /backup/quarentena --remove
	echo
echo -e "Verificação feita com sucesso!!!, continuando o script..."
sleep 3
echo

echo -e "Listando o conteúdo do diretório /backup/quarentena, aguarde..."
	echo
	# Listando o conteúdo do diretório /backup/quarentena
	# opção do comando ls: -l (list), -h (human-readable), -a (all)
	ls -lha /backup/quarentena
	echo
echo -e "Listagem feita com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Remoção do vírus realizada com sucesso!!!, pressione <Enter> para continuar o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/fstab para acrescentar as informações de Quota"
echo
echo -e "Sistemas de arquivos BTRFS o sistema de Quota e diferente, deixar o padrão"
echo
echo -e "Linha a ser editada no arquivo /etc/fstab"
echo
echo -e "`cat -n /etc/fstab | sed -n '9p'`"
echo
echo -e "Informações a serem acrescentadas depois de ext4: defaults,barrier=1,grpquota,usrquota"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read
sleep 2

echo -e "Fazendo o backup do arquivo fstab, aguarde..."
	# Fazendo o backup do arquivo fstab
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v /etc/fstab /etc/fstab.old.1 &>> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo fstab, aguarde..."
	# Editando o arquivo fstab
	vim /etc/fstab
echo
echo -e "Arquivo editado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Remontando o ponto de montagem: /arquivos, aguarde..."
	# Remontando a partição /arquivos com as novas opções de quota
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mount: -v (verbose), -o (options)
	mount -v -o remount /arquivos &>> $LOG
echo -e "Remontagem feita com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Habilitando o recurso de quota de disco no ponto de montagem /arquivos, aguarde..."
	# Habilitando o recurso de quota e criando os arquivos quota.user e quota.group
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando quotacheck: -u (user), -g (group), -c (create-files), -v (verbose)
	quotacheck -ugcv /arquivos &>> $LOG
echo -e "Quota de Disco habilitada com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "FSTAB atualizado com sucesso!!!, Pressione <Enter> continuando com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/nsswitch.conf para acrescentar as informações de Winbind"
echo
echo -e "Linhas a serem editadas no arquivo /etc/nsswitch.conf"
echo -e "`cat -n /etc/nsswitch.conf | head -n9 | tail -n3`"
echo
echo -e "Informações a serem acrescentadas depois de compact: winbind"
echo
echo -e "Linha a ser editada no arquivo /etc/nsswitch.conf"
echo -e "`cat -n /etc/nsswitch.conf | head -n12 | tail -n1`"
echo
echo -e "Informações a serem alteradas depois de files: dns mdns4_minimal [NOTFOUND-RETURN]"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read
sleep 2

echo -e "Fazendo o backup do arquivo nsswitch.conf, aguarde..."
	# Fazendo o backup do arquivo de configuração do nsswitch.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/nsswitch.conf /etc/nsswitch.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo nsswitch.conf, aguarde..."
	# Copiando o arquivo de configuração do nsswitch.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/nsswitch.conf /etc/nsswitch.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo nsswitch.con, aguarde..."
	# Editando o arquivo de configuração do nsswitch.conf
	vim /etc/nsswitch.conf
echo

echo -e "NSSWITCH.CONF atualizado com sucesso!!!, Pressione <Enter> continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/hostname para acrescentar as informações de FQDN"
echo
echo -e "Linha a ser editada no arquivo /etc/hostname"
echo -e "`cat -n /etc/hostname`"
echo
echo -e "Informações a serem acrescentadas depois de `hostname`: $FQDN"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo hostname, aguarde..."
	# Fazendo o backup do arquivo de configuração hostname
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/hostname /etc/hostname.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo hostname, aguarde..."
	# Copiando o arquivo de configuração do hostname
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/hostname /etc/hostname >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo hostname, aguarde..."
	# Editando o arquivo de configuração do hostname
	# opção do comando vim: + (num line)
	vim /etc/hostname +13
echo

echo -e "HOSTNAME atualizado com sucesso!!!, Pressione <Enter> continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/hosts para acrescentar as informações de DNS Local"
echo
echo -e "Linhas a serem editadas no arquivo /etc/hosts"
echo -e "`cat -n /etc/hosts | head -n3`"
echo
echo -e "Informação a ser acrescentadas na linha 03: 192.168.1.10 ptispo01dc01.pti.intra ptispo01dc01"
echo
echo -e "Recomendo utilizar a tecla <TAB> para separar os valores"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo hosts, aguarde..."
	# Fazendo o backup do arquivo de configuração do hosts
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/hosts /etc/hosts.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo hosts, aguarde..."
	# Copiando o arquivo de configuração do hosts
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/hosts /etc/hosts >> $LOG
echo -e "Arquivos atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo hosts, aguarde..."
	# Editando o arquivo de configuração do hosts
	# opção do comando vim: + (num line)
	vim /etc/hosts +14
echo

echo -e "HOSTS atualizado com sucesso!!!, Pressione <Enter> continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/defaults/grub para acrescentar as informações de Interface de Rede"
echo
echo -e "Linhas a serem editadas no arquivo /etc/defaults/grub"
echo -e "`cat -n /etc/default/grub | sed -n '11p'`"
echo
echo -e "Informação a ser acrescentada na variável GRUB_CMDLINE_LINUX_DEFAULT: net.ifnames=0"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read

echo -e "Fazendo o backup do arquivo grub, aguarde..."
	# Fazendo o backup do arquivo de configuração do grub
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/default/grub /etc/default/grub.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo do grub, aguarde..."
	# Copiando o arquivo de configuração do grub
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/grub /etc/default/grub >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo grub, aguarde..."
	# Editando o arquivo de configuração do grub
	# opção do comando vim: + (num line)
	vim /etc/default/grub +24
echo
echo -e "Arquivo editado com sucesso!!!!, continuando o script..."
sleep 2
echo

echo -e "Desativando o Serviço do LXD-CONTAINERS, aguarde..."
	# Desabilitando o serviço de LXD Containers que vem habilitado como padrão
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	systemctl disable lxd-containers.service &>> $LOG
echo -e "Serviço desabilitado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Desativando o CTRL+ALT+DEL (para não reinicializar o servidor), aguarde..."
	# Desabilitando o recurso de pressione CTRL+ALT+DEL para reinicializar o servidor 
	# Restartando todos os serviços
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	systemctl mask ctrl-alt-del.target &>> $LOG
	systemctl daemon-reload &>> $LOG
echo -e "Serviço desabilitado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Desinstalando o Serviço do SNAPD, aguarde..."
	# Desinstalando o serviço de SNAPD que vem habilitado como padrão
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes)
	sudo apt-get purge -y snapd &>> $LOG
echo -e "Serviço desinstalado com sucesso!!!, continuando o script..."
sleep 2
echo


echo -e "Atualizando o GRUB, aguarde..."
	# Atualizando o grub com as novas modificações feitas no arquivo grub, atualizar Kernel e Initrd
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	update-grub &>> $LOG
echo -e "Atualização feita com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "GRUB atualizado com sucesso!!!, Pressione <Enter> continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Editando o arquivo /etc/cups/cupsd.conf para liberar o acesso remoto"
echo -e "Pressione <Enter> para editar o arquivo"
echo 
read
sleep 2

echo -e "Fazendo o backup do arquivo do cupsd.conf, aguarde..."
	# Fazendo o backup do arquivo de configuração do cupsd.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/cups/cupsd.conf /etc/cups/cupsd.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo do cupsd.conf, aguarde..."
	# Copiando o arquivo de configuração do cupsd.conf
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/cupsd.conf /etc/cups/cupsd.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo cupsd.conf, aguarde..."
	# Editando o arquivo de configuração do cupsd.conf
	vim /etc/cups/cupsd.conf
	echo
echo -e "Arquivo editado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Verificando as informações de impressoras, aguarde..."
	# Verificando informações de impressoras
	# opção do comando lpinfo: -v (all devices), -m (all drivers)
	lpinfo -vm
	echo
echo -e "Verificação feita com sucesso!!!, continuando o script..."
sleep 3
echo

echo -e "Verificando o status das impressoras, aguarde..."
	# Verificando os status das impressoras
	# opção do comando lpstat: -t (all status)
	lpstat -t
	echo
echo -e "Verificação feita com sucesso!!!, continuando o script..."
sleep 3
echo

echo -e "Testando as configurações do arquivo: cupsd.conf, aguarde..."
	# Testando as configurações do arquivo cupsd.conf
	# opção do comando cupsd: -t (test file)
	cupsd -t
echo -e "Configurações testadas com sucesso!!!, continuando o script..."
sleep 3
echo

echo -e "CUPSD.CONF atualizado com sucesso!!!, Pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Atualizando é editando arquivo CUPS-PDF.CONF, pressione <Enter> para continuar com o script"
read
sleep 2

echo -e "Fazendo o backup do arquivo cups-pdf.conf, aguarde..."
	# Fazendo o backup do arquivo original
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/cups/cups-pdf.conf /etc/cups/cups-pdf.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo do cups-pdf.conf, aguarde..."
	# Atualizando o arquivo
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/cups-pdf.conf /etc/cups/cups-pdf.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo cups-pdf.conf, aguarde..."
	# Editando o arquivo CUPS-PDF
	vim /etc/cups/cups-pdf.conf
echo
echo -e "Arquivo editado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Reinicializando os serviços do CUPS e CUPS-BROWSED, aguarde..."
	# Reinicializando os serviços do CUPS
	sudo service cups restart
	sudo service cups-browsed restart
echo -e "Serviços reinicializados com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Arquivos atualizado com sucesso!!! pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Atualizando é editando arquivo SNMP.CONF, pressione <Enter> para continuar com o script"
read
sleep 2

echo -e "Fazendo o backup do arquivo snmp.conf, aguarde..."
	# Fazendo o backup do arquivo original
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/cups/snmp.conf /etc/cups/snmp.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo do snmp.conf, aguarde..."
	# Atualizando o arquivo
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/snmp.conf /etc/cups/snmp.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo snmp.conf, aguarde..."
	# Editando o arquivo
	vim /etc/cups/snmp.conf
echo
echo -e "Arquivo editado com sucesso!!!, continuando o script..."
sleep 2
echo
			
echo -e "Arquivo atualizado com sucesso!!! pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Atualizando é editando arquivo CUPS-FILES.CONF, pressione <Enter> para continuar com o script"
read
sleep 2

echo -e "Fazendo o backup do arquivo cups-files.conf, aguarde..."
	# Fazendo o backup do arquivo original
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/cups/cups-files.conf /etc/cups/cups-files.conf.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo do cups-files.conf, aguarde..."
	# Atualizando o arquivo
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/cups-files.conf /etc/cups/cups-files.conf >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo cups-files.conf, aguarde..."
	# Editando o arquivo
	vim /etc/cups/cups-files.conf
echo
echo -e "Arquivo editado com sucesso!!!, continuando o script..."
sleep 2
echo
			
echo -e "Arquivo atualizado com sucesso!!! pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Atualizando é editando arquivo USR.SBIN.CUPSD, pressione <Enter> para continuar"
read
sleep 2

echo -e "Fazendo o backup do arquivo usr.sbin.cupsd, aguarde..."
	# Fazendo o backup do arquivo original
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando mv: -v (verbose)
	mv -v /etc/apparmor.d/usr.sbin.cupsd /etc/apparmor.d/usr.sbin.cupsd.old >> $LOG
echo -e "Backup feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Atualizando o arquivo usr.sbin.cupsd, aguarde..."
	# Atualizando o arquivo
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando cp: -v (verbose)
	cp -v conf/usr.sbin.cupsd /etc/apparmor.d/usr.sbin.cupsd >> $LOG
echo -e "Arquivo atualizado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Editando o arquivo usr.sbin.cupsd, aguarde..."
	# Editando o arquivo USR.SBIN.CUPSD
	# opção do comando vim: + (num line)
	vim /etc/apparmor.d/usr.sbin.cupsd +183
echo
echo -e "Arquivo editado com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Reinicializando os serviços do CUPS e do APPARMOR, aguarde..."
	# Reinicializando os serviços do CUPS
	sudo service apparmor restart
	sudo service cups restart
	sudo service cups-browsed restart
echo -e "Serviços reinicializados com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Arquivos atualizados com sucesso!!! pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Fim do script $0 em: `date`" >> $LOG
echo
echo -e "Instalação dos Serviços de Rede Feito com Sucesso!!!!!"
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