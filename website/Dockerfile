FROM node:lts-alpine3.22
WORKDIR /app

RUN apk add --no-cache git
COPY package.json package-lock.json ./
RUN npm install && apk del git

COPY astro.config.mjs ./
COPY db ./db/
ARG DB_URL=file:/app/db.sqlite
ENV ASTRO_DB_REMOTE_URL=$DB_URL
RUN mkdir -p "$(dirname "$(echo "$ASTRO_DB_REMOTE_URL" | cut -d':' -f 2)")"
RUN npm run astro db push

COPY . .

ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321

ARG LOCAL_SMTP_HOST
ARG LOCAL_SMTP_PASSWORD
ARG LOCAL_SMTP_PORT
#ENV LOCAL_SMTP_ENVELOPE_FROM=$LOCAL_SMTP_ENVELOPE_FROM \
#ENV  LOCAL_SMTP_USER=$LOCAL_SMTP_USER \
  #LOCAL_SMTP_HOST=$LOCAL_SMTP_HOST \
  #LOCAL_SMTP_PASSWORD=$LOCAL_SMTP_PASSWORD \
#  LOCAL_SMTP_PORT=$LOCAL_SMTP_PORT \
#  REMOTE_SMTP_HOST=$REMOTE_SMTP_HOST \
#  REMOTE_SMTP_PORT=$REMOTE_SMTP_PORT \
#  REMOTE_SMTP_USER=$REMOTE_SMTP_USER \
#  MAX_DAILY_EMAILS=$MAX_DAILY_EMAILS

RUN npm run build && rm -rf public src

CMD ["node", "./dist/server/entry.mjs"]
