FROM nginx:1.17.10

ENV DOLLAR $

RUN rm -rf /etc/nginx/nginx.conf
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY ./default.template /etc/nginx/conf.d/default.template
COPY ./default.nossl.template /etc/nginx/conf.d/default.nossl.template
COPY ./nginx.conf /etc/nginx/nginx.conf
ADD ../../public /etc/nginx/www

# Reload nginx every 6h
CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/conf.d/${WEB_TEMPLATE} > /etc/nginx/conf.d/default.conf && while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g 'daemon off;'"]
