#!/bin/sh
nginx -c /etc/nginx/nginx.conf | awk '{print "nginx | " $0; fflush();}'
