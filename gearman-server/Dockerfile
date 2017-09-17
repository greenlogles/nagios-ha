FROM ubuntu:14.04

MAINTAINER Alexandr shut <alexandr.shut@gmail.com>

RUN apt-get update &&  apt-get install -y gearman-job-server && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 4730
EXPOSE 8080

#CMD ["/usr/sbin/gearmand", "--port 4730 --http-port 8080"]
ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD "/run.sh"

