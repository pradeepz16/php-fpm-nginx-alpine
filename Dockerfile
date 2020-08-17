FROM php:7.4.9-fpm-alpine3.12

WORKDIR /var/www/html
RUN apk update
RUN apk --no-cache add --update php7-bcmath \
php7-ctype \
php7-curl \
php7-dom \
php7-gd \
php7-iconv \
php7-intl \
php7-mbstring \
php7-openssl \
php7-pdo_mysql \
php7-simplexml \
php7-soap \
php7-xsl \
php7-zip \
libxml2

RUN apk --no-cache add nginx supervisor openssh-client git nano
COPY /config/php.ini "$PHP_INI_DIR/php.ini"

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY /config/nginx.conf /etc/nginx/nginx.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN adduser -D -g 'magento' magento
RUN mkdir /run/nginx
RUN chown -R magento:magento /run
RUN chown -R magento:magento /var/log/nginx
RUN chown -R magento:magento /var/lib/nginx

RUN chown -R magento:magento /var/www/html
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]