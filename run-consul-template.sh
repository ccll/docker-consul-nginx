#!/bin/sh
/usr/local/bin/consul-template -config /etc/consul-template.conf 2>&1 | awk '{print "consul-template | " $0; fflush();}'
