FROM node:19.3-alpine3.17

#RUN npm install react-scripts@5.0.1 -g --silent
RUN apk add --update --no-cache python3  \
    && ln -sf python3 /usr/bin/python \
    && python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools \
    # install latest updates
    && npm install -g npm

WORKDIR /app

CMD ["npm", "start"]