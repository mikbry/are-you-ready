FROM node:lts-stretch AS builder
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

RUN mkdir /app
WORKDIR /app

COPY . /app

RUN yarn

# RUN yarn compile

CMD yarn start