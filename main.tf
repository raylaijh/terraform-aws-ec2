terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}



provider "aws" {
  region = var.region
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

variable "region" {
  default = []
}

variable "instance_count" {
  default = []
}

variable "instance_type" {
  default = []
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count         = var.instance_count

  tags = {
    Name = "HelloWorld-${count.index}"
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
