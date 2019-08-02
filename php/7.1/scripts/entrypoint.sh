#!/bin/bash

# sSMTP environment variables support
SSMTP_SERVER="${SSMTP_SERVER:-mail.docker.local}" \
SSMTP_PORT="${SSMTP_PORT:-25}" \
SSMTP_USETLS="${SSMTP_USETLS:-YES}" \
SSMTP_USESTARTTLS="${SSMTP_USESTARTTLS:-YES}" \
envsubst < "/etc/ssmtp/ssmtp.conf.placeholder" > "/etc/ssmtp/ssmtp.conf"

# check if there was a command passed
# required by Jenkins Docker plugin: https://github.com/docker-library/official-images#consistency
if [ "$1" ]; then
    # execute it
    exec "$@"
fi

# Run PHP-FPM at last
php-fpm