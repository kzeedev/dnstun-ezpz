FROM alpine:3.19

ARG TARGETARCH

# Install required packages
RUN apk add --no-cache ca-certificates libcap wget

# Create non-root user
RUN adduser -D -u 1000 noizdns

# Download binary + set permissions + capabilities
RUN wget -q -O /usr/local/bin/noizdns-server \
       "https://github.com/anonvector/noizdns-deploy/raw/refs/heads/main/bin/dnstt-server-linux-${TARGETARCH}" \
    && chmod +x /usr/local/bin/noizdns-server \
    && setcap 'cap_net_bind_service=+ep' /usr/local/bin/noizdns-server

# Switch to non-root
USER noizdns

ENTRYPOINT ["/usr/local/bin/noizdns-server"]