#!/bin/sh

# SMTP environments
SMTP_AUTH="${SMTP_AUTH:-off}" \
SMTP_TLS="${SMTP_TLS:-off}" \
SMTP_STARTTLS="${SMTP_STARTTLS:-off}" \
SMTP_CERTCHECK="${SMTP_CERTCHECK:-off}" \
SMTP_CERTLOCATION="${SMTP_CERTLOCATION:-/etc/ssl/certs/ca-certificates.crt}" \
SMTP_HOST="${SMTP_HOST:-mail.docker.local}" \
SMTP_PORT="${SMTP_PORT:-25}" \
SMTP_DOMAIN="${SMTP_DOMAIN:-docker.local}" \
SMTP_USER="${SMTP_USER}" \
SMTP_PASS="${SMTP_PASS}" \
envsubst < "/home/php/msmtprc.placeholder" > "/home/php/.msmtprc"

chmod 0600 /home/php/.msmtprc

# check if there was a command passed
# required by Jenkins Docker plugin: https://github.com/docker-library/official-images#consistency
if [ "$1" ]; then
    # execute it
    exec "$@"
fi

# Run PHP-FPM at last
php-fpm