provider "aws" {
  region = var.region
}

resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.222.10.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf_test"
  }

}
