FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y iptables iproute2 && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]