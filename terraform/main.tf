resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "MyTerraformVPC" }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "MyTerraformSubnet" }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "MyInternetGateway" }
}


resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "MyRouteTable" }
}


resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}


resource "aws_security_group" "main" {
  name        = "zabbix-sg"
  description = "Allow SSH and Zabbix access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Zabbix Web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Zabbix Server"
    from_port   = 10051
    to_port     = 10051
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Zabbix Agent"
    from_port   = 10050
    to_port     = 10050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ZabbixSecurityGroup" }
}


data "local_file" "user_data" {
  filename = "${path.module}/scripts/user_data.sh"
}





resource "aws_instance" "zabbix_server" {
  ami           = "ami-0e2c8caa4b6378d8c" 
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.main.id

  vpc_security_group_ids      = [aws_security_group.main.id]
  associate_public_ip_address = true

  
  user_data = data.local_file.user_data.content

  tags = { Name = "ZabbixServerInstance" }
}