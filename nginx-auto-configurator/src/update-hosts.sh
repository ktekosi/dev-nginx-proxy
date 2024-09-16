#!/bin/bash

# Check if the necessary parameters are provided
if [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: $0 <IP> <hostname> <docblock_name> [hosts_file]"
    exit 1
fi

IP=$1
HOSTNAME=$2
DOCBLOCK_NAME=$3

# Detect if running in WSL (Windows Subsystem for Linux) and set the hosts file path accordingly
if [ -z "$4" ]; then
    if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
        HOSTS_FILE="/mnt/c/Windows/System32/drivers/etc/hosts"
    else
        HOSTS_FILE="/etc/hosts"
    fi
else
    HOSTS_FILE=$4
fi

DOCBLOCK_BEGIN="# BEGIN $DOCBLOCK_NAME"
DOCBLOCK_END="# END $DOCBLOCK_NAME"

# Create a temporary file for editing
TMP_FILE=$(mktemp)

# Ensure the docblock exists in the hosts file
if ! grep -q "$DOCBLOCK_BEGIN" "$HOSTS_FILE"; then
    # If the docblock doesn't exist, create it
    echo -e "\n$DOCBLOCK_BEGIN\n$DOCBLOCK_END" >> "$HOSTS_FILE"
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Created docblock in $HOSTS_FILE"
fi

# Copy the hosts file to the temporary file
cp "$HOSTS_FILE" "$TMP_FILE"

# Check if the hostname exists within the docblock
if grep -A 100 "$DOCBLOCK_BEGIN" "$TMP_FILE" | grep -B 100 "$DOCBLOCK_END" | grep -q "$HOSTNAME"; then
    # If the hostname exists but doesn't have the correct IP, update it
    sed -i "/$DOCBLOCK_BEGIN/,/$DOCBLOCK_END/ s/^[^#]*$HOSTNAME.*/$IP $HOSTNAME/" "$TMP_FILE"
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Updated $HOSTNAME to $IP in $HOSTS_FILE"
else
    # If the hostname does not exist, add it between the docblock markers
    sed -i "/$DOCBLOCK_BEGIN/a $IP $HOSTNAME" "$TMP_FILE"
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Added $HOSTNAME with IP $IP to $HOSTS_FILE"
fi

# Move the modified temporary file back to the original hosts file
cat "$TMP_FILE" > "$HOSTS_FILE"

# Cleanup the temporary file if it still exists
if [ -f "$TMP_FILE" ]; then
    rm "$TMP_FILE"
fi
