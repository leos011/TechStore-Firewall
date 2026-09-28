#!/bin/sh

set -e

echo "Configurando firewall..."

# Limpa regras anteriores
iptables -F
iptables -X

# Políticas padrão
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permite comunicação interna do próprio firewall
iptables -A INPUT -i lo -j ACCEPT

# Permite tráfego de retorno de conexões já autorizadas
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Permite HTTP da LAN para o servidor Web da DMZ
iptables -A FORWARD \
    -i eth1 \
    -o eth0 \
    -s 172.20.0.2 \
    -d 172.21.0.10 \
    -p tcp \
    --dport 80 \
    -m conntrack \
    --ctstate NEW \
    -j ACCEPT

echo "Regras do firewall carregadas."

# Mantém o container em execução
exec tail -f /dev/null