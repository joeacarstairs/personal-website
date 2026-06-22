FROM docker.io/arm32v7/nginx:1.30.3-alpine3.23
RUN apk --update add build-base make
RUN make --directory=http --makefile=http/Makefile
COPY http/php /usr/share/nginx/php
COPY http/out /usr/share/nginx/html
