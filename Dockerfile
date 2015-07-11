FROM alpine:3.2

RUN apk update

# Install curl
RUN apk add curl

# Install supervisor
RUN apk add supervisor=3.1.3-r1

# Install nginx
RUN apk add nginx=1.8.0-r1

# Purge APK cache
RUN rm -rf /var/cache/apk/*

# forward nginx logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Install consul-template
ADD consul-template_0.10.0_linux_amd64.tar.gz /tmp
RUN mv /tmp/consul-template_0.10.0_linux_amd64/consul-template /usr/local/bin/ && rm -rf /tmp/*

ADD consul-template.conf /etc/consul-template.conf
ADD meta-consul-template.conf /etc/meta-consul-template.conf
ADD nginx.conf.ctmpl /etc/nginx/nginx.conf.ctmpl
ADD nginx.conf.pass1 /etc/nginx/nginx.conf.pass1
ADD nginx.conf.default /etc/nginx/nginx.conf.default
ADD supervisor-nginx.ini /etc/supervisor.d/nginx.ini
ADD supervisor-consul-template.ini /etc/supervisor.d/consul-template.ini
ADD supervisor-meta-consul-template.ini /etc/supervisor.d/consul-meta-template.ini

ADD run-consul-template.sh /usr/local/bin/run-consul-template.sh
ADD run-meta-consul-template.sh /usr/local/bin/run-meta-consul-template.sh
ADD run-nginx.sh /usr/local/bin/run-nginx.sh
ADD reload-nginx.sh /usr/local/bin/reload-nginx.sh

RUN chmod u+rx,go+r /usr/local/bin/consul-template
RUN chmod u+rx,go+r /usr/local/bin/run-consul-template.sh
RUN chmod u+rx,go+r /usr/local/bin/run-meta-consul-template.sh
RUN chmod u+rx,go+r /usr/local/bin/run-nginx.sh
RUN chmod u+rx,go+r /usr/local/bin/reload-nginx.sh

# Command
CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisord.conf"]
