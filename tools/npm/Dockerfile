FROM node:13.10.1-alpine3.11

RUN npm install --silent \
    && npm install react-scripts@3.0.1 -g --silent

# Project binary files
RUN mkdir -p /home/node/projects_bin \
    && chown node:node /home/node/projects_bin
COPY projects_bin /home/node/projects_bin/

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH
ENV BINARY_DIRECTORY "bin/"

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]