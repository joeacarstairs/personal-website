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
COPY capsule/.certificates .certificates
RUN crontab -l > crontab.tmp \
  && echo "0 */6 * * * /usr/local/bin/comitium refresh --data /var/app/comitium-data" >> crontab.tmp \
  && crontab crontab.tmp \
  && rm crontab.tmp

# bash is needed to run the build scripts
# busybox-openrc provides rc-service, which runs crond
# gcc is a dependency for agate
# make is needed to run the Makefile
RUN apk --no-cache add bash busybox-openrc gcc make
RUN rc-update add crond
COPY --from=agate /root/.cargo/bin/agate /usr/local/bin/agate
COPY --from=comitium /usr/local/bin/comitium /usr/local/bin/comitium

COPY capsule/comitium-data comitium-data
COPY capsule/Makefile Makefile
RUN make add_feeds
COPY capsule .
COPY common /var/common
RUN make

CMD ./run.sh
