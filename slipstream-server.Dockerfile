FROM debian:bookworm-slim

ARG TARGETARCH
ARG RELEASE_TAG
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates libcap2-bin wget \
    && rm -rf /var/lib/apt/lists/* \
    && BASE_URL="https://github.com/AliRezaBeigy/slipstream-rust-deploy/releases/download/${RELEASE_TAG}" \
    && BINARY="slipstream-server-linux-${TARGETARCH}" \
    && wget -q -O /usr/local/bin/slipstream-server "${BASE_URL}/${BINARY}" \
    && chmod +x /usr/local/bin/slipstream-server \
    && useradd -r -u 1000 slipstream \
    && setcap 'cap_net_bind_service=+ep' /usr/local/bin/slipstream-server

USER slipstream

ENTRYPOINT ["/usr/local/bin/slipstream-server"]
