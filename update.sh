#!/bin/bash

# Set the API endpoint
API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID"

# Store the initial public IP address
prevIp="$CUR_IP"

# Main loop
while true; do
    # Fetch the current public IP address
    curIp=$(curl -sS https://ipinfo.io/ip)

    if [ "$DEBUG" == "true" ]; then
        echo "Debug mode enabled. Printing IP Addresses:"
        echo "Current IP: $curIp"
        echo "Previous IP: $prevIp"
    fi

    # Compare the current IP with the previous one
    if [ "$prevIp" != "$curIp" ]; then
        # Update the previous IP with the current one
        prevIp="$curIp"
        # Construct JSON payload for the API request
        JSON_PAYLOAD='{
            "content": "'"$curIp"'",
            "name": "pinesproject.online",
            "proxied": true,
            "type": "A",
            "comment": "'"$(date)"' '"$curIp"'",
            "ttl": 3600
        }'

        if [ "$DEBUG" == "true" ]; then
            echo "Debug mode enabled. Printing JSON payload:"
            echo "$JSON_PAYLOAD"
        fi

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
