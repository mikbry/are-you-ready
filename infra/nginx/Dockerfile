FROM nginx:1.17.4

RUN rm /etc/nginx/conf.d/default.conf
COPY ./default.template /etc/nginx/conf.d/default.template
COPY ./nginx.conf /etc/nginx/nginx.conf

ENV DOLLAR $

# Reload nginx every 6h
CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g 'daemon off;'"]