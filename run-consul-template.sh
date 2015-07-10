#!/bin/sh
/usr/local/bin/consul-template -config /etc/consul-template.conf | awk '{print "consul-template | " $0; fflush();}'
