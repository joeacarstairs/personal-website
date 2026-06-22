FROM docker.io/arm32v7/nginx:1.30.3-alpine3.23
RUN apk --update add php85-fpm
COPY http/php /usr/share/nginx/php
COPY http/out /usr/share/nginx/html
COPY http/php-fpm.conf /etc/php/8.5/fpm/pool.d/joeac.net-http_pool.conf
COPY http/nginx.conf /etc/nginx/nginx.conf
