#!/bin/bash

export DOLLAR='$'

# Walk trough all placeholder files and convert them to config files
DIRNAMES[0]="/etc/nginx/conf.d"
DIRNAMES[1]="/etc/nginx/conf.d/custom"

for DIRNAME in "${DIRNAMES[@]}"
do

  cd "${DIRNAME}"

  FILENAMES="*.placeholder"
  for FILENAME in $FILENAMES
  do
      if [[ -f $FILENAME ]]; then

          FILEBASE=$(basename "$FILENAME" .placeholder)
          envsubst < "./${FILEBASE}.placeholder" > "./${FILEBASE}.conf"
      fi
  done
done

# And start NginX
nginx -g "daemon off;"