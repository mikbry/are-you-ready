FROM node:lts-stretch AS builder

RUN mkdir /app
WORKDIR /app

COPY . /app

RUN yarn

# RUN yarn compile

CMD yarn start