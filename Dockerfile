#
# Builder
#
FROM abiosoft/caddy:builder as builder

ARG version="v1.0.4"
ARG plugins="cloudflare,dnspod,cache,cors,expires,filter,forwardproxy,grpc,ipfilter,jwt,login,mailout,minify,nobots,permission,proxyprotocol,ratelimit,realip,webdav"
ARG enable_telemetry="true"

RUN wget https://raw.githubusercontent.com/snadn/caddy-docker/master/builder/builder.sh -O /usr/bin/builder.sh

RUN VERSION=${version} PLUGINS=${plugins} ENABLE_TELEMETRY=${enable_telemetry} /bin/sh /usr/bin/builder.sh

# validate install
RUN /install/caddy -version
RUN /install/caddy -plugins

#
# Final stage
#
FROM alpine:3.10

# Let's Encrypt Agreement
ENV ACME_AGREE="false"

# Telemetry Stats
ENV ENABLE_TELEMETRY="$enable_telemetry"

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

RUN apk add --no-cache \
    ca-certificates \
    git \
    mailcap \
    openssh-client \
    tzdata

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /srv/index.html

CMD ["caddy", "--conf", "/etc/caddy/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE", "-email", "$MAIL"]
