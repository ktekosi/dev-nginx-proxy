#!/bin/bash

NGINX_CONTAINER=nginx-proxy-server

docker exec $NGINX_CONTAINER /app/clear-sites.sh

/app/clear-docblock-entries.sh "CONTAINERS"
/app/clear-docblock-entries.sh "DEV HOSTS"

docker container ls -q | xargs -r docker container inspect | \
  jq -r '.[] |
    select(.Config.Env[] | test("^HTTP_HOST=")) |
    "\(.Config.Env[] | select(test("^HTTP_HOST=")) | sub("HTTP_HOST="; "")) \(.NetworkSettings.Networks[].IPAddress) \((.Config.Env[] | select(test("^HTTP_PORT=")) | sub("HTTP_PORT="; "")) // "80")"' | \
  xargs -r -L 1 docker exec $NGINX_CONTAINER /app/add-site.sh

docker container ls -q | xargs -r docker container inspect | \
  jq -r '.[] |
    select(.Config.Env[] | test("^HTTP_HOST=")) |
    "\(.Config.Env[] | select(test("^HTTP_HOST=")) | sub("HTTP_HOST="; ""))"' | \
  xargs -r -L 1 /app/set-site-hostname.sh

docker container ls -q | xargs -r docker container inspect | \
  jq -r '.[] | "\(.NetworkSettings.Networks[].IPAddress) \(.Name | sub("/"; "")) CONTAINERS"' | \
  xargs -r -L 1 /app/update-hosts.sh

docker exec $NGINX_CONTAINER /app/reload.sh

