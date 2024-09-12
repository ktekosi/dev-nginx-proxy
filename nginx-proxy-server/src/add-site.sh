#!/bin/bash

# Check if the necessary parameters are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <hostname> <ip> [port]"
    exit 1
fi

HOSTNAME=$1
IP=$2
PORT=$3

# If no port is provided, use port 80 as default
if [ -z "$PORT" ]; then
    PORT=80
fi

echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Setting site for $HOSTNAME:80 to $IP:$PORT"

cat << EOF >> /etc/nginx/sites-available/$HOSTNAME.conf

server {
    listen       80;
    server_name  $HOSTNAME;

    location / {
        proxy_pass http://$IP:$PORT;
        proxy_set_header Host \$http_host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_redirect off;
        proxy_http_version 1.1;
    }
}
EOF

ln -s -f /etc/nginx/sites-available/$HOSTNAME.conf /etc/nginx/sites-enabled/$HOSTNAME.conf
