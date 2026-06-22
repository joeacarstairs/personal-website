FROM docker.io/arm32v7/nginx:1.30.3-alpine3.23
RUN apk --update add php85-fpm
WORKDIR /var/app
COPY http/out http/php ./
