FROM bcit/openshift-okdcli:3.11
# vim: syntax=dockerfile

ENV HOME /tmp

LABEL maintainer="jesse_weisner@bcit.ca"
LABEL version="7.1.8.0"

COPY rpms /rpms

RUN yum -y install \
    /rpms/gskcrypt64-*.rpm \
    /rpms/gskssl64-*.rpm \
    /rpms/TIVsm-BA.x86_64.rpm \
    /rpms/TIVsm-API64.x86_64.rpm

ENV DSM_TCPSERVERADDRESS tsm.example.com
ENV DSM_NODE backupclient
ENV DSM_PASSWORD backuppassword
ENV DSM_TCPPORT 1500
ENV DSM_INCLEXCL /tmp/inclexcl
ENV DSM_LOG=/tmp
ENV BACKUP_PATHS="/data/*"

COPY 90-dsm.opt.sh \
     90-dsm.sys.sh \
     90-inclexcl.sh \
  /docker-entrypoint.d/

RUN mkdir /data \
 && chown 0:0 /data /opt/tivoli/tsm/client/ba/bin \
 && chmod 775 /data /opt/tivoli/tsm/client/ba/bin

VOLUME /tmp
VOLUME /data

WORKDIR /data

CMD ["/usr/bin/dsmc", "incr"]
