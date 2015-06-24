#!/bin/bash

export NR_INSTALL_SILENT=1
export NR_INSTALL_KEY=257e4aa56ab00e8709c1d31c6aa451d4a9770ba9


BLOCK_FILE=/var/lock/once_at_boot_install_newrelic
if ! [ -f $BLOCK_FILE ]; then
   newrelic-install install
   touch $BLOCK_FILE
else
   echo "create-swap.sh: Script ja executado no boot (lock em $BLOCK_FILE)"
fi

