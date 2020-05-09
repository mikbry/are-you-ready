FROM node as builder
ARG NODE_ENV=development
ARG  APP_BACKEND_URL
ENV NODE_ENV=${NODE_ENV}
RUN mkdir /app
WORKDIR /app
COPY ./packages/client /app
RUN yarn
RUN yarn compile

FROM nginx:1.17.10

ENV DOLLAR $

RUN rm -rf /etc/nginx/nginx.conf
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY ./infra/nginx/default.template /etc/nginx/conf.d/default.template
COPY ./infra/nginx/default.nossl.template /etc/nginx/conf.d/default.nossl.template
COPY ./infra/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./public /etc/nginx/www
COPY --from=builder /app/dist /etc/nginx/www

CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/conf.d/${WEB_TEMPLATE} > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
