#!/bin/bash

if [[ $1 == "" ]]; then
  PORTNUMBER="$(jot -r 1 30000 65535)"
else
  PORTNUMBER=$1
fi

echo "Starting HTTP static server on port $PORTNUMBER..."
echo "http://localhost:$PORTNUMBER"
docker run --rm -it -p "$PORTNUMBER":80 -v "$(pwd)":/usr/share/nginx/html:ro nginx:latest
