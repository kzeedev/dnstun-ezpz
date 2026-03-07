FROM debian:bookworm-slim

ARG TARGETARCH
ARG RELEASE_TAG

# Install required packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libcap2-bin \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Create application user with home in /var/lib/slipstream
RUN useradd -r -u 1000 -d /var/lib/slipstream slipstream \
    && mkdir -p /var/lib/slipstream \
    && chown -R slipstream:slipstream /var/lib/slipstream

# Download the binary
RUN BASE_URL="https://github.com/AliRezaBeigy/slipstream-rust-deploy/releases/download/${RELEASE_TAG}" \
    && BINARY="slipstream-server-linux-${TARGETARCH}" \
    && wget -q -O /usr/local/bin/slipstream-server "${BASE_URL}/${BINARY}" \
    && chmod +x /usr/local/bin/slipstream-server

# Allow binding to privileged ports
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/slipstream-server

# Declare persistent data directory
VOLUME ["/var/lib/slipstream"]

# Run as non-root user
USER slipstream

# Set working directory to home
WORKDIR /var/lib/slipstream

ENTRYPOINT ["/usr/local/bin/slipstream-server"]