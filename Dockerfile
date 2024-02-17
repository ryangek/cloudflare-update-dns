FROM alpine:latest

RUN apk update && \
    apk add --no-cache bash curl tzdata

WORKDIR app/

# Set environment variables
ENV TZ=Asia/Bangkok\
    ZONE_ID="ZONE_ID" \
    RECORD_ID="RECORD_ID" \
    EMAIL="EMAIL" \
    AUTH_KEY="AUTH_KEY" \
    CUR_IP="1.1.1.1"

COPY ./update.sh /app/

RUN chmod +x /app/update.sh

CMD ["/bin/sh", "-c", "/app/update.sh"]