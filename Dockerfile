FROM alpine
LABEL maintainer "snadn@snadn.cn"

ARG plugins="dns,http.cache,http.cors,http.expires,http.filter,http.forwardproxy,http.grpc,http.ipfilter,http.jwt,http.login,http.mailout,http.minify,http.nobots,http.permission,http.prometheus,http.proxyprotocol,http.ratelimit,http.realip,http.torproxy,http.webdav,net"

RUN apk add --no-cache bash curl

RUN curl https://getcaddy.com | bash -s personal $plugins

# validate install
RUN caddy -version
RUN caddy -plugins

CMD ["caddy", "--conf", "/etc/caddy/Caddyfile", "--log", "stdout", "--agree", "-email", "$MAIL"]
