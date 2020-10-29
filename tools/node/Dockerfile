FROM node:14.0.0-buster-slim

LABEL maintainer="Bert Oost <hello@bertoost.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN set -eux \
    && apt-get update \
	&& apt-get install -y gosu python make g++ \
	&& rm -rf /var/lib/apt/lists/* \
# verify that the binary works
	&& gosu nobody true

RUN userdel -r node \
    && mkdir -p /app

VOLUME ["/app"]
WORKDIR /app

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]