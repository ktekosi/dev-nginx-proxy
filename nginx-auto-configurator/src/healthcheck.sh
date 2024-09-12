#!/bin/bash

# Check if the docker events process is running
if pgrep -f "docker events" > /dev/null; then
  exit 0  # The process is running, report healthy
else
  exit 1  # The process is not running, report unhealthy
fi
