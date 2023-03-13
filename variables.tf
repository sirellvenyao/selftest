variable "aws_region"{
	default "ap-east-1"
}

}
variable "business-line"{
	default "ops"
}
variable "xygj_private_ip"{
	default "10.200.14.56/32"
}


variable "vpc_name"{
	default = "vaex"
}

variable "vpc_cidr"{
	default = "10.201.0.0/16"
}

variable "public_subnet_cidr"{
	default = "10.201.0.0/21,10.201.8.0/21,10.201.16.0/21"
}

variable "private_main_subnet_cidr"{
	default = "10.201.32.0/19,10.201.128.0/19,10.201.24.0/21"
}

variable "private_eks_subnet_cidr"{
	default = "10.201.64.0/18,10.201.160.0/19"
}

variable "private_tgw_subnet_cidr"{
	default = "10.201.192.0/27,10.201.192.32/27,10.201.192.64/27"
}

variable "availability_zones"{
	default = "ap-east-1a,ap-east-1b,ap-east-1c"
}

variable "tgw_id"{
	default = "tgw-003798745fa32f512"
}

variable "created-by"{
	default = "morty"
}

variable "owner"{
	default = "morty"
}

variable "business-line"{
	default = "ops"
}
