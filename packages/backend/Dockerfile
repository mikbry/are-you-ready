FROM node:lts-stretch AS builder
ARG NODE_ENV=development
ARG  APP_BACKEND_PORT
ENV NODE_ENV=${NODE_ENV}

RUN mkdir /app
WORKDIR /app

COPY ./packages/backend /app
COPY ./bin/backend-entrypoint.sh /app/bin/backend-entrypoint.sh

RUN yarn

# RUN yarn compile

EXPOSE ${APP_BACKEND_PORT}

ENTRYPOINT ["./bin/backend-entrypoint.sh"]
CMD yarn start