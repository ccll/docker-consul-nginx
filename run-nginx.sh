#!/bin/sh

CONFIG_FILE=/etc/nginx/conf.d/microservices.nginx.conf

# Wait until nginx config file is generated
while [ ! -f ${CONFIG_FILE} ]; do
    echo "Waiting for ${CONFIG_FILE}..."
    sleep 1
done

# Run nginx
nginx -c ${CONFIG_FILE}
