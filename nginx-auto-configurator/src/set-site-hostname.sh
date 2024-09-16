#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Check if the necessary parameters are provided
if [ -z "$1" ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOSTNAME=$1

# Define the docblock name
DOCBLOCK_NAME="DEV HOSTS"

# Updating hosts file with the site name set to localhost
$SCRIPT_DIR/update-hosts.sh "127.0.0.1" "$HOSTNAME" "$DOCBLOCK_NAME"