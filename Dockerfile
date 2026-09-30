FROM alpine:latest
RUN apk add --no-cache bash iputils util-linux procps
COPY app /app
RUN chmod +x /app/*.sh
ENTRYPOINT ["/app/diagnostic.sh"]