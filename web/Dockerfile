FROM nginx:alpine

RUN apk add --no-cache iproute2

CMD ["sh", "-c", "ip route add 172.20.0.0/24 via 172.21.0.254 && nginx -g 'daemon off;'"]