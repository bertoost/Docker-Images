FROM nginx:1.23.2-alpine

LABEL maintainer="Bert Oost <hello@bertoost.com>"

RUN addgroup -g 1000 -S app \
    && adduser -u 1000 -S app -G app

RUN apk add --no-cache bash gawk sed grep bc coreutils \
    && rm -rf /var/cache/apk/*

RUN mkdir /etc/nginx/conf.d/custom \
    && mkdir /etc/nginx/conf.d/partials

# Copy files where necessary
COPY defaults/nginx.conf /etc/nginx/nginx.conf
COPY defaults/fastcgi_params /etc/nginx/fastcgi_params
COPY defaults/overall_params.conf /etc/nginx/overall_params.conf
COPY defaults/overall_ssl.conf /etc/nginx/overall_ssl.conf
COPY defaults/project_root.conf /etc/nginx/project_root.conf
COPY defaults/health_check.conf /etc/nginx/health_check.conf
COPY defaults/partials/* /etc/nginx/conf.d/partials/

# Copy default NginX config
COPY conf.d/default.conf /etc/nginx/conf.d/default.placeholder

# Copy entrypoint file and make it executable
COPY build/entrypoint.sh /usr/src/docker-entrypoint.sh
RUN chmod +x /usr/src/docker-entrypoint.sh

EXPOSE 80
EXPOSE 8888

ENTRYPOINT [ "bash", "/usr/src/docker-entrypoint.sh" ]