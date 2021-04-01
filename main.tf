terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "foo" {
  ami           = data.aws_ami.ubuntu.id # ap-southeast-1
  instance_type = "t2.micro"
  user_data = <<-EOF
		          #! /bin/bash
              sudo apt-get update
              sudo hostnamectl set-hostname bdo.poc.example.com
              sudo hostname
              EOF
  tags = {
    Name = "helloworld"
    }
  

  network_interface {
    network_interface_id = var.network_interface_id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hashicorp-raymond-test"

    workspaces {
      name = "aws-simple"
    }
  }
}
