FROM ghcr.io/duyhenryer/wolfi/base:latest

ARG PHP_VERSION=8.2

RUN apk add --no-cache php-${PHP_VERSION} minicli minicli-bin && \
    mkdir -p /app && \
    chown nobody:nobody /app

WORKDIR /app

USER nobody

COPY --chown=nobody:nobody app.php .

CMD ["minicli", "welcome"]