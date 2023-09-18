FROM php:fpm

LABEL maintainer="Kaustubh Mali"

RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli
RUN mkdir /app
COPY webapp/web-app.php /app

