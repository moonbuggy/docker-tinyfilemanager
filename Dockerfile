# syntax = docker/dockerfile:1.4.0

ARG PHP_VERSION="7.4"
ARG FROM_IMAGE="moonbuggy2000/alpine-s6-nginx-php-fpm:${PHP_VERSION}"

## prepare config files
#
ARG BUILDPLATFORM="linux/amd64"
FROM --platform="${BUILDPLATFORM}" moonbuggy2000/fetcher:latest AS fetcher

ARG TEMP_DIR="/fetcher_temp"
WORKDIR "${TEMP_DIR}"
RUN wget -qO- https://github.com/prasathmani/tinyfilemanager/archive/refs/tags/2.4.7.tar.gz \
      | tar fxz - --strip-components=1

WORKDIR /fetcher_root
RUN cp "${TEMP_DIR}/tinyfilemanager.php" ./index.php \
  && cp "${TEMP_DIR}/config-sample.php" ./config.php

RUN mkdir files

# configure files in 'files/' and dark theme
RUN sed -E \
    -e "s|^(\\\$root_path\s?=\s?).*;|\1\$_SERVER['DOCUMENT_ROOT'].'\/files';|" \
    -e "s|^(\\\$root_url\s?=\s?).*;|\1'files\/';|" \
    -e "s|^(\\\$highlightjs_style\s?=\s?).*;|\1'ir-black';|" \
    -i config.php \
  && sed -E \
    -e "s|^(\\\$CONFIG\s?=.*theme\":\")[^\"]*(.*)|\1dark\2|" \
    -i index.php


## build the image
#
FROM "${FROM_IMAGE}"

ARG PHP_PACKAGE="php7"
RUN apk add --no-cache \
    libzip-dev \
    oniguruma-dev \
    "${PHP_PACKAGE}-ctype" \
    "${PHP_PACKAGE}-fileinfo" \
    "${PHP_PACKAGE}-iconv" \
    "${PHP_PACKAGE}-json" \
    "${PHP_PACKAGE}-mbstring" \
    "${PHP_PACKAGE}-phar" \
    "${PHP_PACKAGE}-session" \
    "${PHP_PACKAGE}-zip"

COPY root/ /

WORKDIR /var/www/html
COPY --from=fetcher --chown=www-data:www-data /fetcher_root/ ./
