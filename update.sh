#!/bin/bash

# Set the API endpoint
API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID"
echo "API URL: $API_URL"

# Store the initial public IP address
# prevIp="$CUR_IP"
curIpv6=$(curl -s http://ip6.me/api/ | cut -d',' -f2)
prevIpv6="$CUR_IPV6"
domainName="$DOMAIN_NAME"

echo "Initial Current IPV6: $curIpv6"

# Main loop
while true; do
    # Fetch the current public IP address
    # curIp=$(curl -sS https://ipinfo.io/ip)
    curIpv6=$(curl -s http://ip6.me/api/ | cut -d',' -f2)

    echo "Current IPV6: $curIpv6"
    echo "Previous IPV6: $prevIpv6"

    # Compare the current IP with the previous one
    if [ "$prevIpv6" != "$curIpv6" ]; then
        # Update the previous IP with the current one
        prevIpv6="$curIpv6"
        # Construct JSON payload for the API request
        JSON_PAYLOAD='{
            "content": "'"$curIpv6"'",
            "name": "'"$domainName"'",
            "proxied": false,
            "type": "AAAA",
            "comment": "'"$(date)"' '"$curIpv6"'",
            "ttl": 3600
        }'

        echo "Payload: $JSON_PAYLOAD"

        # Display a message about the IP update
        echo "Updated IP address at $(date): $curIpv6"

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
