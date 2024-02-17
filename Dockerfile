FROM alpine:latest

RUN apk update && \
    apk add --no-cache curl

# Set environment variables
ENV ZONE_ID="ZONE_ID" \      
    RECORD_ID="RECORD_ID" \    
    EMAIL="EMAIL" \
    AUTH_KEY="AUTH_KEY" \
    CUR_IP="1.1.1.1"

COPY . .

RUN chmod +x ./update.sh

CMD ["./update.sh"]