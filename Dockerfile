FROM alpine:latest

COPY init.sh /init.sh
RUN apk add mysql-client mariadb-connector-c && \
    chmod +x /init.sh

CMD ["/init.sh"]
