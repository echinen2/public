#!/bin/bash

BLOCK_FILE=/var/lock/once_at_boot_create_swap
if ! [ -f $BLOCK_FILE ]; then
   dd if=/dev/zero of=$1 bs=1M count=$2 && mkswap $1
   touch $BLOCK_FILE
else
   echo "create-swap.sh: Script ja executado no boot (lock em $BLOCK_FILE)"
fi
