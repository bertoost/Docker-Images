ARG ARCH
FROM ${ARCH}php:8.2.3-fpm-alpine3.17 AS base
LABEL maintainer="Bert Oost <hello@bertoost.com>"

# PHP-FPM defaults
ENV FCGI_CONNECT=/sock/fpm.sock
ENV FCGI_BACKLOG=128
ENV PHP_FPM_PM=dynamic
ENV PHP_FPM_PM_MAX_CHILDREN=50
ENV PHP_FPM_PM_START_SERVERS=2
ENV PHP_FPM_PM_MIN_SPARE_SERVERS=1
ENV PHP_FPM_PM_MAX_SPARE_SERVERS=3
ENV PHP_FPM_PM_PROCESS_IDLE_TIMEOUT=10
ENV PHP_FPM_PM_MAX_REQUESTS=1000

# PHP-OPcache defaults
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=256
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=20000
ENV PHP_OPCACHE_REVALIDATE_FREQUENCY=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0

ENV MUSL_LOCPATH /usr/share/i18n/locales/musl

ARG LOCAL_USER_ID=1000
ARG LOCAL_GROUP_ID=1000

USER root

# persistent / runtime depsfmusl
ENV PHPIZE_DEPS \
    autoconf \
    cmake \
    file \
    freetype-dev \
    g++ \
    gcc \
    gettext-dev \
    git \
    gmp-dev \
    icu-dev \
    krb5-dev \
    ldb-dev \
    libc-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libssh2-dev \
    libxml2-dev \
    libxslt-dev \
    libzip-dev \
    make \
    musl-dev \
    openldap-dev \
    pcre-dev \
    pkgconf \
    re2c \
    yaml-dev \
    zlib-dev

RUN apk add --no-cache --virtual .persistent-deps \
        autoconf \
        fcgi \
        freetype \
        g++ \
        gcc \
        gettext \
        git \
        icu \
        icu-data-full \
        imap \
        imap-dev \
        imagemagick \
        imagemagick-dev \
        libintl \
        libjpeg-turbo \
        libldap \
        libssh2 \
        libxslt \
        libzip \
        linux-headers \
        make \
        mariadb-client \
        oniguruma-dev \
        patch \
        tzdata

RUN set -xe \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure mbstring --enable-mbstring \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-install -j "$(nproc)" \
       bcmath \
       exif \
       gd \
       gettext \
       gmp \
       imap \
       intl \
       ldap \
       mbstring \
       opcache \
       pcntl \
       pdo_mysql \
       shmop \
       soap \
       sockets \
       sysvmsg \
       sysvsem \
       sysvshm \
       xsl \
       zip \
    && pecl install \
       APCu \
       ds \
       redis \
       imagick \
    && docker-php-ext-enable \
       apcu \
       ds \
       imagick \
       redis \

    # PHP User & ini
    && addgroup -g $LOCAL_GROUP_ID -S php \
    && adduser -u $LOCAL_USER_ID -S php -G php \

    # MUSL
    && wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
    && rm -rf musl-locales-master.zip \
    && cd musl-locales-master \
    && cmake -DLOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install \
    && cd .. && rm -r musl-locales-master \

    # Cleanup
    && apk del .build-deps \
    && apk --no-cache -U upgrade \
    && docker-php-source delete \
    && rm -rf /tmp/*

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# -------------------------
# PRODUCTION STAGE

FROM base AS production

USER root

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Use php's production ini & apply our own additional settings
COPY conf.d/php-prod.ini /usr/local/etc/php/conf.d/zzz-php-overrides.ini
COPY conf.d/php-fpm.conf /usr/local/etc/php-fpm.d/zzz-app.conf

# Add PHP scripts for aliases.
COPY scripts/php /usr/local/sbin
COPY scripts/php-fpm-healthcheck /usr/local/sbin
COPY scripts/composer /usr/local/sbin

RUN chmod +x /usr/local/sbin/php \
             /usr/local/sbin/php-fpm-healthcheck \
             /usr/local/sbin/composer

# Run commands inside this container as the created PHP user.
USER php

ENV TZ Europe/Amsterdam
ENV LANG nl_NL.UTF-8
ENV LANGUAGE nl_NL.UTF-8
ENV LC_ALL nl_NL.UTF-8

WORKDIR /var/www/html

CMD ["php-fpm"]

# -------------------------
# DEVELOPMENT STAGE

FROM production AS development

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=1

USER root

# xdebug
RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
       $PHPIZE_DEPS \
       # Local mail handling
       msmtp \
    && pecl install \
       xdebug \
    && docker-php-ext-enable \
       xdebug \
    && apk del .build-deps \
    && docker-php-source delete \
    # Install Blackfire
    && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && architecture=$(case $(uname -m) in i386 | i686 | x86) echo "i386" ;; x86_64 | amd64) echo "amd64" ;; aarch64 | arm64 | armv8) echo "arm64" ;; *) echo "amd64" ;; esac) \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/$architecture/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8307\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz \
    && mkdir -p /tmp/blackfire \
    && architecture=$(case $(uname -m) in i386 | i686 | x86) echo "i386" ;; x86_64 | amd64) echo "amd64" ;; aarch64 | arm64 | armv8) echo "arm64" ;; *) echo "amd64" ;; esac) \
    && curl -A "Docker" -L https://blackfire.io/api/v1/releases/cli/linux/$architecture | tar zxp -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire /usr/bin/blackfire \
    && rm -Rf /tmp/blackfire \
    && rm -rf /tmp/*

# Add-in dev PHP overrides
COPY conf.d/php-dev.ini /usr/local/etc/php/conf.d/zzzz-php-overrides.ini
COPY conf.d/pecl-xdebug.ini /usr/local/etc/php/conf.d/pecl-xdebug.ini

# Project binary files
RUN mkdir -p /home/php/projects_bin \
    && chown php:php /home/php/projects_bin
COPY projects_bin /home/php/projects_bin/
RUN chown php:php /home/php/projects_bin/* \
    && mv /home/php/projects_bin/gitignore-dummy /home/php/projects_bin/.gitignore

# Custom entrypoint
COPY ./scripts/entrypoint-dev.sh /home/php/entrypoint.sh
RUN chown php:php /home/php/entrypoint.sh \
    && chmod +x /home/php/entrypoint.sh

# MSMTP mail config
COPY conf.d/msmtprc.placeholder /home/php/msmtprc.placeholder

RUN mkdir -p /sock \
    && chown php:php /sock

# Run commands inside this container as the created PHP user.
USER php

ENV BINARY_DIRECTORY "bin/"
ENV XDEBUG_MODE develop,debug

WORKDIR /var/www/html

ENTRYPOINT ["/home/php/entrypoint.sh"]
CMD ["php-fpm"]