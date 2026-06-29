ARG ALPINE_VERSION=3.23
FROM docker.io/alpine:${ALPINE_VERSION}
RUN mkdir -p /var/app
WORKDIR /var/app
ARG ETHERPAD_VERSION
RUN apk --no-cache add pnpm \
  && ENV=~/.profile SHELL=sh pnpm setup \
  && source ~/.profile \
  && pnpm install --global tsx
COPY etherpad/etherpad-${ETHERPAD_VERSION} .
CMD pnpx tsx src/node/server.ts
