#!/bin/bash

# Perform environment variable substitution
envsubst '${SERVER}' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/nginx.conf

# Validate NGINX configuration
nginx -t || exit 1

# Start NGINX in the foreground
exec nginx -g 'daemon off;'
