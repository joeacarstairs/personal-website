FROM git.joeac.net/joeac/armv7/agate:3.3.20-alpine3.23 AS agate
FROM git.joeac.net/joeac/armv7/comitium:1.8.2-alpine3.23 AS comitium
FROM git.joeac.net/joeac/armv7/crond:1.37.0-r30-alpine3.23 AS final
RUN apk --no-cache add gcc # dependency for agate
COPY --from=agate /root/.cargo/bin/agate /usr/local/bin/agate
COPY --from=comitium /usr/local/bin/comitium /usr/local/bin/comitium

RUN mkdir -p /var/app/content
WORKDIR /var/app
RUN crontab -l > crontab.tmp \
  && echo "0 */6 * * * /usr/local/bin/comitium refresh --data /var/app/comitium-data" >> crontab.tmp \
  && crontab crontab.tmp \
  && rm crontab.tmp

COPY gemini/run.sh /var/app/
COPY gemini/content /var/app/content
COPY common /var/common

CMD ./run.sh
