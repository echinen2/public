#!/bin/bash

format_ephemeral() {
        blockdev --setra $(( CHUNK * 1024 )) $1
        mkfs.xfs -f $1
}

	BLOCK_FILE=/var/lock/once_at_boot_format_ephemeral
	if ! [ -f $BLOCK_FILE ]; then
        	format_ephemeral $1;
		touch $BLOCK_FILE
	else
		echo "create-raid.sh: Script ja executado no boot (lock em $BLOCK_FILE)"
	fi

