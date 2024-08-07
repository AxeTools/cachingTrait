FROM php:8.0-fpm-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \
  && docker-php-ext-install \
    zip \
    intl \
    mysqli \
    opcache

RUN yes | pecl install xdebug-3.3.1 \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN pecl install apcu && docker-php-ext-enable apcu \
    && echo "apc.enable_cli=1" >> /usr/local/etc/php/php.ini \
    && echo "apc.enable=1" >> /usr/local/etc/php/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_CACHE_DIR=/tmp

RUN mkdir --parents /tmp/logs

WORKDIR /var/www/