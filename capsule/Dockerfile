FROM alpine:3.23 AS agate
RUN apk --update --no-cache add rust cargo \
  && wget -O - https://github.com/mbrubeck/agate/archive/refs/tags/v3.3.20.tar.gz | tar -xz \
  && cargo install --path agate-3.3.20/ \
  && rm -rf agate-3.3.20 agate-target

FROM alpine:3.23 AS comitium
RUN apk --no-cache add make go scdoc
RUN wget -O - https://git.sr.ht/~nytpu/comitium/archive/v1.8.2.tar.gz | tar -xz \
  && make --directory=comitium-v1.8.2 \
  && mv comitium-v1.8.2/build/comitium /usr/local/bin/comitium \
  && rm -rf comitium-v1.8.2

FROM alpine:3.23 AS final
RUN mkdir -p /var/app/content
WORKDIR /var/app
COPY .certificates/ ./
RUN crontab -l > crontab.tmp \
  && echo "0 */6 * * * * /usr/local/bin/comitium refresh --data /var/app/comitium-data && cp /var/app/comitium-data/feed.gmi /var/app/content/feed.gmi" >> crontab.tmp \
  && crontab crontab.tmp \
  && rm crontab.tmp

RUN apk --no-cache add gcc # Dependency for agate
COPY --from=agate /root/.cargo/bin/agate /usr/local/bin/agate
COPY --from=comitium /usr/local/bin/comitium /usr/local/bin/comitium

COPY content/ comitium-data/ feeds.txt ./
RUN while read feed; do \
    comitium add --data comitium-data/ "$feed"; \
  done <feeds.txt \
  && comitium refresh --data comitium-data/ \
  && cp comitium-data/feed.gmi content/feed.gmi \
  && cp comitium-data/subscriptions.gmi content/subscriptions.gmi

CMD agate --content content/ --addr [::]:1965 --addr 0.0.0.0:1965 --lang en-GB

