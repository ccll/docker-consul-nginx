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
ADD https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz /tmp/consul-template.tar.gz
RUN cd /tmp && tar zxf consul-template.tar.gz && mv consul-template_0.10.0_linux_amd64/consul-template /usr/local/bin/ && rm -rf /tmp/*

# Install config files
ADD consul-template.conf /etc/consul-template.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD microservices.nginx.conf.ctmpl /etc/nginx/conf.d/microservices.nginx.conf.ctmpl
ADD reload-nginx.sh /usr/local/bin/reload-nginx.sh
ADD nginx.ini /etc/supervisor.d/nginx.ini
ADD consul-template.ini /etc/supervisor.d/consul-template.ini

# chmod
RUN chmod u+rx,go+r /usr/local/bin/consul-template
RUN chmod u+rx,go+r /usr/local/bin/reload-nginx.sh

# Command
CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisord.conf"]
