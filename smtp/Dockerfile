FROM alpine:3.22

WORKDIR /
RUN mkdir -p /var/msmtp
RUN apk --update --no-cache add git autoconf automake build-base gettext gettext-dev gnutls-dev libtool make texinfo && \
  git clone https://github.com/marlam/msmtp.git --branch msmtp-1.8.32 --single-branch --depth 1
WORKDIR /msmtp
RUN autoreconf -fi && \
  ./configure && \
  make && \
  make install

ARG LOCAL_SMTP_PORT
EXPOSE $LOCAL_SMTP_PORT

COPY .msmtprc ./

CMD msmtpd \
  --auth=$LOCAL_SMTP_USER,'echo $LOCAL_SMTP_PASSWORD' \
  --command='msmtp -C .msmtprc -f %F --' \
  --interface=0.0.0.0 \
  --log=/var/msmtp/msmtpd.log \
  --port=$LOCAL_SMTP_PORT
