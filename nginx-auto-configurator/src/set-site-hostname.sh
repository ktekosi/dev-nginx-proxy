#!/bin/bash

# Check if the necessary parameters are provided
if [ -z "$1" ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

HOSTNAME=$1

# Detect if running in WSL (Windows Subsystem for Linux) and set the hosts file path accordingly
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    HOSTS_FILE="/mnt/c/Windows/System32/drivers/etc/hosts"
else
    HOSTS_FILE="/etc/hosts"
fi

# Define the docblock markers
DOCBLOCK_BEGIN="# BEGIN DEV HOSTS"
DOCBLOCK_END="# END DEV HOSTS"

# Create the docblock if it doesn't exist
if ! grep -q "$DOCBLOCK_BEGIN" "$HOSTS_FILE"; then
    echo -e "\n$DOCBLOCK_BEGIN\n$DOCBLOCK_END" >> "$HOSTS_FILE"
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Created docblock in $HOSTS_FILE"
fi

# Check if the hostname already exists between the docblocks
if sed -n "/$DOCBLOCK_BEGIN/,/$DOCBLOCK_END/p" "$HOSTS_FILE" | grep -q "$HOSTNAME"; then
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] $HOSTNAME already exists in the docblock"
else
    # Create a temporary file in /tmp to hold the updated contents
    TEMP_FILE=$(mktemp /tmp/hosts.XXXXXX)

    # Copy the contents of the hosts file, adding the hostname in the correct position
    awk -v hostname="127.0.0.1 $HOSTNAME" -v begin="$DOCBLOCK_BEGIN" -v end="$DOCBLOCK_END" '
    { print }
    $0 == begin { print hostname }
    ' "$HOSTS_FILE" > "$TEMP_FILE"

    # Copy the temporary file back to the original hosts file
    cat "$TEMP_FILE" > "$HOSTS_FILE"
    rm "$TEMP_FILE"  # Clean up the temporary file
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Added $HOSTNAME to $HOSTS_FILE between $DOCBLOCK_BEGIN and $DOCBLOCK_END as localhost"
fi
