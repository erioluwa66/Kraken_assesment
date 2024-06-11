variable "nomad_version" {
  default = "1.4.3"
}

variable "consul_version" {
  default = "1.10.4"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "local_file" "nomad_user_data" {
  filename = "${path.module}/nomad_user_data.tpl"
}

resource "aws_instance" "nomad" {
  ami           = "ami-033fabdd332044f06" # Amazon Linux 2 AMI
  instance_type = "t2.medium"
  key_name      = "kraken-assesment"

  user_data = templatefile("${path.module}/nomad_user_data.tpl", {
    NOMAD_VERSION  = var.nomad_version,
    CONSUL_VERSION = var.consul_version
  })

  tags = {
    Name = "NomadSingleNode"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }
}

output "instance_ip" {
  value = aws_instance.nomad.public_ip
}
