FROM alpine

LABEL author='Paul Denning'
LABEL version='0.1.0'

ENV ICINGAWEB_VERSION="2.6.2" \
    DIRECTOR_VERSION="1.6.0" \
    GRAFANA_VERSION="1.3.2"


RUN apk update \
    && apk add --no-cache \
    mysql-client postgresql-client bash\
    ca-certificates openssl \
    php7 php7-apache2 php7-pdo_mysql php7-openssl php7-intl php7-ldap php7-gettext \
    php7-ctype php7-json php7-mbstring php7-session php7-curl php7-iconv

RUN mkdir -p /data/certs && \
    mkdir -p /data/etc/icingaweb2 && \
    mkdir -p /var/log/icingaweb2

RUN mkdir -p /icingaweb2 && \
    wget -q -O - https://github.com/Icinga/icingaweb2/archive/v${ICINGAWEB_VERSION}.tar.gz \
       | tar xz --strip 1 -C /icingaweb2

RUN mkdir -p /data/icingaweb2/modules/director && \
    wget -q -O - https://github.com/Icinga/icingaweb2-module-director/archive/v${DIRECTOR_VERSION}.tar.gz \
       | tar xz --strip 1 -C /data/icingaweb2/modules/director

RUN mkdir -p /data/icingaweb2/modules/grafana && \
    wget -q -O - https://github.com/Mikesch-mp/icingaweb2-module-grafana/archive/v${GRAFANA_VERSION}.tar.gz \
       | tar xz --strip 1 -C /data/icingaweb2/modules/grafana

RUN chown -R apache /icingaweb2 && \
    chown -R apache /data/icingaweb2/modules && \
    chown -R apache /var/log/icingaweb2

EXPOSE 80 443

VOLUME ["/data"]

ENTRYPOINT [ "/entrypoint.sh" ]