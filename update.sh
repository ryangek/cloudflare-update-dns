#!/bin/bash

# Set the API endpoint
API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID"

prevIp=$CUR_IP
while true; do
    curIp=$(curl -sS https://ipinfo.io/ip)
    if [ "$prevIp" != "$curIp" ]; then
        # Make the API call
        prevIp="$curIp"
        JSON_PAYLOAD='{
        "content": "'"$curIp"'",
        "name": "pinesproject.online",
        "proxied": true,
        "type": "A",
        "comment": "'"$(date)"' '"$curIp"'",
        "ttl": 3600
        }'
        echo "updated ip address... $(date) $curIp"
        curl --request PATCH \
        --url "$API_URL" \
        --header 'Content-Type: application/json' \
        --header "X-Auth-Email: $EMAIL" \
        --header "X-Auth-Key: $AUTH_KEY" \
        --data "$JSON_PAYLOAD"
    fi
    sleep 300  # Sleep for 5 minutes (300 seconds)
done