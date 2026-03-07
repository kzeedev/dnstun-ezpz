FROM alpine:3.19

ARG TARGETARCH
RUN apk add --no-cache ca-certificates libcap \
    && wget -q -O /usr/local/bin/dnstt-server "https://dnstt.network/dnstt-server-linux-${TARGETARCH}" \
    && chmod +x /usr/local/bin/dnstt-server \
    && adduser -D -u 1000 dnstt && setcap 'cap_net_bind_service=+ep' /usr/local/bin/dnstt-server

USER dnstt

ENTRYPOINT ["/usr/local/bin/dnstt-server"]