FROM alpine:latest

COPY init.sh /init.sh
RUN apk install mysql-client && \
    chmod +x /init.sh

CMD ["/init.sh"]
