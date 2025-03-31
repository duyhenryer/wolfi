FROM ghcr.io/duyhenryer/wolfi/base:latest

RUN apk add --no-cache nginx nginx-config && \
    mkdir -p /var/www/html /var/log/nginx && \
    chown nobody:nobody /var/www/html /var/log/nginx && \
    sed -i 's/user nginx;/user nobody;/' /etc/nginx/nginx.conf

WORKDIR /var/www/html
EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
