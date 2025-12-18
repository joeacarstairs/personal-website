FROM alpine:3.22

WORKDIR /
RUN apk add --no-cache git autoconf automake build-base gettext gettext-dev gnutls-dev libtool make texinfo
RUN git clone https://github.com/marlam/msmtp.git --branch msmtp-1.8.32 --single-branch --depth 1
WORKDIR /msmtp
RUN autoreconf -fi && \
  ./configure && \
  make && \
  make install
ARG PORT=2500
EXPOSE $PORT
CMD ["msmtpd", "--port=$PORT"]
