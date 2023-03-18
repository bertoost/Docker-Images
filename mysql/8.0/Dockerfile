ARG ARCH
FROM ${ARCH}mysql:8.0.32

LABEL maintainer="Bert Oost <hello@bertoost.com>"

COPY conf.d/default.conf /etc/mysql/conf.d/default.cnf
COPY conf.d/sql-mode.conf /etc/mysql/conf.d/sql-mode.cnf
COPY custom/* /etc/mysql/temp/