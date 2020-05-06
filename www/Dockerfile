FROM nginx:1.17.4
ARG WEB_CONF
ARG WEB_TEMPLATE

# ENV DOLLAR $

RUN echo "${WEB_CONF} ${WEB_TEMPLATE}"
RUN rm -rf /etc/nginx/nginx.conf
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY ./${WEB_TEMPLATE} /etc/nginx/conf.d/${WEB_TEMPLATE}
COPY ./${WEB_CONF} /etc/nginx/nginx.conf
ADD ./public /etc/nginx/www

# Reload nginx every 6h
# CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/conf.d/${WEB_TEMPLATE} > /etc/nginx/conf.d/default.conf && while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g 'daemon off;'"]
CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/conf.d/${WEB_TEMPLATE} > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
