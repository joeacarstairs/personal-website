FROM node:lts AS runtime
WORKDIR /app

################### TODO ###################
# - Refactor this Dockerfile into a compose.yml
# - Add another service on the same network running an SMTP server such
#   as msmtpd or Postfix
# - Configure the SMTP server to send emails from me@joeac.net via Zoho
# - Configure the website to use the SMTP server to send emails
# - Test
# - Push
# - Test on RPi
# - Consider: now you're running an SMTP server anyway, can you send it
#   from your very own no-reply email address?
############################################

COPY package.json .
COPY website/db website/astro.config.mjs website/
ARG DB_URL=file:/app/db.sqlite
ENV ASTRO_DB_REMOTE_URL=$DB_URL
RUN mkdir -p "$(dirname "$(echo "$ASTRO_DB_REMOTE_URL" | cut -d':' -f 2)")"
RUN npm run astro db push

COPY ./website ./website
RUN npm install
RUN npm run build

ARG MAX_DAILY_EMAILS="100"
ARG SENDMAIL_BIN="/usr/sbin/sendmail"

ENV HOST=0.0.0.0
ENV PORT=4321

EXPOSE 4321
CMD [ \
  "MAX_DAILY_EMAILS=$MAX_DAILY_EMAILS", \
  "SENDMAIL_BIN=$SENDMAIL_BIN", \
  "node", \
  "./website/dist/server/entry.mjs"]
