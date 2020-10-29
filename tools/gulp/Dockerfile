FROM bertoost/node:14.0.0

LABEL maintainer="Bert Oost <hello@bertoost.com>"

RUN npm install gulp -g \
    && npm rebuild node-sass \
    && mkdir -p /app

WORKDIR /app
ENTRYPOINT ["/bin/bash", "-c"]
