#!/bin/bash
set -eux

echo "Iniciando instalação na instância EC2..."

# Atualiza pacotes e instala dependências essenciais
sudo yum update -y
sudo yum install -y docker git vim

# Inicia o serviço Docker
sudo service docker start

# Adiciona o usuário padrão ao grupo Docker
sudo usermod -aG docker ec2-user

# Configura Docker para iniciar automaticamente
sudo chkconfig docker on

# Instala a versão mais recente do Docker Compose Standalone
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verifica as versões instaladas
docker version
docker-compose version

# Ajusta permissões para evitar problemas com Docker
sudo chmod 666 /var/run/docker.sock

echo "Instalação concluída!"
