provider "aws" {
  region = var.region
}

resource "public_subnet" {
  source = "../../modules/kc_subnet"
  vpc_id = aws_vpc.default.id
  route_table_id = aws_route_table.public.id
  subnet_cidr = var.public_subnet_cidr
  availability_zones = var.availability_zones
  vpc_name = var.vpc_name
  name_suffix = "public1"
  tags = {
    immutable_metadata = "{ \"purpose\": \"internal_${var.vpc_name}\", \"target\": null }"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
    "kubernetes.io/role/elb" = "1"
    name = "just test"
  }
}
