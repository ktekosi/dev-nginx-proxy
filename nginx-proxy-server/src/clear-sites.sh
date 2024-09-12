#!/bin/bash
echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Clear sites"
rm -f /etc/nginx/sites-enabled/*
rm -f /etc/nginx/sites-available/*