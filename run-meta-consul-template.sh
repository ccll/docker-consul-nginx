#!/bin/sh
/usr/local/bin/consul-template -config /etc/meta-consul-template.conf 2>&1 | awk '{print "meta-consul-template | " $0; fflush();}'
