FROM ubuntu:20.04

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y \
    && apt-get install -y apt-transport-https tar wget curl nano gnupg git zlib1g-dev libxml2-dev libzip-dev \
    && apt install -y default-jre \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update -y \
    && apt-get install -y php8.0-dev php8.0-fpm php8.0-cli \
     php8.0-mysql php8.0-mysqli php8.0-pdo php8.0-pgsql \
     php8.0-ctype php8.0-zip php8.0-intl php8.0-xml php8.0-ldap \
     php-gd php8.0-xml php8.0-mbstring php8.0-curl php8.0-amqp php-xml php-pear php8.0-apcu php-mbstring \
    && pecl install xdebug  \
    && pecl install ds \
    && apt-get install -y supervisor 
RUN apt-get update -y \
    && apt install -y php-pear 
RUN apt-get install -y librdkafka-dev \
    && yes '' | pecl install rdkafka-5.0.1 \
    && yes '' | pecl install apcu

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN mkdir /projects && mkdir /run/php && mkdir /var/log/php-fpm

COPY ./configs/php/8.0/common /etc/php/8.0/cli/
COPY ./configs/php/8.0/common /etc/php/8.0/fpm/
COPY ./configs/php/8.0/fpm /etc/php/8.0/fpm/

RUN echo -e " \nextension=rdkafka.so" >> /etc/php/8.0/cli/php.ini \
    && echo -e " \nextension=rdkafka.so" >> /etc/php/8.0/fpm/php.ini

RUN echo -e " \nextension=rdkafka.so" >> /etc/php/8.0/cli/php.ini \
    && echo -e " \nextension=rdkafka.so" >> /etc/php/8.0/fpm/php.ini

RUN echo -e "\nextension=apcu.so" >> /etc/php/8.0/cli/php.ini \
    && echo -e " \nextension=apcu.so" >> /etc/php/8.0/fpm/php.ini

RUN update-alternatives --set php /usr/bin/php8.0

WORKDIR /projects

RUN usermod -u 1000 www-data

EXPOSE 9000

EXPOSE 9003

CMD ["php-fpm8.0", "-F"]