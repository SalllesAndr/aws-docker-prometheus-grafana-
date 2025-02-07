#!/bin/bash
set -eux

# Atualiza os pacotes
sudo apt update -y

# Instala dependências para adicionar repositórios HTTPS
sudo apt install -y ca-certificates curl gnupg

# Adiciona a chave GPG oficial do Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório oficial do Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza a lista de pacotes novamente
sudo apt update -y

# Instala o Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adiciona o usuário ao grupo Docker
sudo usermod -aG docker ubuntu
newgrp docker

# Habilita e inicia o serviço Docker
sudo systemctl enable docker
sudo systemctl start docker
