FROM git.joeac.net/joeac/armv7/msmtp:1.8.32-alpine3.23
RUN apk --no-cache add gettext gnutls
ARG LOCAL_SMTP_PORT
EXPOSE $LOCAL_SMTP_PORT
COPY smtp/.msmtprc ./
