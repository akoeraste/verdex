#!/bin/sh
set -e

# Substitute $PORT in nginx.conf.template and move to nginx.conf
if [ -z "$PORT" ]; then
  export PORT=8080
fi
envsubst '$PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

exec "$@" 