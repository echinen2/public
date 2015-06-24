#!/bin/bash

# Script: logrotate-brlink.sh
# Funcao: Rotaciona os logs de um diretorio e faz o upload deles pro S3.
# Acoes:  Rotaciona manualmente os logs dos arquivos $LOG_FILES, compacta-os, 
#	e em seguida faz o upload dos arquivos para o S3 usando o "aws s3 cp". Apos o upload, checa se o 
#	arquivo esta no S3, se estiver excluir o local. Caso contrario, tenta novamente por mais duas vezes, 
#	e em caso de falha, renomeia o arquivo compactado para arquivo.broken, e envia email para avisar do 
#	problema.
#	Os logs sao gravados em $SCRIPT_LOG para acompanhamento.  

# Arquivos de logs para serem rotacionados
LOG_FILES="/mnt/md0/log/log1 /mnt/md0/log/log2" # Inserir arquivos de logs que serao rotacionados.

# Onde esta o aws cli
AWS_CLI="/usr/bin/aws --region us-east-1" # Alterar regiao do bucket de logs

# Em qual bucket do S3 os arquivos deverao subir?
S3_BUCKET=s3://log-archive-cliente

# Dados para envio de email de erro em caso de problemas
EMAIL_TO="email_destino@domain.com"
EMAIL_FROM="email_origem@domain.com"
EMAIL_AUTH_USER="email_origem@domain.com"
EMAIL_AUTH_PASS="password"
EMAIL_SERVER="mailserver.domain.com:587"

# Onde o script devera gravar os seus proprios logs de acoes
SCRIPT_LOG=/var/log/logrotate-brlink.log

# Daqui pra baixo, em geral, nada deve ser alterado

for FILE in $LOG_FILES; do
	/bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : Iniciando rotacao de log do arquivo $FILE" >> $SCRIPT_LOG 
	ROTACIONADO_FILE=$FILE-`date +%Y-%m-%d-%s`-`hostname`
        filename=$(basename "$ROTACIONADO_FILE")
	/bin/mv $FILE $ROTACIONADO_FILE
	/bin/touch $FILE
	/bin/sleep 3
	/etc/init.d/rsyslog restart > /dev/null 2> /dev/null
	/bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : Arquivo de log $FILE rotacionado com sucesso" >> $SCRIPT_LOG
	/bin/gzip $ROTACIONADO_FILE
	/bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : Arquivo de log $ROTACIONADO_FILE.gz compactado com sucesso" >> $SCRIPT_LOG
	$AWS_CLI s3 cp $ROTACIONADO_FILE.gz $S3_BUCKET/$filename.gz
	
	CHECK_S3=`$AWS_CLI s3 ls $S3_BUCKET/$filename.gz`
	VALIDA=`/bin/echo $CHECK_S3 | grep $filename.gz`
	
	
	#Checando se o arquivo subiu
	if [ "$VALIDA" ] ; then 
		/bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : Arquivo $ROTACIONADO_FILE.gz carregado com sucesso no S3" >> $SCRIPT_LOG; 
		/bin/rm -f $ROTACIONADO_FILE.gz > /dev/null 2> /dev/null
	else
                /bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : ERRO: nao foi posssivel subir o arquivo $ROTACIONADO_FILE.gz no S3, tentando uma segunda vez..." >> $SCRIPT_LOG;
		# Se nao estiver no S3, tenta subir novamente
		$AWS_CLI s3 cp $ROTACIONADO_FILE.gz $S3_BUCKET/$filename.gz	
	        CHECK_S3=`$AWS_CLI s3 ls $S3_BUCKET/$filename.gz`
        	VALIDA2=`/bin/echo $CHECK_S3 | grep $filename.gz`
		if [ "$VALIDA2" ] ; then 
			/bin/rm -f $ROTACIONADO_FILE.gz > /dev/null 2> /dev/null
                	/bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : Arquivo $ROTACIONADO_FILE.gz carregado com sucesso no S3" >> $SCRIPT_LOG;
        	else
                        /bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : ERRO: nao foi posssivel subir o arquivo $ROTACIONADO_FILE.gz no S3, tentando uma terceira (e ultima) vez..." >> $SCRIPT_LOG;
			$AWS_CLI s3 cp $ROTACIONADO_FILE.gz $S3_BUCKET/$filename.gz
	                CHECK_S3=`$AWS_CLI s3 ls $S3_BUCKET/$filename.gz`
        	        VALIDA3=`/bin/echo $CHECK_S3 | grep $filename.gz`
                	if [ "$VALIDA3" ] ; then
                        	/bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : Arquivo $ROTACIONADO_FILE.gz carregado com sucesso no S3" >> $SCRIPT_LOG;
				/bin/rm -f $ROTACIONADO_FILE.gz > /dev/null 2> /dev/null
                	else
                        	/bin/echo `date "+%b %d %H:%M:%S "`"logrotate-brlink.sh : ERRO: nao foi posssivel subir o arquivo $ROTACIONADO_FILE.gz no S3 por tres vezes seguidas. Movendo o arquivo para $ROTACIONADO_FILE.gz.broken. Enviando email para suporte." >> $SCRIPT_LOG;
				/bin/mv $ROTACIONADO_FILE.gz $ROTACIONADO_FILE.gz.broken
				# /usr/bin/sendEmail -u "[tarso.brlink.com.br] Problema no logrotate do arquivo $ROTACIONADO_FILE.gz" -t $EMAIL_TO -s $EMAIL_SERVER -xu $EMAIL_AUTH_USER -xp $EMAIL_AUTH_PASS -f $EMAIL_FROM -m "[tarso.brlink.com.br] \nSou script /scripts/logrotate-brlink/logrotate-brlink.sh. \n  \nTentei fazer a rotacao de logs do arquivo $FILE e subi-lo para o S3, mas houveram problemas. \n \nO arquivo compactado ainda se encontra no disco, em: \n$ROTACIONADO_FILE.gz.broken \n\nSera preciso subi-lo no S3 manualmente. Para isso voce podera usar o script: \n/scripts/logrotate-brlink/upload_broken_to_s3.sh \n \nFavor checar URGENTEMENTE para que nao ocorra perda de logs."
			fi
		fi
	fi
	
done

