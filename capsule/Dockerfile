FROM alpine:3.23 AS agate
RUN apk --update --no-cache add rust cargo \
  && wget -O - https://github.com/mbrubeck/agate/archive/refs/tags/v3.3.20.tar.gz | tar -xz \
  && cargo install --path agate-3.3.20/ \
  && apk del rust cargo \
  && rm -rf agate-3.3.20 agate-target

FROM alpine:3.23 AS comitium
RUN apk --no-cache add make go scdoc
RUN wget -O - https://git.sr.ht/~nytpu/comitium/archive/v1.8.2.tar.gz | tar -xz \
  && make --directory=comitium-v1.8.2 \
  && mv comitium-v1.8.2/build/comitium /usr/local/bin/comitium \
  && apk del make go scdoc \
  && rm -rf comitium-v1.8.2

FROM alpine:3.23 AS final
RUN mkdir -p /var/app/content
WORKDIR /var/app
COPY .certificates .certificates
RUN crontab -l > crontab.tmp \
  && echo "0 */6 * * * /usr/local/bin/comitium refresh --data /var/app/comitium-data" >> crontab.tmp \
  && crontab crontab.tmp \
  && rm crontab.tmp

# gcc is a dependency for agate
# busybox-openrc provides rc-service, which runs crond
RUN apk --no-cache add gcc busybox-openrc
RUN rc-service crond start && rc-update add crond
COPY --from=agate /root/.cargo/bin/agate /usr/local/bin/agate
COPY --from=comitium /usr/local/bin/comitium /usr/local/bin/comitium

COPY comitium-data comitium-data
COPY feeds.txt feeds.txt
RUN while read feed; do \
    comitium add --data comitium-data/ "$feed"; \
  done <feeds.txt
COPY build_loglog.sh build_loglog.sh
COPY content content
RUN /bin/bash ./build_loglog.sh

CMD \
  ( sleep 5; comitium refresh --data comitium-data/ ) & \
  && agate --content content/ --addr [::]:1965 --addr 0.0.0.0:1965 --lang en-GB
