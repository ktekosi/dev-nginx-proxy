#!/bin/bash
echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Nginx reload"
nginx -s reload