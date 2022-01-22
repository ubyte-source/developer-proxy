FROM amd64/alpine:3.15

ENV STARTUP_COMMAND_RUN_NGINX="nginx"

ARG TIMEZONE="UTC"

RUN apk update && \
    apk add --no-cache nginx && \
    apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/*

COPY wrapper.sh /
COPY nginx.conf /etc/nginx/nginx.conf

RUN adduser -D -g www www && \
    chown -R www:www /var/lib/nginx /var/log/nginx && \
    chmod +x wrapper.sh && \
    cp -r /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone

RUN mkdir -p /etc/nginx/sites && \
    rm -Rf /etc/nginx/sites-enabled && \
    rm -Rf /etc/nginx/sites-available

EXPOSE 80 443

USER www

ENTRYPOINT /wrapper.sh
