terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "jafner-net-terraform"
    region = "us-west-2"
    key = "main.tfstate"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "main" {
  bucket = "jafner-net-terraform"
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_ami" "nixos_arm64" {
  owners = ["427812963091"]
  most_recent = true
  filter {
    name = "name"
    values = ["nixos/24.11*"]
  }
  filter {
    name = "architecture"
    values = ["arm64"]
  }
}

import {
  to = aws_key_pair.terraform
  id = "terraform"
}

resource "aws_key_pair" "terraform" {
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICaTROYuPzHXtoXmTMFKKx7+fpi2ZtWqAdndLDT1IObv"
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2-sg"
  description = "Allow SSH access"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  ami = data.aws_ami.nixos_arm64.id
  instance_type = "t4g.nano"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = aws_key_pair.terraform.key_name
  tags = {
    Name = "MainEC2Instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.main.public_ip
}
