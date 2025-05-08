#!/bin/bash

# Config
CLOUDFLARE_ZONE_ID="your_zone_id"
CLOUDFLARE_RECORD_ID="your_record_id"
CLOUDFLARE_DOMAIN_NAME="your_domain_name"
CLOUDFLARE_EMAIL="your_email"
CLOUDFLARE_AUTH_KEY="your_auth_key"

API_URL="https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$CLOUDFLARE_RECORD_ID"
LAST_IPV6_FILE="last_ipv6.txt"

echo "Cloudflare DNS update API: $API_URL"

# Function to get the current public IPv6 address
get_current_ipv6() {
    curl -s http://ip6.me/api/ | cut -d',' -f2
}

# Function to update the Cloudflare DNS record
update_dns_record() {
    local curIpv6="$1"

    local payload
    payload=$(
        cat <<EOF
{
    "content": "$curIpv6",
    "name": "$CLOUDFLARE_DOMAIN_NAME",
    "proxied": false,
    "type": "AAAA",
    "comment": "$(date) $curIpv6",
    "ttl": 3600
}
EOF
    )

    echo "Sending update to Cloudflare..."

    response=$(curl --silent --show-error --fail --request PATCH \
        --url "$API_URL" \
        --header "Content-Type: application/json" \
        --header "X-Auth-Email: $CLOUDFLARE_EMAIL" \
        --header "X-Auth-Key: $CLOUDFLARE_AUTH_KEY" \
        --data "$payload")

    echo "Response from Cloudflare: $response"
}

# Function to check if the IPv6 has changed and update it
check_and_update_ip() {
    local prevIpv6=""
    [[ -f "$LAST_IPV6_FILE" ]] && prevIpv6=$(<"$LAST_IPV6_FILE")

    local curIpv6
    curIpv6=$(get_current_ipv6)

    echo "Previous IPv6: $prevIpv6"
    echo "Current IPv6:  $curIpv6"

    if [[ -n "$curIpv6" && "$prevIpv6" != "$curIpv6" ]]; then
        echo "IPv6 has changed. Updating Cloudflare DNS record..."
        update_dns_record "$curIpv6"
        echo "$curIpv6" >"$LAST_IPV6_FILE"
    else
        echo "IPv6 has not changed. No update needed."
    fi
}

# Main
check_and_update_ip
