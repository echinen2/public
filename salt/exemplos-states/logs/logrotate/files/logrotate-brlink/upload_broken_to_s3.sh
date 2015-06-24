#!/bin/bash

# Script: upload_broken_to_s3.sh
# Funcao: Faz upload dos arquivos de logs "quebrados" para o S3.
# Acoes: Varre o $DIR_LOGS e procura arquivos *.broken. Tenta subi-los no s3 usando
# 	 o comando "aws s3 cp arquivo.broken s3://bucket/arquivo.  

LOG_FILES="/mnt/md0/log/log1 /mnt/md0/log/log2" # Inserir arquivos de logs que foram rotacionados  

AWS_CLI="/usr/bin/aws --region us-east-1" # Alterar regiao do bucket de logs
S3_BUCKET=s3://log-archive-cliente

for LOG_FILE in `echo $LOG_FILES`; do

for FILE in `ls $LOG_FILE*broken`; do

	# tratando nome do arquivo
	filename=$(basename "$FILE")	

	echo "Subindo arquivo $FILE"
	$AWS_CLI s3 cp $FILE $S3_BUCKET/$filename
	
	CHECK_S3=`$AWS_CLI s3 ls $S3_BUCKET/$filename`
	VALIDA=`echo $CHECK_S3 | grep $filename`
	
	#Checando se o arquivo subiu
	if [ "$VALIDA" ] ; then 
		echo "Arquivo $FILE no S3: Sucesso!" 
		echo "Excluindo arquivo $FILE do disco"
		rm -f $FILE 
	else
		echo "Nao foi possivel subir o arquivo $FILE no S3, checar se o arquivo existe, e se as credenciais do aws cli estao corretas. Saindo."
	fi
done

done
