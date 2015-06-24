#!/bin/bash

set_hostname(){

IP=ip-`ifconfig eth0 | grep 'inet ' | cut -d't' -f2 | cut -d' ' -f2 | sed 's/\./-/g'`
GRAINS=`cat /etc/salt/grains | grep '-' | cut -c5-100 | cut -d" " -f1`
HOSTNAME=""
for GRAIN in "$GRAINS"; do
	HOSTNAME="$HOSTNAME$GRAIN"
done
HOSTNAME=`echo $HOSTNAME | sed 's/ /-/g'`

HOSTNAME="$HOSTNAME-$IP"
/bin/hostname $HOSTNAME

}



BLOCK_FILE=/var/lock/once_at_boot_set_hostname
if ! [ -f $BLOCK_FILE ]; then
   set_hostname
   touch $BLOCK_FILE
else
   echo "set-hostname.sh: Script ja executado no boot (lock em $BLOCK_FILE)"
fi
