FROM alpine:3.23

RUN mkdir -p /var/app/content
WORKDIR /var/app
COPY .certificates/ /var/app/.certificates/

RUN apk --update --no-cache add rust cargo
RUN wget -O - https://github.com/mbrubeck/agate/archive/refs/tags/v3.3.20.tar.gz | tar -xz
RUN cargo build --release --target-dir agate-target --manifest-path agate-3.3.20/Cargo.toml
RUN mv agate-target/release/agate /usr/local/bin/agate
RUN rm -rf agate-3.3.20 agate-target

COPY content/ content

CMD set -eux && agate \
  --content content/ \
  --addr [::]:1965 \
  --addr 0.0.0.0:1965 \
  --lang en-GB
