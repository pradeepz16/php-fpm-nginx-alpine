FROM php:7.4.9-fpm-alpine3.12

WORKDIR /var/www/html

RUN apk --no-cache add \
zlib-dev \
freetype-dev \
libjpeg-turbo-dev \
libpng-dev \
icu-dev \
libxml2-dev \
libxslt-dev \
libzip-dev

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install bcmath \
gd \
intl \
pdo_mysql \
soap \
sockets \
xsl \
zip

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
sed -i 's/memory_limit = .*/memory_limit = 2048M/' /usr/local/etc/php/php.ini

RUN apk --no-cache add nginx supervisor openssh-client git nano

RUN mkdir /run/nginx
RUN mkdir /run/supervisord

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/supervisord.conf /etc/supervisord.conf

COPY ./src /var/www/html
RUN adduser -D -g 'magento' magento
RUN chown -R magento:magento /var/lib/nginx
RUN chown -R magento:magento /var/www/html

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]