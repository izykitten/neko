#!/bin/bash
set -e

# Check if systemd is available
if [ -f "/sbin/init" ] && [ -x "/sbin/init" ]; then
    # Systemd is available, use it
    exec /sbin/init "$@"
else
    # Fall back to supervisord
    exec /usr/bin/supervisord -c /etc/neko/supervisord.conf "$@"
fi
