FROM alpine:3.2

RUN apk update

# Install supervisor
RUN apk add supervisor=3.1.3-r1

# Install nginx
RUN apk add nginx=1.8.0-r1

# Purge APK cache
RUN rm -rf /var/cache/apk/*

# forward nginx logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Install ccll/consul-template (a hacked version with support for customizable template delimeters)
ADD https://github.com/ccll/consul-template/releases/download/v0.7.0-1/consul-template /usr/local/bin/consul-template

# Install config files
ADD consul-template.conf /etc/consul-template.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD microservices.nginx.conf.ctmpl /etc/nginx/conf.d/microservices.nginx.conf.ctmpl
ADD reload-nginx.sh /usr/local/bin/reload-nginx.sh
ADD run-nginx.sh /usr/local/bin/run-nginx.sh
ADD nginx.ini /etc/supervisor.d/nginx.ini
ADD consul-template.ini /etc/supervisor.d/consul-template.ini

# chmod
RUN chmod u+rx,go+r /usr/local/bin/consul-template
RUN chmod u+rx,go+r /usr/local/bin/run-nginx.sh
RUN chmod u+rx,go+r /usr/local/bin/reload-nginx.sh

# Command
CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisord.conf"]
