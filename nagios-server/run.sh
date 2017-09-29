#!/bin/bash

NAGIOS_USER=nagios
MOD_GEARMAN_CONF=/opt/nagios/etc/mod_gearman/module.conf

if [ ! -z "$GEARMAN_SERVERS" ]; then
	sed -i "s|server=localhost:4730|server=$GEARMAN_SERVERS|g" $MOD_GEARMAN_CONF
fi

if [ ! -z "$GEARMAN_SEPARATED_HOSTGROUPS" ]; then
	echo "hostgroups=$GEARMAN_SEPARATED_HOSTGROUPS" >> $MOD_GEARMAN_CONF
fi

if [ ! -z "$GEARMAN_KEY" ]; then
	sed -i "s|key=should_be_changed|key=$GEARMAN_KEY|g" $MOD_GEARMAN_CONF
fi


echo "result_queue=check_results_`hostname`" >> $MOD_GEARMAN_CONF

mkdir -p /opt/nagios/var/spool/checkresults
chown nagios: -R /opt/nagios/var/


echo "broker_module=/opt/nagios/lib/mod_gearman/mod_gearman_nagios4.o config=$MOD_GEARMAN_CONF" >> /opt/nagios/etc/nagios.cfg

sudo -u $NAGIOS_USER /opt/nagios/bin/nagios  /opt/nagios/etc/nagios.cfg
