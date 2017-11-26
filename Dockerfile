FROM node:9.2.0-alpine

RUN mkdir /app \
      && chown node /app
USER node
WORKDIR /app

COPY . .

RUN yarn install --frozen-lockfile

CMD ["yarn", "run", "start"]
