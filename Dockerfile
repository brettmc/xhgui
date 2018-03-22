FROM php:7.2-apache

RUN apt-get update \
    && apt-get install -y \
        git \
        unzip \
    && pecl install \
        mongodb \
    && docker-php-ext-enable \
        mongodb \
    && a2enmod rewrite \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && export PATH=$PATH:~/.composer/vendor/bin \
    && sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/webroot/' /etc/apache2/sites-enabled/000-default.conf

COPY . /var/www/html/

RUN mkdir /var/www/.composer \
    && chown www-data:www-data /var/www/.composer \
    && chown -R www-data:www-data /var/www/html

USER www-data

RUN composer install

USER root
