#!/bin/sh
echo "nginx config changed, reloading..."
nginx -s reload
echo "[done]"
