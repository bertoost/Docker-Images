#!/bin/sh

if [[ "${BINARY_DIRECTORY}" != "" ]]; then

    mkdir -p /var/www/html/${BINARY_DIRECTORY}
    cp /home/php/projects_bin/* /var/www/html/${BINARY_DIRECTORY}
    cp /home/php/projects_bin/.gitignore /var/www/html/${BINARY_DIRECTORY}

    HOSTNAME=$(cat /etc/hostname)

    find /var/www/html/${BINARY_DIRECTORY} -type f -exec sed -i "s/CONTAINER_ID/${HOSTNAME}/" {} \;
fi

# SMTP environments
SMTP_AUTH="${SMTP_AUTH:-off}" \
SMTP_TLS="${SMTP_TLS:-off}" \
SMTP_STARTTLS="${SMTP_STARTTLS:-off}" \
SMTP_CERTCHECK="${SMTP_CERTCHECK:-off}" \
SMTP_CERTLOCATION="${SMTP_CERTLOCATION:-/etc/ssl/certs/ca-certificates.crt}" \
SMTP_HOST="${SMTP_HOST:-postoffice}" \
SMTP_PORT="${SMTP_PORT:-1025}" \
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
sudo -E php-fpm