FROM php:8.0-fpm
RUN apt-get update && apt-get install -y

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y  --no-install-recommends \
    git \
    nano \
    zlib1g-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install \
        zip \
        intl \
        mysqli \
        pdo pdo_mysql pdo_pgsql pgsql \
        shmop \
        sockets \
        && pecl install xdebug \
        && docker-php-ext-enable xdebug

WORKDIR /tmp
RUN apt-get update -y && apt-get install -y wget

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN  mkdir /projects
WORKDIR /projects
