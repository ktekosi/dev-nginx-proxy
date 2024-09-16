#!/bin/bash

# Check if the necessary parameters are provided
if [ -z "$1" ]; then
    echo "Usage: $0 <docblock_name> [hosts_file]"
    exit 1
fi

DOCBLOCK_NAME=$1

# Detect if running in WSL (Windows Subsystem for Linux) and set the hosts file path accordingly
if [ -z "$2" ]; then
    if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
        HOSTS_FILE="/mnt/c/Windows/System32/drivers/etc/hosts"
    else
        HOSTS_FILE="/etc/hosts"
    fi
else
    HOSTS_FILE=$2
fi

DOCBLOCK_BEGIN="# BEGIN $DOCBLOCK_NAME"
DOCBLOCK_END="# END $DOCBLOCK_NAME"

# Check if the docblock exists in the hosts file
if ! grep -q "$DOCBLOCK_BEGIN" "$HOSTS_FILE"; then
    echo "Docblock $DOCBLOCK_NAME not found in $HOSTS_FILE."
    exit 0
fi

# Create a temporary file for editing
TMP_FILE=$(mktemp)

# Copy the hosts file to the temporary file
cp "$HOSTS_FILE" "$TMP_FILE"

# Clear entries between the docblocks (keep the docblock markers)
sed -i "/$DOCBLOCK_BEGIN/,/$DOCBLOCK_END/{//!d;}" "$TMP_FILE"

# Move the modified temporary file back to the original hosts file
cat "$TMP_FILE" > "$HOSTS_FILE"

# Cleanup the temporary file if it still exists
if [ -f "$TMP_FILE" ]; then
    rm "$TMP_FILE"
fi

echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Cleared entries between $DOCBLOCK_BEGIN and $DOCBLOCK_END in $HOSTS_FILE"
