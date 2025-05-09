FROM alpine:latest

# Install required tools: curl, bash, tzdata, iproute2
RUN apk update && \
    apk add --no-cache bash curl tzdata iproute2

WORKDIR /app/

# Set environment variables
ENV TZ=Asia/Bangkok\
    ZONE_ID="ZONE_ID" \
    RECORD_ID="RECORD_ID" \
    EMAIL="EMAIL" \
    AUTH_KEY="AUTH_KEY" \
    CUR_IPV6="2606:4700:4700::1111" \
    CUR_IPV4="1.1.1.1" \
    DOMAIN_NAME="cloudflare.com"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./update.sh /app/

RUN chmod +x /app/update.sh

CMD ["/bin/sh", "-c", "/app/update.sh"]