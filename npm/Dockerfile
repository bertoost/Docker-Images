ARG ARCH
FROM ${ARCH}node:19.7-alpine3.17

LABEL maintainer="Bert Oost <hello@bertoost.com>"

RUN apk add --update --no-cache python3  \
    && ln -sf python3 /usr/bin/python \
    && python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools \
    # install latest updates
    && npm install -g npm@latest \
    # Cleanup
    && apk --no-cache -U upgrade \
    && rm -rf /tmp/*

WORKDIR /app

CMD ["npm", "start"]
