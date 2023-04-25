variable "aws_region" {
	default = "ap-east-1"
}
variable "aws" {
	default = "ap-east-1"
}

variable "region" {
	default = "ap-east-1"
}
variable "awsvpc_service_subnetids" {
  description = "List of subnet ids to which a service is deployed in fargate mode."
  default     = []
}