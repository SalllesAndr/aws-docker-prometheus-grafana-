#!/bin/bash
set -eux

echo "Iniciando instalação na instância EC2 (Ubuntu)..."

# Atualiza pacotes e instala dependências essenciais
sudo apt update -y
sudo apt install -y docker.io git vim curl

# Inicia o serviço Docker
sudo systemctl enable --now docker

# Adiciona o usuário padrão ao grupo Docker
sudo usermod -aG docker ubuntu

# Baixa e instala a versão mais recente do Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verifica as versões instaladas
docker --version
docker-compose --version

# Ajusta permissões para evitar problemas com Docker
sudo chmod 666 /var/run/docker.sock

echo "Instalação concluída!"
