#!/usr/bin/env bash

BLOCK_FILE=/var/lock/deepsecurity
if ! [ -f $BLOCK_FILE ]; then
   wget https://deepsecurity.brlink.com.br:4119/software/agent/RedHat_EL7/x86_64/ -O /tmp/agent.rpm --no-check-certificate --quiet ; rpm -ihv /tmp/agent.rpm
   touch $BLOCK_FILE
else
   echo "deepsecurity.sh: Script ja executado no boot (lock em $BLOCK_FILE)"
fi
