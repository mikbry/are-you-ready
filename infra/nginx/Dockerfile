FROM nginx:1.17.4

RUN rm /etc/nginx/conf.d/default.conf
COPY ./default.template /etc/nginx/conf.d/default.template
COPY ./nginx.conf /etc/nginx/nginx.conf

ENV DOLLAR $

CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]