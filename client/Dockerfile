FROM alpine:latest

RUN apk add --no-cache \
    curl \
    nmap \
    iproute2

CMD ["sh", "-c", "ip route add 172.21.0.0/24 via 172.20.0.254 && tail -f /dev/null"]