#!/bin/bash
set -eux

echo "Iniciando instalação na instância EC2..."

# Atualiza pacotes e instala dependências essenciais
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg git

echo "Adicionando chave do repositório Docker..."
# Criando diretório seguro para chave GPG do Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adicionando repositório oficial do Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza pacotes novamente após adicionar repositório
sudo apt update -y

echo "Instalando Docker e dependências..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Instalando Docker Compose Standalone..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version  # Verifica se foi instalado corretamente

echo "Adicionando usuário 'ubuntu' ao grupo Docker..."
sudo usermod -aG docker ubuntu
newgrp docker

echo "Habilitando e iniciando serviço Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Clonando o repositório stack-prometheus..."
cd /home/ubuntu
git clone https://github.com/SalllesAndr/aws-docker-prometheus-grafana- aws-docker-prometheus-grafana


echo "Ajustando permissões..."
sudo chown -R ubuntu:ubuntu /home/ubuntu/aws-docker-prometheus-grafana


echo "Subindo os containers com Docker Compose..."
cd /home/ubuntu/aws-docker-prometheus-grafana/stack-prometheus
docker-compose up -d


echo "Instalação concluída! Prometheus e Grafana estão rodando."
