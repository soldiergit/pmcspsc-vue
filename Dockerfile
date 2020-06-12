FROM docker.io/nginx

MAINTAINER soldier <soldier_wyyx.com>

RUN rm /etc/nginx/conf.d/default.conf

ADD default.conf /etc/nginx/conf.d/

COPY dist/  /usr/share/nginx/html/
