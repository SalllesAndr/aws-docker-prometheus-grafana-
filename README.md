# Monitoramento com Prometheus e Grafana via Exporters

## Autor: Anderson Sales

### Arquivo `docker-compose.yml`

#### Serviços Utilizados

- **reverse_proxy** - Nginx configurado como proxy reverso para publicação via domínio.
- **prometheus** - Ferramenta de monitoramento para coletar métricas.
- **node-exporter** - Exporter para coletar métricas da máquina host.
- **docker-exporter** - Exporter para monitoramento do Docker e seus containers.
- **grafana** - Ferramenta de visualização para exibir dashboards baseados nos dados do Prometheus.
- **portainer** - Interface web para gerenciamento de containers Docker.
- **letsencrypt** - Serviço para geração e gerenciamento de certificados SSL.

Este documento detalha os passos necessários para configurar e executar esse ambiente de monitoramento.

---

## 🏗️ Criando a Infraestrutura na AWS

Para iniciar, vamos criar uma instância EC2 na AWS utilizando **Ubuntu 24.04**, do tipo **t2.micro**. Durante a criação da instância, no campo **"Dados do Usuário"**, insira o seguinte script de inicialização:

```bash
#!/bin/bash
set -eux

# Atualizar pacotes e instalar dependências
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg git

# Adicionar chave e repositório do Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Instalar Docker Compose Standalone
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Adicionar usuário ao grupo Docker
sudo usermod -aG docker ubuntu
newgrp docker

# Habilitar e iniciar o Docker
sudo systemctl enable docker
sudo systemctl start docker

# Clonar e iniciar o ambiente
cd /home/ubuntu
git clone https://github.com/SalllesAndr/aws-docker-prometheus-grafana- stack-prometheus
cd stack-prometheus
docker-compose up -d

echo "✅ Ambiente configurado com sucesso!"
```

Esse script automatiza a configuração da instância EC2, instalando o Docker, Docker Compose e clonando automaticamente o repositório `stack-prometheus`, além de iniciar os containers.

Caso prefira fazer o processo manualmente, siga as próximas instruções.

---

## 🖥️ Configuração Manual do Servidor

Se você **não** utilizou o script de inicialização na EC2, siga os passos abaixo:

### 1️⃣ Instalação do Docker e Docker Compose no Ubuntu

```bash
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/trusted.gpg.d/docker.asc
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y
sudo apt install -y docker-ce docker-compose
```

### 2️⃣ Clonar e iniciar o projeto `stack-prometheus`

```bash
git clone https://github.com/SalllesAndr/aws-docker-prometheus-grafana- stack-prometheus
cd stack-prometheus
docker-compose up -d
```

---

## 🎛️ Configuração do Ambiente

Com os serviços rodando, siga os passos abaixo para configurar os dashboards:

### **📌 Configuração do Prometheus**

Edite o arquivo `prometheus.yml` caso queira adicionar mais endpoints de monitoramento.

### **📌 Configuração do Grafana**

Acesse o Grafana via `http://<IP_DA_INSTANCIA>:3000` e siga os passos:

1. Login padrão: **admin / admin** (é recomendado alterar a senha ao logar pela primeira vez).
2. Adicione o Prometheus como **Data Source** (`http://prometheus:9090`).
3. Importe os seguintes dashboards para facilitar a visualização:
   - [Node Exporter Full Dashboard](https://grafana.com/grafana/dashboards/1860/)
   - [Docker Metrics](https://grafana.com/grafana/dashboards/11074/)
   - [NGINX Dashboard](https://grafana.com/grafana/dashboards/11467/)

### **📌 Configuração do Proxy Reverso**

Caso queira acessar o Grafana e Prometheus via domínio, configure o **Nginx** como proxy reverso e utilize **Let's Encrypt** para SSL.

---

## 🌍 Publicação e DNS

Se desejar acessar o Grafana e Prometheus por um domínio próprio, recomenda-se configurar um DNS e SSL. O [Cloudflare](https://www.cloudflare.com/) é uma boa opção para gerenciar domínios e certificados SSL gratuitos.

---

## 📩 Contato

Se tiver dúvidas, sugestões ou melhorias para este projeto, entre em contato:
📧 **E-mail:** <anderson.sales@example.com> (substitua pelo seu e-mail real)  
📂 **Repositório:** [GitHub - Anderson Sales](https://github.com/SalllesAndr/aws-docker-prometheus-grafana-)

---

🔥 **Agora seu ambiente está configurado com Prometheus, Grafana e Docker de forma automatizada!** 🚀
