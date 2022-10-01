terraform {
  required_version = ">=1.0"
}
provider "aws" {
}


#Dynamic Block

locals {
  inbound_rules = [
    { port = 80, protocol = "tcp", },
    { port = 443, protocol = "tcp", },
    { port = 3000, protocol = "tcp", },
    { port = 8080, protocol = "tcp", },
  ]
}

resource "aws_security_group" "sg1" {
  name        = "sg1"
  description = "Allow HTTPS inbound traffic"

  dynamic "ingress" {
    for_each = local.inbound_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
      description = "TLS from VPC"
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "security group"
  }
}
