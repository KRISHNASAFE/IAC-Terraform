provider "aws" {
  region = "us-east-2"
}

# Create a VPC
resource "aws_vpc" "dev-poc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet in the VPC
resource "aws_subnet" "dev-poc-subnet" {
  vpc_id                  = aws_vpc.dev-poc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
}

# Create a security group
resource "aws_security_group" "dev-poc-sg" {
  name        = "dev-poc-sg"
  description = "Allow inbound SSH and HTTP traffic"
  vpc_id      = aws_vpc.dev-poc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance in the VPC and subnet
resource "aws_instance" "devec2" {
  ami           = ""
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.dev-poc-subnet.id
  vpc_security_group_ids = [aws_security_group.dev-poc-sg.id]

  tags = {
    Name = "dev-poc"
  }
}
