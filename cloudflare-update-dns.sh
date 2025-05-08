#!/bin/bash

CLOUDFLARE_ZONE_ID=your_zone_id
CLOUDFLARE_RECORD_ID=your_record_id
CLOUDFLARE_DOMAIN_NAME=your_domain_name
CLOUDFLARE_CUR_IPV6=your_current_ipv6
CLOUDFLARE_EMAIL=your_email
CLOUDFLARE_AUTH_KEY=your_auth_key

# Set the API endpoint and other constants
API_URL="https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$CLOUDFLARE_RECORD_ID"
DOMAIN_NAME="$CLOUDFLARE_DOMAIN_NAME"
CUR_IPV6="$CLOUDFLARE_CUR_IPV6"
EMAIL="$CLOUDFLARE_EMAIL"
AUTH_KEY="$CLOUDFLARE_AUTH_KEY"

echo "API update dns: $API_URL"

# Function to get the current IPv6 address
get_current_ipv6() {
    echo "$(curl -s http://ip6.me/api/ | cut -d',' -f2)"
}

# Function to update the Cloudflare DNS record
update_dns_record() {
    local curIpv6=$1
    local payload

    # Construct the JSON payload for the API request
    payload=$(cat <<EOF
{
    "content": "$curIpv6",
    "name": "$DOMAIN_NAME",
    "proxied": false,
    "type": "AAAA",
    "comment": "$(date) $curIpv6",
    "ttl": 3600
}
EOF
)

    # Display the payload
    echo "Payload: $payload"

    # Make the API call to update the DNS record
    curl --request PATCH \
        --url "$API_URL" \
        --header 'Content-Type: application/json' \
        --header "X-Auth-Email: $EMAIL" \
        --header "X-Auth-Key: $AUTH_KEY" \
        --data "$payload"
}

# Function to check if the IP has changed
check_and_update_ip() {
    local prevIpv6=$1
    local curIpv6

    # Get the current IPv6 address
    curIpv6=$(get_current_ipv6)

    # Log current and previous IPv6
    echo "Current IPV6: $curIpv6"
    echo "Previous IPV6: $prevIpv6"

    # Compare the current and previous IPv6 address
    if [ "$prevIpv6" != "$curIpv6" ]; then
        echo "IPv6 has changed. Updating DNS record..."
        update_dns_record "$curIpv6"
        prevIpv6="$curIpv6"  # Update the previous IP to the current one
    else
        echo "IPv6 has not changed. No update needed."
    fi
}

# Main execution
check_and_update_ip "$CUR_IPV6"
