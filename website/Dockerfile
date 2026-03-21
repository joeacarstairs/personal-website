FROM node:lts-alpine3.22 AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY astro.config.mjs ./
COPY db ./db/
ARG DB_URL=file:/app/db.sqlite
ENV ASTRO_DB_REMOTE_URL=$DB_URL
RUN mkdir -p "$(dirname "$(echo "$ASTRO_DB_REMOTE_URL" | cut -d':' -f 2)")"
RUN npm run astro db push

COPY . .
RUN npm run build && rm -rf public src

FROM node:lts-alpine3.22 AS final
WORKDIR /app

ENV HOST=0.0.0.0
ENV PORT=4321
EXPOSE 4321
ENV MAX_DAILY_EMAILS=100

COPY --from=build /app/node_modules node_modules
COPY --from=build /app/db.sqlite db.sqlite
COPY --from=build /app/dist/ .

CMD ["node", "./server/entry.mjs"]
