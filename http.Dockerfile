FROM docker.io/arm32v7/nginx:1.30.3-alpine3.23
RUN apk --update add php85-fpm php85-pdo php85-pdo_sqlite
COPY http/vendor /usr/share/nginx/vendor
COPY http/php /usr/share/nginx/php
COPY http/out /usr/share/nginx/html
COPY http/php-fpm.conf /etc/php85/php-fpm.d/joeac.net-http_pool.conf
COPY http/nginx.conf /etc/nginx/nginx.conf
CMD mkdir -p "$(dirname "$DB_PATH")" \
  && touch $DB_PATH \
  && chown -R nginx:nginx "$(dirname "$DB_PATH")" \
  && chmod -R 600 "$(dirname "$DB_PATH")" \
  && php-fpm85 \
  && nginx -g "daemon off;"
