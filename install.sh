#!/bin/bash

set -e

BASE_DIR="/home/jairo/dashy"

echo "Criando diretórios..."

mkdir -p $BASE_DIR/config

echo "Criando docker-compose..."

cat > $BASE_DIR/docker-compose.yml <<EOF
version: "3.8"

services:
  dashy:
    image: lissy93/dashy:latest
    container_name: dashy
    ports:
      - "8080:8080"
    volumes:
      - ./config:/app/user-data
    environment:
      NODE_ENV: production
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "node", "/app/services/healthcheck"]
      interval: 90s
      timeout: 10s
      retries: 3
      start_period: 40s
EOF

echo "Criando conf.yml..."

cat > $BASE_DIR/config/conf.yml <<EOF
pageInfo:
  title: Infra Dashboard
  description: Painel de acesso rápido

sections:

  - name: DevOps
    icon: fas fa-server
    items:

      - title: Grafana
        icon: hl-grafana
        url: http://grafana.local

      - title: Prometheus
        icon: hl-prometheus
        url: http://prometheus.local

  - name: Infraestrutura
    icon: fas fa-network-wired
    items:

      - title: Portainer
        icon: hl-portainer
        url: http://portainer.local

      - title: Rancher
        icon: hl-rancher
        url: http://rancher.local
EOF

echo "Subindo Dashy..."

cd $BASE_DIR
docker compose up -d

echo ""
echo "Dashy instalado!"
echo "Acesse:"
echo "http://IP_DO_SERVIDOR:8080"
