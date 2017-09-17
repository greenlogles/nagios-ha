#!/bin/bash

NAGIOS_USER=nagios
MOD_GEARMAN_CONF=/opt/nagios/etc/mod_gearman/module.conf

if [ -z $GEARMAN_SERVERS ]; then
	sed -i "s|server=127.0.0.1:4730|server=$GEARMAN_SERVERS|g" $MOD_GEARMAN_CONF
fi

if [ -z $GEARMAN_SEPARATED_HOSTGROUPS ]; then
	echo "hostgroups=$GEARMAN_SEPARATED_HOSTGROUPS" >> $MOD_GEARMAN_CONF
fi

if [ -z $GEARMAN_KEY ]; then
	sed -i "s|key=should_be_changed|key=$GEARMAN_KEY|g" $MOD_GEARMAN_CONF
fi

sudo -u $NAGIOS_USER /opt/nagios/bin/nagios  /opt/nagios/etc/nagios.cfg
