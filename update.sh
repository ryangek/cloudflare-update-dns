#!/bin/bash

# Set the API endpoint
API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID"
echo "API URL: $API_URL"

# Store the initial public IP address
# prevIp="$CUR_IP"
curIp=$(curl -sS https://ipinfo.io/ip)
prevIp="$CUR_IP"
domainName="$DOMAIN_NAME"

echo "Initial Current IP: $curIp"

# Main loop
while true; do
    # Fetch the current public IP address
    curIp=$(curl -sS https://ipinfo.io/ip)

    echo "Current IP: $curIp"
    echo "Previous IP: $prevIp"

    # Compare the current IP with the previous one
    if [ "$prevIp" != "$curIp" ]; then
        # Update the previous IP with the current one
        prevIp="$curIp"
        # Construct JSON payload for the API request
        JSON_PAYLOAD='{
            "content": "'"$curIp"'",
            "name": "'"$domainName"'",
            "proxied": false,
            "type": "A",
            "comment": "'"$(date)"' '"$curIp"'",
            "ttl": 3600
        }'

        echo "Payload: $JSON_PAYLOAD"

        # Display a message about the IP update
        echo "Updated IP address at $(date): $curIp"

        # Make the API call to update the DNS record
        curl --request PATCH \
            --url "$API_URL" \
            --header 'Content-Type: application/json' \
            --header "X-Auth-Email: $EMAIL" \
            --header "X-Auth-Key: $AUTH_KEY" \
            --data "$JSON_PAYLOAD"
    fi

    # Sleep for 5 minutes before checking again
    sleep 300
done
