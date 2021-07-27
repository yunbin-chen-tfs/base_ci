FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y tftpd-hpa

VOLUME /srv/tftp

EXPOSE 69/udp

CMD echo -n "Starting " && in.tftpd --version && in.tftpd -L --user tftp -a 0.0.0.0:69 -s -v /srv/tftp
