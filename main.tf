provider "aws" {
  region = var.region
}

resource "aws_vpc" "tf_vpc2" {
  cidr_block           = "10.222.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf_test"
  }

}

resource "aws_subnet" "tf_a_new_one" {
  vpc_id                  = aws_vpc.tf_vpc2.id
  cidr_block              = "10.222.10.0/26"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf_a_new_one"
  }
}

resource "aws_subnet" "tf_a_new" {
  vpc_id                  = aws_vpc.tf_vpc2.id
  cidr_block              = "10.222.11.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf_a_new_one"
  }
}


resource "aws_security_group" "tf_test" {
  vpc_id = aws_vpc.tf_vpc2.id
  name = "endpoint_shared"
  description = "Common endpoints security group."
  lifecycle {
    prevent_destroy = true
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
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
    business-line = "test"
  }
}
