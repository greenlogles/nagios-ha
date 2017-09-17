FROM ubuntu:14.04

MAINTAINER Alexandr shut <alexandr.shut@gmail.com>

ENV NAGIOS_PLUGINS_VERSION='2.2.1' GEARMAN_VERSION='1.1.17'

RUN apt-get update && apt-get install -y -q  wget \
                    build-essential \
                    iputils-ping \
                    libssl-dev \
                    unzip \
                    dnsutils \
		    \
		    libboost-system1.54-dev libboost-system1.54.0 libboost-filesystem1.54-dev libboost-filesystem1.54.0 libboost-chrono1.54-dev libboost-chrono1.54.0 libboost-program-options1.54-dev libboost-program-options1.54.0 libboost-thread1.54-dev libboost-thread1.54.0 libboost-test1.54-dev libboost-test1.54.0 \
		    gperf libevent-dev uuid-dev  libsqlite3-dev autoconf libltdl-dev libncurses5-dev \
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
		    && rm -rf /var/lib/apt/lists/*

# compile gearman and libgearman
RUN  cd /tmp && wget -q https://github.com/gearman/gearmand/releases/download/$GEARMAN_VERSION/gearmand-$GEARMAN_VERSION.tar.gz -O /tmp/gearmand-$GEARMAN_VERSION.tar.gz \
		    && tar -xzf gearmand-$GEARMAN_VERSION.tar.gz && cd  gearmand-$GEARMAN_VERSION/ \
		    && ./configure --enable-ssl  && make all && make install && cd && rm -rf /tmp/gearmand*

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

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD /run.sh


