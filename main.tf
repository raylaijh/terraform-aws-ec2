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
resource "aws_eip" "foo" {
  instance = aws_instance.foo.id
  vpc      = true
}

resource "aws_eip_association" "foo" {
  instance_id   = aws_instance.foo.id
  allocation_id = aws_eip.foo.id
}


resource "aws_instance" "foo" {
  ami           = data.aws_ami.ubuntu.id # ap-southeast-1
  instance_type = var.instance_type
  key_name      = var.ssh_key
  user_data = file("${path.module}/files/timezone.sh")
  


  tags = {
    Name = var.instance_name
    }
  
  subnet_id = var.subnet_id
  

  credit_specification {
    cpu_credits = "unlimited"
  }
}


