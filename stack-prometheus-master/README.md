# Monitoramento com Prometheus e Grafana por meio de Exporters
## Author: Samuel Gonçalves Pereira
### Arquivo docker-compose.yaml
##### Services:
- reverse_proxy - nginx como proxy reverso para publicação por meio do dominio escolhido.
- prometheus - software para monitoramento utilizado
- node-exporter - container para monitoramento da vm *Servidor* e *Cliente*
- docker-exporter - container para monitoramento do serviço docker e containers em ambas as máquinas
- grafana - software para plotagem gráfica dos dashboards gerados com os dados do prometheus
- portainer - utilizado para gerenciamento via web do ambiente em docker
- letsencrypt - utilizado para criação do certificado SSL a ser utilizado pelo site

O presente documento visa documentar os passos realizados para subir o ambiente.

## Criação da Infraestrutura na AWS
Para iniciar, vamos criar uma máquina EC2 utilizando o Amazon Linux, sendo um t2.micro, e nos detalhes da instância, no campo "Dados do usuário" vamos inserir o seguinte shellscript:

```shell
#!/bin/bash
yum update -y
sudo yum install docker git -y
sudo service docker start
sudo usermod -a -G docker $USER
sudo chkconfig docker on
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
Desta forma teremos instalado o docker, docker compose, o git, e clonado este repositório para a máquina.

Caso queira fazer esse processo manualmente, o presente artigo detalhará os procedimentos a seguir.
## Ambiente monitorado

### Servidor
> :warning: **Muita atenção neste ponto!!**: Os passos a seguir são necessários **somente se você não fizer a instalação utilizando o shell script acima, na criação da instância EC2** Ok?

Instale em um servidor com ip válido para a internet para publicar em seu domínio. Ou, faça as regras de NAT necessárias para a publicação.

Se estiver usando Debian 10, siga os seguintes passos:

- Instalação e configuração do docker, com os comandos:
```sh
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
```
- Instalação e configuração do docker-compose com os seguintes comandos:
```sh
sudo curl -L https://github.com/docker/compose/releases/download/1.28.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
- Tendo instalado e configurado, basta subir o ambiente. Para isso, é preciso clonar o repositório atual com o comando:
```sh
git clone https://gitlab.com/sg-wolfgang/stack-prometheus.git
cd stack-prometheus
```
- Agora para rodar o ambiente, execute:
```sh
docker-compose up -d
```

## Configuração do ambiente

Com o ambiente devidamente em execução vamos partir para a configuração do mesmo, seguindo os pontos:

* Configuração do Prometheus para capturar as métricas geradas por nossa máquina local;
* Configuração do Grafana para receber os dados capturados pelo prometheus;
  * Sugestões de dashboards:
    * https://grafana.com/grafana/dashboards/1860?pg=dashboards&plcmt=featured-sub1
    * https://grafana.com/grafana/dashboards/11074
    * https://grafana.com/grafana/dashboards/11467
* Verificação de dados capturados após maior tempo de coleta.
* Configuração do proxy reverso para acesso via DNS.

### Informações adicionais

O serviço de DNS do domínio escolhido pode ser feito da forma que acharem melhor, eu sugiro a utilização do cloudflare, pois eles tem um serviço completo incluindo certificados SSL.

Para qualquer dúvida, sugestão ou questionamento estou disponível para contado por meio do e-mail: pereira.gsamuel@gmail.com

Abraço!

Samuel Gonçalves
