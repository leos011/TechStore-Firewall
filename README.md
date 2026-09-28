# TechStore Firewall

Projeto prático da disciplina de Segurança da Informação, desenvolvido com Docker, Docker Compose e iptables.

O projeto simula uma infraestrutura de rede para uma empresa fictícia de comércio eletrônico, a TechStore, utilizando segmentação de redes e um firewall Linux baseado em Netfilter/iptables.

## Objetivo

Implementar uma arquitetura de rede segmentada, na qual o tráfego entre a rede interna (LAN) e a zona desmilitarizada (DMZ) seja controlado por um firewall.

A política adotada é de **negação por padrão (Default Deny)**, permitindo somente os tráfegos explicitamente autorizados.

## Arquitetura

```text
                 FIREWALL
              Linux / iptables
                    │
          ┌─────────┴─────────┐
          │                   │
         LAN                 DMZ
    172.20.0.0/24        172.21.0.0/24
          │                   │
       CLIENTE               WEB
    172.20.0.2            172.21.0.10
                            Nginx

| Componente     | IP           | Função                             |
| -------------- | ------------ | ---------------------------------- |
| Cliente        | 172.20.0.2   | Simula uma estação da rede interna |
| Firewall - LAN | 172.20.0.254 | Gateway da rede interna            |
| Firewall - DMZ | 172.21.0.254 | Gateway da DMZ                     |
| Web            | 172.21.0.10  | Servidor Web Nginx                 |

## Redes

LAN
172.20.0.0/24

Rede destinada aos clientes internos da empresa.

DMZ
172.21.0.0/24

Rede destinada ao servidor Web, isolada da rede interna e controlada pelo firewall.

## Regras do Firewall

O firewall utiliza o princípio de Default Deny.

A política da cadeia FORWARD é:

DROP

Somente os tráfegos autorizados são liberados.

Origem	Destino	Protocolo/Porta	Estado	Ação
172.20.0.2	172.21.0.10	TCP/80	NEW	ACCEPT
Qualquer	Qualquer	Qualquer	ESTABLISHED/RELATED	ACCEPT
Demais tráfegos	Qualquer	Qualquer	Qualquer	DROP

## Estrutura do Projeto

Techstore Firewall/
│
├── client/
│   └── Dockerfile
│
├── firewall/
│   ├── Dockerfile
│   └── entrypoint.sh
│
├── web/
│   └── Dockerfile
│
├── docker-compose.yml
└── README.md

## Tecnologias Utilizadas

- Docker
- Docker Compose
- Linux
- Debian
- Alpine Linux
- Nginx
- iptables
- Netfilter
- Nmap
- curl

## Execução

Na pasta raiz do projeto, execute:

docker compose up -d

Para verificar os containers:

docker ps

Os seguintes containers devem estar em execução:

techstore-client
techstore-firewall
techstore-web
Verificação das Regras

Para visualizar as regras configuradas no firewall:

docker exec techstore-firewall iptables -L FORWARD -n -v --line-numbers
Testes
1. Teste de tráfego permitido

O cliente deve conseguir acessar o servidor Web pela porta 80:

docker exec techstore-client curl -s -o /dev/null -w "%{http_code}\n" http://172.21.0.10

Resultado esperado:

200

Esse resultado demonstra que o tráfego HTTP autorizado está sendo encaminhado pelo firewall.

2. Teste de tráfego bloqueado

Para verificar o bloqueio de uma porta não autorizada:

docker exec techstore-client nmap -Pn -p 22 172.21.0.10

Resultado esperado:

22/tcp filtered ssh

Esse resultado demonstra que o acesso à porta 22 está sendo bloqueado pelo firewall.

Configuração Automática do Firewall

As regras do firewall são carregadas automaticamente durante a inicialização do container por meio do arquivo:

firewall/entrypoint.sh

A imagem do firewall é construída utilizando:

firewall/Dockerfile

O entrypoint.sh configura:

Política padrão DROP para INPUT;
Política padrão DROP para FORWARD;
Política ACCEPT para OUTPUT;
Permissão para conexões ESTABLISHED,RELATED;
Permissão de tráfego HTTP da LAN para o servidor Web da DMZ.

O encaminhamento IPv4 é habilitado no docker-compose.yml por meio de:

sysctls:
  net.ipv4.ip_forward: "1"
Segurança

A arquitetura utiliza segmentação de rede para controlar o tráfego entre a LAN e a DMZ.

O firewall funciona como ponto de controle entre as duas redes e utiliza uma política de negação por padrão. Dessa forma, novos fluxos de tráfego são bloqueados caso não exista uma regra explícita permitindo sua passagem.

Disciplina

Segurança da Informação

Instituto Federal Goiano – Campus Ceres

Curso: Sistemas de Informação

Projeto: TechStore Firewall