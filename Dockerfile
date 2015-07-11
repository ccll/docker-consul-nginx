FROM man:5000/alpine:3.2

RUN apk update && apk add supervisor=3.1.3-r1 nginx=1.8.0-r1 && rm -rf /var/cache/apk/*

# forward nginx logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Install consul-template
ADD deps/consul-template_0.10.0_linux_amd64.tar.gz /tmp
RUN mv /tmp/consul-template_0.10.0_linux_amd64/consul-template /usr/local/bin/ && rm -rf /tmp/*

ADD consul-template.conf.envtmpl /etc/consul-template.conf.envtmpl
ADD meta-consul-template.conf.envtmpl /etc/meta-consul-template.conf.envtmpl
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
ADD start /usr/local/bin/start

RUN chmod u+rx,go+r /usr/local/bin/consul-template
RUN chmod u+rx,go+r /usr/local/bin/run-consul-template.sh
RUN chmod u+rx,go+r /usr/local/bin/run-meta-consul-template.sh
RUN chmod u+rx,go+r /usr/local/bin/run-nginx.sh
RUN chmod u+rx,go+r /usr/local/bin/reload-nginx.sh
RUN chmod u+rx,go+r /usr/local/bin/start

CMD ["/usr/local/bin/start"]
