#!/bin/bash

USER=apache #apache ou nginx 
SERVICE=git@bitbucket.org # Caso Github (git@github.com)


gitprep() {
        #Adiciona chave do server do git
        sudo -Hu $USER ssh -o StrictHostKeyChecking=no  $SERVICE
}


BLOCK_FILE=/var/lock/once_at_boot_git-prep
if ! [ -f $BLOCK_FILE ]; then
   gitprep
   touch $BLOCK_FILE
else
   echo "git-prep.sh: Script ja executado no boot (lock em $BLOCK_FILE)"
fi

