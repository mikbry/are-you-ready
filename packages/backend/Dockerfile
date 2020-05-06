FROM node:lts-stretch AS builder
ARG NODE_ENV=development
ARG  APP_BACKEND_PORT
ENV NODE_ENV=${NODE_ENV}

RUN mkdir /app
WORKDIR /app

COPY . /app

RUN yarn

# RUN yarn compile

EXPOSE ${APP_BACKEND_PORT}

CMD yarn start