FROM node:lts-alpine3.22
WORKDIR /app

RUN apk add --no-cache git
COPY website/package.json website/package-lock.json ./
RUN npm install && apk del git

COPY website/astro.config.mjs website/redirects.mjs ./
COPY website/db ./db/
ARG DB_URL=file:/app/db.sqlite
ENV ASTRO_DB_REMOTE_URL=$DB_URL
RUN mkdir -p "$(dirname "$(echo "$ASTRO_DB_REMOTE_URL" | cut -d':' -f 2)")"
RUN npm run astro db push

COPY website .

RUN mkdir -p /common
COPY common /common

ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321

ARG LOCAL_SMTP_HOST
ARG LOCAL_SMTP_PASSWORD
ARG LOCAL_SMTP_PORT

RUN npm run build && rm -rf public src

CMD ["node", "./dist/server/entry.mjs"]
