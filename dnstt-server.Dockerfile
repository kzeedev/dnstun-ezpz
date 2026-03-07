FROM alpine:3.19

ARG TARGETARCH

# Install required packages
RUN apk add --no-cache ca-certificates libcap wget

# Create non-root user
RUN adduser -D -u 1000 dnstt

# Download binary + set permissions + capabilities
RUN wget -q -O /usr/local/bin/dnstt-server \
       "https://dnstt.network/dnstt-server-linux-${TARGETARCH}" \
    && chmod +x /usr/local/bin/dnstt-server \
    && setcap 'cap_net_bind_service=+ep' /usr/local/bin/dnstt-server

# Switch to non-root
USER dnstt

ENTRYPOINT ["/usr/local/bin/dnstt-server"]