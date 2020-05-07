FROM nginx:1.17.10

ENV DOLLAR $

RUN rm -rf /etc/nginx/nginx.conf
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY ./infra/nginx/default.template /etc/nginx/conf.d/default.template
COPY ./infra/nginx/default.nossl.template /etc/nginx/conf.d/default.nossl.template
COPY ./infra/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./public /etc/nginx/www

CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/conf.d/${WEB_TEMPLATE} > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
