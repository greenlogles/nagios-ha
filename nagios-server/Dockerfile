FROM ubuntu:14.04

MAINTAINER Alexandr shut <alexandr.shut@gmail.com>

ENV NAGIOS_PLUGINS_VERSION='2.2.1' NAGIOS_VERSION='4.3.2' GEARMAN_VERSION='1.1.17' MOD_GEARMAN_VERSION='3.0.5'

ENV NAGIOS_HOME		/opt/nagios
ENV NAGIOS_USER		nagios
ENV NAGIOS_GROUP	nagios
ENV NAGIOS_FQDN		nagios.example.com
ENV NAGIOSADMIN_USER	nagiosadmin
ENV NAGIOSADMIN_PASS	admin
ENV APACHE_RUN_USER	nagios
ENV APACHE_RUN_GROUP	nagios

ENV NAGIOS_TIMEZONE	UTC
ENV NAGIOS_CONFIG_FILE	${NAGIOS_HOME}/etc/nagios.cfg
ENV NAGIOS_CGI_DIR	${NAGIOS_HOME}/sbin
ENV NAGIOS_WWW_DIR	${NAGIOS_HOME}/share

ENV NAGIOS_RELEASE	nagios-4.3.4
ENV NAGIOS_PLUGINS_RELEASE	release-2.2.1
ENV NRPE_RELEASE	nrpe-3.2.1



