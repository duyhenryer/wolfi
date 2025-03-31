FROM ghcr.io/duyhenryer/wolfi/base:latest

RUN apk add --no-cache nginx nginx-config && \
    adduser -u 82 www-data -D && \
    mkdir -p /var/www/html /var/log/nginx && \
    chown www-data:www-data /var/www/html /var/log/nginx

WORKDIR /var/www/html

EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
