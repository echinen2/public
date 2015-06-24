#!/bin/bash

start_raid() {
        DEVICES=`ls /dev/xvd[bcdefghijklmnop]`;
        DEVICES_COUNT=`echo $DEVICES | wc -w`;
        SUNIT=128;
        SWIDTH=$(( SUNIT * DEVICES_COUNT ));
        CHUNK=64;
        yes | mdadm --create /dev/md0 --level=0 -c${CHUNK} --raid-devices=${DEVICES_COUNT} ${DEVICES}
#        echo "DEVICE ${DEVICES}" > /etc/mdadm.conf
#        mdadm --detail --scan >> /etc/mdadm.conf
        blockdev --setra $(( CHUNK * 1024 )) /dev/md0

        mkfs.xfs -f -d sunit=${SUNIT},swidth=${SWIDTH},agcount=8 /dev/md0

#        sed -i "/\/dev\/md0/ d" /etc/fstab;
#        echo "/dev/md0 /mnt/md0 xfs defaults,sunit=${SUNIT},swidth=${SWIDTH},logbufs=8,logbsize=256k,noatime,nodiratime 0 0" >> /etc/fstab
#        if [ ! -d /mnt/md0 ] ; then mkdir /mnt/md0; fi;
#        mount /mnt/md0;

}

	BLOCK_FILE=/var/lock/once_at_boot_create_raid
	if ! [ -f $BLOCK_FILE ]; then
        	start_raid;
		touch $BLOCK_FILE
	else
		echo "create-raid.sh: Script ja executado no boot (lock em $BLOCK_FILE)"
	fi

