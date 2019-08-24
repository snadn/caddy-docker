FROM alpine
LABEL maintainer "snadn@snadn.cn"

ARG plugins="dns,http.cache,http.cors,http.expires,http.filter,http.forwardproxy,http.grpc,http.ipfilter,http.jwt,
http.login,http.mailout,http.minify,http.nobots,http.permission,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip,http.torproxy,http.webda
v,net"

RUN apk add --no-cache bash curl

RUN curl https://getcaddy.com | bash -s personal $plugins

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015

CMD ["caddy", "-type", "net", "--conf", "/etc/Caddyfile", "--log", "stdout", "--agree"]
