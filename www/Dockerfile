FROM nginx:1.17.4

RUN rm /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf
COPY ./${WEB_TEMPLATE} /etc/nginx/conf.d/${WEB_TEMPLATE}
COPY ./${WEB_CONF} /etc/nginx/nginx.conf
ADD ./public /etc/nginx/www

ENV DOLLAR $

# Reload nginx every 6h
CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/conf.d/${WEB_TEMPLATE} > /etc/nginx/conf.d/default.conf && while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g 'daemon off;'"]