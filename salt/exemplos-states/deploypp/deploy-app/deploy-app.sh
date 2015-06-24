#!/bin/bash

APP_DIR=/mnt/md0/app
APPS="app1 app2 " # apps a serem feitos os deploys 
GIT_USER=apache   # usuario do servidor web (apache ou nginx) 
GIT_ADDRESS="git@bitbucket.org:conta" # endereço serviço do git (github, bitbucket, etc)


case "$1" in
    full)
	WORK_DIR=$APP_DIR
	echo "app: Atualizando $WORK_DIR... em modo full";

	echo "app: Excluindo conteudo do dir $WORK_DIR..."	
	rm -rf $WORK_DIR/*
	cd $WORK_DIR/

	for APP in `echo $APPS`; do
	      echo "Atualizando: $APP"
	      sudo -Hu $GIT_USER git clone $GIT_ADDRESS/$APP
	done

	sync
	echo "app: Atualizado em modo full"
	exit 0;

	;;
    incremental-geral)

	WORK_DIR=$APP_DIR
	echo "app: Atualizando $WORK_DIR... em modo incremental-geral";
	cd $WORK_DIR/

	for APP in `echo $APPS`; do
	      cd $APP
	      echo "Atualizando: $APP"
	      sudo -Hu $GIT_USER git pull
	done

	sync
	echo "app: Atualizado em modo incremental-geral"
	exit 0;
	
	;;

    incremental-app)
	if [ -z "$2" ]; then
        	echo "ERRO: Use $SCRIPTNAME incremental-loja nomedaapp"; 
		exit 1;
	else
	   WORK_DIR=$APP_DIR
           echo "app: Atualizando $WORK_DIR... em modo incremental-app";
	   cd $WORK_DIR/$2
	   sudo -Hu $GIT_USER git pull

	   sync
      	   echo "app: Atualizado em modo incremental-app"
           exit 0;
	fi
	;;

    once-at-boot)
	BLOCK_FILE=/var/lock/once_at_boot_deploy_app
	if ! [ -f $BLOCK_FILE ]; then
		$0 full;
		touch $BLOCK_FILE
	else
		echo "deploy-app.sh: Script ja executado no boot (lock em $BLOCK_FILE)"	
	fi
	;;
   *)
        echo "ERRO: Use: $SCRIPTNAME {full|incremental-geral|incremental-app|once-at-boot}" >&2
        exit 1
    ;;
esac
