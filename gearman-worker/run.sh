#!/bin/bash

NAGIOS_USER=nagios
GEARMAN_WORKER_CONF=/opt/nagios/etc/mod_gearman/worker.conf

CMD="/opt/nagios/bin/mod_gearman_worker --config=$GEARMAN_WORKER_CONF --logmode=stdout --debug=1"

if [ -z $GEARMAN_SERVERS ]; then
	CMD="$CMD --server=$GEARMAN_SERVERS"
fi

#if [ -z $GEARMAN_SEPARATED_HOSTGROUPS ]; then
#	echo "hostgroups=$GEARMAN_SEPARATED_HOSTGROUPS" >> $MOD_GEARMAN_CONF
#fi

if [ -z $GEARMAN_KEY ]; then
	CMD="$CMD --key=$GEARMAN_KEY"
fi

sudo -u $NAGIOS_USER $CMD
