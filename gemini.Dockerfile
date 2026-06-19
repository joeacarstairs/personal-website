FROM git.joeac.net/joeac/armv7/agate:3.3.20-alpine3.23 AS agate

FROM git.joeac.net/joeac/armv7/comitium:1.8.2-alpine3.23 AS comitium

FROM alpine:3.23 AS final

# bash is needed to run the build scripts
# busybox-openrc provides rc-service, which runs crond
# gcc is a dependency for agate
# make is needed to run the Makefile
RUN apk --no-cache add bash busybox-openrc gcc make
RUN rc-update add crond
COPY --from=agate /root/.cargo/bin/agate /usr/local/bin/agate
COPY --from=comitium /usr/local/bin/comitium /usr/local/bin/comitium

RUN mkdir -p /var/app/content
WORKDIR /var/app
COPY gemini/.certificates .certificates
RUN crontab -l > crontab.tmp \
  && echo "0 */6 * * * /usr/local/bin/comitium refresh --data /var/app/comitium-data" >> crontab.tmp \
  && crontab crontab.tmp \
  && rm crontab.tmp

COPY gemini .
COPY common /var/common
RUN make

CMD ./run.sh
