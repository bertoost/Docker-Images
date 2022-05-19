FROM node:18.0-alpine3.14

LABEL maintainer="Bert Oost <hello@bertoost.com>"

ENV GOSU_VERSION 1.14
RUN set -eux; \
	apk add --update --no-cache --virtual .gosu-deps \
		ca-certificates \
		dpkg \
		gnupg \
        python3 \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	  wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    # verify the signature
	  export GNUPGHOME="$(mktemp -d)"; \
	  gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	  gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	  command -v gpgconf && gpgconf --kill all || :; \
	  rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    # clean up fetch dependencies
	  apk del --no-network .gosu-deps; \
	  chmod +x /usr/local/bin/gosu; \
    # verify that the binary works
      gosu --version; \
      gosu nobody true \
    # Python
    && ln -sf python3 /usr/bin/python \
      python3 -m ensurepip \
      pip3 install --no-cache --upgrade pip setuptools \
    && gosu nobody true

RUN userdel -r node \
    && mkdir -p /app

RUN echo "Europe/Amsterdam" > /etc/timezone \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

VOLUME ["/app"]
WORKDIR /app

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]