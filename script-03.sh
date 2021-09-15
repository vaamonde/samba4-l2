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
# Instalação dos pacotes principais para a quarta etapa, indicado para a distribuição GNU/Linux Ubuntu Server 16.04 LTS x64
#
# Instalando as dependências para Webmin - WebAdmin
# Baixando o Webmin do site Oficial (versão: 1.920)
# Instalando o Webmin via dpkg
# Porta padrão de acesso ao Webmin: https://SEU_ENDEREÇO_IP:10000
#
# Outras soluções de gerenciamento de servidor:
#
# Ajenti Server Admin Panel: http://ajenti.org/
# ISPConfig Hosting Control Panel: http://www.ispconfig.org/
# ZPanel | The free web hosting panel: http://www.zpanelcp.com/
# Virtualmin: Open Source Web Hosting and Cloud Control Panels: https://www.virtualmin.com/
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
# Exportação da variável de download da versão do Webmin (link atualizado em 23/07/2020)
VERSAO="webmin_1.953_all.deb"
TAMANHO="15.1 MB"
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
echo -e "Instalando as dependências do Webmin - WebAdmin"
echo -e "Baixando o Webmin do site Oficial (versão: $VERSAO tamanho: $TAMANHO)"
echo -e "Instalando o Webmin via dpkg -i $VERSAO"
echo -e "Para testar o Webmin após a instalação acesse a URL:: https://`hostname -I`:10000"
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
	apt-get -o Dpkg::Options::="--force-confold" upgrade -q -y --force-yes &>> $LOG
echo -e "Sistema Atualizado com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Instalando as Dependências do Webmin, aguarde..."
	# Instalando as dependências do Webmin
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes), \ (bar left) quebra de linha na opção do apt-get
	apt-get -y install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl \
	apt-show-versions python &>> $LOG
echo -e "Instalação das Dependências do Webmin Feito com Sucesso!!!, continuando o script..."
echo
echo ============================================================ >> $LOG

echo -e "Limpando o Cache do Apt-Get, aguarde..."
	# Limpando o diretório de cache do apt-get
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando apt-get: -y (yes)
	apt-get -y autoremove &>> $LOG
	apt-get -y autoclean &>> $LOG
	apt-get -y clean &>> $LOG
echo -e "Cache Limpo com Sucesso!!!, continuando o script..."
echo
echo -e "Pressione <Enter> para continuar com o script"
read
sleep 2
clear
echo ============================================================ >> $LOG

echo -e "Baixando o Webmin do Site Oficial, download de: $TAMANHO, aguarde..."
	# Fazendo o download do instalador do Webmin do site oficial
	# Listando o arquivo após fazer o download
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando ls: -l (list), -h (human-readable), -a (all)
	wget http://prdownloads.sourceforge.net/webadmin/$VERSAO &>> $LOG
	ls -lha $VERSAO >> $LOG
echo -e "Download feito com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Instalando o Webmin, aguarde..."
	# Instalando o Webmin utilizando o comando dpkg
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando dpkg: -i (install)
	dpkg -i $VERSAO &>> $LOG
echo -e "Instalação feita com sucesso!!!, continuando o script..."
sleep 2
echo

echo -e "Remoção do download do Webmin, aguarde..."
	# Removendo o arquivo de instalação do Webmin
	# opção do comando: &>> (redireciona a saída padrão, anexando)
	# opção do comando rm: -v (verbose)
	rm -v $VERSAO &>> $LOG
echo -e "Remoção do download feito com sucesso!!!, continuando o script..."
sleep 2
echo
echo ============================================================ >> $LOG

echo -e "Fim do script $0 em: `date`" >> $LOG
echo
echo -e "Instalação do Webmin feita com Sucesso!!!"
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