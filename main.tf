provider "aws" {
  region = "eu-north-1"
  access_key = "AKIA4JBXL4JTGN34KX6H"
  secret_key = "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"
}

# resource "aws_ecr_repository" "app_ecr_repo" {
#   name = "python_app"
# }

# resource "aws_ecr_repository" "web_ecr_repo" {
#   name = "nginx_app"
# }

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
    Owner = "yaron"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
    Owner = "yaron"
  }
}

# Create Subnet
resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "main-subnet"
    Owner = "yaron"
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "main-route-table"
    Owner = "yaron"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.main.id
}

# Create Security Group
resource "aws_security_group" "allow_http" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
    Owner = "yaron"
  }
}

# Create EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-03238ca76a3266a07"
  instance_type = "t3.micro"
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  associate_public_ip_address = true

  tags = {
    Name = "web-instance"
    Owner = "yaron"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user

              # configure aws with the following parameters
              aws configure set aws_access_key_id AKIA4JBXL4JTGN34KX6H
              aws configure set aws_secret_access_key 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
              aws configure set default.region eu-north-1

              # login to ecr
              aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 844077195878.dkr.ecr.eu-north-1.amazonaws.com

              # Create a network for the containers
              docker network create app-network

              # Run the Python app container
              docker run -d --name python_app --network app-network  844077195878.dkr.ecr.eu-north-1.amazonaws.com/python_app:latest
              
              # Run the Nginx container
              docker run -d -p 80:80 --name nginx_app --network app-network 844077195878.dkr.ecr.eu-north-1.amazonaws.com/nginx_app:latest

              EOF
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
