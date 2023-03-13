provider "aws" {
  region = var.region
}

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-vpc"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}


resource "aws_security_group" "endpoint_shared" {
  vpc_id = aws_vpc.default.id
  name = "endpoint_shared"
  description = "Common endpoints security group."
  lifecycle {
    prevent_destroy = true
  }
  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self = true
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  tags = {
    Name = "endpoint_shared"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}