RUN echo postfix postfix/main_mailer_type string "'Internet Site'" | debconf-set-selections  && \
    echo postfix postfix/mynetworks string "127.0.0.0/8" | debconf-set-selections            && \
    echo postfix postfix/mailname string ${NAGIOS_FQDN} | debconf-set-selections             && \
    apt-get update && apt-get install -y -q  wget \
                    build-essential \
                    iputils-ping \
                    postfix \
                    libssl-dev \
                    unzip \
                    libdigest-hmac-perl \
                    libnet-snmp-perl \
                    libcrypt-des-perl \
                    mailutils \
                    dnsutils \
		    git \
		    php5 apache2 libapache2-mod-php5 apache2-utils \
		    \
		    runit \
		    \
		    libboost-system1.54-dev libboost-system1.54.0 libboost-filesystem1.54-dev libboost-filesystem1.54.0 libboost-chrono1.54-dev libboost-chrono1.54.0 libboost-program-options1.54-dev libboost-program-options1.54.0 libboost-thread1.54-dev libboost-thread1.54.0 libboost-test1.54-dev libboost-test1.54.0 \
		    gperf libevent-dev uuid-dev  libsqlite3-dev autoconf libltdl-dev libncurses5-dev \
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
		    && rm -rf /var/lib/apt/lists/*
# compile nagios core
#RUN  wget -q https://assets.nagios.com/downloads/nagioscore/releases/nagios-$NAGIOS_VERSION.tar.gz -O /tmp/nagios-$NAGIOS_VERSION.tar.gz \
#		    && cd /tmp/ && tar -xzf nagios-$NAGIOS_VERSION.tar.gz && cd nagios-$NAGIOS_VERSION \
RUN cd /tmp && git clone https://github.com/NagiosEnterprises/nagioscore.git -b $NAGIOS_RELEASE && cd nagioscore && \
		    useradd --system nagios && \
		    ./configure --prefix=$NAGIOS_HOME && \
		    make all && make install && make install-init && make install-commandmode && make install-config && make install-webconf && cd && rm -rf /tmp/nagioscore* && \
		    mkdir -p $NAGIOS_HOME/etc/conf.d


# compile gearman and libgearman
RUN  cd /tmp && wget -q https://github.com/gearman/gearmand/releases/download/$GEARMAN_VERSION/gearmand-$GEARMAN_VERSION.tar.gz -O /tmp/gearmand-$GEARMAN_VERSION.tar.gz \
		    && tar -xzf gearmand-$GEARMAN_VERSION.tar.gz && cd  gearmand-$GEARMAN_VERSION/ \
		    && ./configure --enable-ssl  && make all && make install && cd && rm -rf /tmp/gearmand* && echo "/usr/local/lib/" > /etc/ld.so.conf.d/libgearman.conf && ldconfig

# compile mod_gearman
RUN  cd /tmp/ && wget -q https://github.com/sni/mod_gearman/archive/v$MOD_GEARMAN_VERSION.tar.gz -O /tmp/mod_gearman-$MOD_GEARMAN_VERSION.tar.gz && \
		    tar -xzf /tmp/mod_gearman-$MOD_GEARMAN_VERSION.tar.gz && cd /tmp/mod_gearman-$MOD_GEARMAN_VERSION/ && \
		    sed '/PKG_CHECK_MODULES(NAEMON,\ \[naemon >= 0.8\])/d' -i configure.ac && ./autogen.sh && \
		    LDFLAGS=-L/usr/local/lib/ CPPFLAGS="-I/usr/local/include/" ./configure --prefix=/opt/nagios --with-user=nagios --disable-naemon-neb-module --disable-nagios3-neb-module  --with-init-dir=/etc/init.d/ && \
		    make all && make install && cd && rm -rf /tmp/mod_gearman*



# compile nagios plugins
#RUN cd /tmp && git clone https://github.com/nagios-plugins/nagios-plugins.git -b $NAGIOS_PLUGINS_RELEASE && \
#    cd nagios-plugins &&  \
#    ./tools/setup && \
#    ./configure --prefix=$NAGIOS_HOME \
#    --with-cgiurl=/nagios/cgi-bin \
#    --with-nagios-user=$NAGIOS_USER \
#    --with-nagios-group=$NAGIOS_GROUP \
#    \
#    --with-ps-cols=2 \
#    --with-ps-format="%s %d %d %d %d %d %f %s %s %n" \
#    --with-ps-varlist="procstat,&procuid,&procpid,&procppid,&procvsz,&procrss,&procpcpu,procetime,procprog,&pos" \
#    --with-ps-command="/bin/ps axwo 'stat uid pid ppid vsz rss pcpu etime comm args'" && \
#    \
#    make && make install && \
#    mkdir -p /usr/lib/nagios/plugins && \
#    ln -sf /opt/nagios/libexec/utils.pm /usr/lib/nagios/plugins && \
#    cd && rm -rf /tmp/nagios-plugins*
# compile nagios plugins
RUN cd /tmp; wget -q https://github.com/nagios-plugins/nagios-plugins/releases/download/release-$NAGIOS_PLUGINS_VERSION/nagios-plugins-$NAGIOS_PLUGINS_VERSION.tar.gz && \
    tar -xzf nagios-plugins-$NAGIOS_PLUGINS_VERSION.tar.gz && \
    cd nagios-plugins-$NAGIOS_PLUGINS_VERSION &&  \
    ./configure --prefix=/opt/nagios \
    --with-cgiurl=/nagios/cgi-bin \
    --with-nagios-user=nagios \
    --with-nagios-group=nagios \
    \
    --with-ps-cols=2 \
    --with-ps-format="%s %d %d %d %d %d %f %s %s %n" \
    --with-ps-varlist="procstat,&procuid,&procpid,&procppid,&procvsz,&procrss,&procpcpu,procetime,procprog,&pos" \
    --with-ps-command="/bin/ps axwo 'stat uid pid ppid vsz rss pcpu etime comm args'" && \
    \
    make && make install && cd && rm -rf /tmp/nagios-plugins*


# compile NRPE
RUN cd /tmp && git clone https://github.com/NagiosEnterprises/nrpe.git -b $NRPE_RELEASE && cd nrpe && \
    ./configure --prefix=$NAGIOS_HOME --with-ssl=/usr/bin/openssl && \
    make check_nrpe && \
    cp src/check_nrpe ${NAGIOS_HOME}/libexec/ &&  \
    cd && rm -rf /tmp/nrpe*

ADD nagios/nagios.cfg /opt/nagios/etc/nagios.cfg
ADD nagios/cgi.cfg /opt/nagios/etc/cgi.cfg
ADD nagios/templates.cfg /opt/nagios/etc/objects/templates.cfg
ADD nagios/commands.cfg /opt/nagios/etc/objects/commands.cfg
ADD nagios/localhost.cfg /opt/nagios/etc/objects/localhost.cfg

ADD rsyslog/rsyslog.conf /etc/rsyslog.conf



RUN a2enmod cgi && \
    htpasswd -c -B -b /opt/nagios/etc/htpasswd.users nagiosadmin admin && \
    cp /etc/services /var/spool/postfix/etc/  && \
    echo "smtp_address_preference = ipv4" >> /etc/postfix/main.cf && \
    rm -rf /etc/rsyslog.d /etc/rsyslog.conf && \
    rm -rf /etc/sv/getty-5 && \
    \
    echo "use_timezone=${NAGIOS_TIMEZONE}" >> /opt/nagios/etc/nagios.cfg


ADD nagios.init /etc/sv/nagios/run
ADD apache.init /etc/sv/apache/run
#ADD postfix.init /etc/sv/postfix/run
#ADD rsyslog.init /etc/sv/rsyslog/run
ADD start.sh /usr/local/bin/start_nagios
RUN chmod +x /usr/local/bin/start_nagios

# enable all runit services
RUN ln -s /etc/sv/* /etc/service

ENV APACHE_LOCK_DIR /var/run
ENV APACHE_LOG_DIR /var/log/apache2

#Set ServerName and timezone for Apache
RUN echo "ServerName ${NAGIOS_FQDN}" > /etc/apache2/conf-available/servername.conf    && \
    echo "PassEnv TZ" > /etc/apache2/conf-available/timezone.conf            && \
    ln -s /etc/apache2/conf-available/servername.conf /etc/apache2/conf-enabled/servername.conf    && \
    ln -s /etc/apache2/conf-available/timezone.conf /etc/apache2/conf-enabled/timezone.conf

EXPOSE 80


VOLUME "/opt/nagios/var" "/opt/nagios/etc" "/opt/nagios/libexec" "/var/log/apache2" "/opt/Custom-Nagios-Plugins"
 


#ADD run.sh /run.sh
#RUN chmod +x /run.sh

#CMD /run.sh
CMD [ "/usr/local/bin/start_nagios" ]



