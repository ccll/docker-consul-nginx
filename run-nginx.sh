#!/bin/sh
nginx -c /etc/nginx/nginx.conf 2>&1 | awk '{print "nginx | " $0; fflush();}'
