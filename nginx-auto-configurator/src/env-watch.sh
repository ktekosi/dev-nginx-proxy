#!/bin/bash

/app/set-env.sh

(echo "| container start |" && docker events) | \
while read event; do
    if [[ "$event" == *" container start "* ]] || [[ "$event" == *" network disconnect "* ]]; then
      /app/set-env.sh
    fi
done