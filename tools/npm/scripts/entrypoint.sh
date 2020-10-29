#!/bin/sh

if [[ "${BINARY_DIRECTORY}" != "" ]]; then

    mkdir -p /app/${BINARY_DIRECTORY}
    cp /home/node/projects_bin/* /app/${BINARY_DIRECTORY}
    cp /home/node/projects_bin/.gitignore /app/${BINARY_DIRECTORY}

    HOSTNAME=$(cat /etc/hostname)

    find /app/${BINARY_DIRECTORY} -type f -exec sed -i "s/CONTAINER_ID/${HOSTNAME}/" {} \;
fi

# start app
npm start