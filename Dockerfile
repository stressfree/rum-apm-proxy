FROM debian:buster-slim

ARG APM_VERSION=4.3.1

RUN apt-get update && \
    apt-get install -y ca-certificates gettext-base nginx libnginx-mod-http-subs-filter && \
    rm -rf /var/lib/apt/lists/*

ADD start-nginx.sh /

# Create an nginx user, set permissions and forward request and error logs to docker log collector
RUN useradd -s /usr/sbin/nologin -r -M nginx \
    && chmod a+x /start-nginx.sh \
    && chown -R nginx:nginx /var/lib/nginx \
    && chown -R nginx:nginx /var/log/nginx \
    && chown -R nginx:nginx /etc/nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && rm -rf /etc/nginx/* \
    && rm -rf /var/www/html/* \
    && mkdir /var/www/html/_rum

ADD https://github.com/elastic/apm-agent-rum-js/releases/download/%40elastic%2Fapm-rum%40${APM_VERSION}/elastic-apm-rum.umd.min.js /var/www/html/_rum/elastic-apm-rum.umd.min.js
ADD nginx.conf.template /etc/nginx/
ADD mime.types /etc/nginx/

EXPOSE 8080

USER nginx

CMD ["/start-nginx.sh"]
