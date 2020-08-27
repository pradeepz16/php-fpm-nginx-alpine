FROM php:7.4.9-fpm-alpine3.12

WORKDIR /var/www/html

RUN apk --no-cache add \
zlib-dev \
libpng-dev \
icu-dev \
libxml2-dev \
libxslt-dev \
libzip-dev

RUN docker-php-ext-install bcmath \
gd \
intl \
pdo_mysql \
soap \
xsl \
zip

RUN apk --no-cache add nginx supervisor openssh-client git nano

RUN mkdir /run/nginx
RUN mkdir /run/supervisord

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/supervisord.conf /etc/supervisord.conf

COPY ./src /var/www/html

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]