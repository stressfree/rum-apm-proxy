#!/bin/sh
envsubst '$PROXY_WEB_DOMAIN_URL $APM_SERVICE_NAME $APM_SERVER_URL $APM_ENVIRONMENT $APM_SERVER_INTAKE_URI' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
NGINX_VERSION="$(nginx -v)"
echo "${NGINX_VERSION}"
nginx -g 'daemon off;'