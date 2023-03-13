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

module "monitor_shared_sg" {

  name        = "vaex-monitor-shared"
  description = "The shared sg for monitor resources."
  vpc_id      = aws_vpc.default.id

  ingress_rules = [

    "all-all",
  ]

  ingress_cidr_blocks = [

    var.xygj_private_ip,
    "10.201.37.250/32",
    "10.200.14.72/32",
    "10.200.12.56/32",
    "10.200.13.179/32",
    "10.200.14.247/32",

  ]

  ingress_with_cidr_blocks = [


    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "for aws health check and other app"
      cidr_blocks = "10.201.0.0/16"
    },

    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "for aws health check and other app"
      cidr_blocks = "10.201.0.0/16"
    },

    {
      from_port   = 30000
      to_port     = 35000
      protocol    = "tcp"
      description = "for aws health check and other app"
      cidr_blocks = "10.201.0.0/16"
    },
    
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "for Cyberark HK jumper server"
      cidr_blocks = "10.200.2.166/32"
    },    
    
    
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "for risk nginx"
      cidr_blocks = "10.202.25.233/32"
    },   
    
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "for risk nginx"
      cidr_blocks = "10.202.25.233/32"
    },       

    {
      from_port   = 31368
      to_port     = 31368
      protocol    = "tcp"
      description = "financial for cyberark"
      cidr_blocks = "10.200.2.166/32"
    },       
    
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "for financial nginx"
      cidr_blocks = "10.200.12.56/32"
    },  
    
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "for financial nginx"
      cidr_blocks = "10.200.13.179/32"
    },     
    
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "for risk xygj windows"
      cidr_blocks = "10.200.14.29/32"
    },      

  ]

  ingress_with_self = [
    {
      rule        = "all-all"
      description = "Self"
    },
  ]

  egress_rules = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]

  egress_ipv6_cidr_blocks = []

  tags = {
    Name          = "vaex-monitor-shared"
    created-by    = var.created-by
    owner         = var.owner
    business-line = var.business-line
  }
}
