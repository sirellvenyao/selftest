# create vpc.
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

# create public subnet.
module "public_subnet" {
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
  }
}

# create private main subnet.
module "private_main_subnet" {
  source = "../../modules/kc_subnet"
  vpc_id = aws_vpc.default.id
  route_table_id = aws_route_table.private.id
  subnet_cidr = var.private_main_subnet_cidr
  availability_zones = var.availability_zones
  vpc_name = var.vpc_name
  name_suffix = "main-private1"
  tags = {
    immutable_metadata = "{ \"purpose\": \"internal_${var.vpc_name}\", \"target\": null }"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create private eks subnet.
module "private_eks_subnet" {
  source = "../../modules/kc_subnet"
  vpc_id = aws_vpc.default.id
  route_table_id = aws_route_table.private.id
  subnet_cidr = var.private_eks_subnet_cidr
  availability_zones = var.availability_zones
  vpc_name = var.vpc_name
  name_suffix = "eks-private1"
  tags = {
    immutable_metadata = "{ \"purpose\": \"internal_${var.vpc_name}\", \"target\": null }"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
    "kubernetes.io/cluster/kupo" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# create private tgw subnet.
module "private_tgw_subnet" {
  source = "../../modules/kc_subnet"
  vpc_id = aws_vpc.default.id
  route_table_id = aws_route_table.tgw_attach_private.id
  subnet_cidr = var.private_tgw_subnet_cidr
  availability_zones = var.availability_zones
  vpc_name = var.vpc_name
  name_suffix = "tgw-attach-private"
  tags = {
    immutable_metadata = "{ \"purpose\": \"internal_${var.vpc_name}\", \"target\": null }"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create default igw.
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-igw"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create tgw attachment.
resource "aws_ec2_transit_gateway_vpc_attachment" "default" {
  subnet_ids         = module.private_tgw_subnet.subnets
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.default.id
  tags = {
    Name = "tgw-attach-${var.vpc_name}-north-south"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create public route_table.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-rtb-${var.aws_region}-public"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create private route_table.
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-rtb-${var.aws_region}-private"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create tgw_attach_private route_table.
resource "aws_route_table" "tgw_attach_private" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-rtb-${var.aws_region}-tgw-attach-private"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create common sg for all endpoint.
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

# create s3 endpoint
resource "aws_vpc_endpoint" "s3" {
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_id       = aws_vpc.default.id
  # 网关模式模式
   route_table_ids = [aws_route_table.private.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-s3"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create ec2 endpoint
resource "aws_vpc_endpoint" "ec2" {
  service_name = "com.amazonaws.${var.aws_region}.ec2"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-ec2"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create ecr.api endpoint
resource "aws_vpc_endpoint" "ecr_api" {
  service_name = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-ecr.api"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create ecr.dkr endpoint
resource "aws_vpc_endpoint" "ecr_dkr" {
  service_name = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-ecr.dkr"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create elasticloadbalancing endpoint
resource "aws_vpc_endpoint" "elasticloadbalancing" {
  service_name = "com.amazonaws.${var.aws_region}.elasticloadbalancing"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-elasticloadbalancing"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create sts endpoint
resource "aws_vpc_endpoint" "sts" {
  service_name = "com.amazonaws.${var.aws_region}.sts"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-sts"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create xray endpoint
resource "aws_vpc_endpoint" "xray" {
  service_name = "com.amazonaws.${var.aws_region}.xray"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-xray"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create logs endpoint
resource "aws_vpc_endpoint" "logs" {
  service_name = "com.amazonaws.${var.aws_region}.logs"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-logs"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create eks endpoint
resource "aws_vpc_endpoint" "eks" {
  service_name = "com.amazonaws.${var.aws_region}.eks"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-eks"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create ebs endpoint
resource "aws_vpc_endpoint" "ebs" {
  service_name = "com.amazonaws.${var.aws_region}.ebs"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-ebs"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create monitoring endpoint
resource "aws_vpc_endpoint" "monitoring" {
  service_name = "com.amazonaws.${var.aws_region}.monitoring"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-monitoring"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create sqs endpoint
resource "aws_vpc_endpoint" "sqs" {
  service_name = "com.amazonaws.${var.aws_region}.sqs"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-sqs"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create ssm endpoint
resource "aws_vpc_endpoint" "ssm" {
  service_name = "com.amazonaws.${var.aws_region}.ssm"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-ssm"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create elasticache endpoint
resource "aws_vpc_endpoint" "elasticache" {
  service_name = "com.amazonaws.${var.aws_region}.elasticache"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-elasticache"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create elasticache endpoint
resource "aws_vpc_endpoint" "rds" {
  service_name = "com.amazonaws.${var.aws_region}.rds"
  vpc_id       = aws_vpc.default.id
  private_dns_enabled = true
  # Interface模式
  vpc_endpoint_type = "Interface"
  subnet_ids = module.private_eks_subnet.subnets
  security_group_ids = [aws_security_group.endpoint_shared.id]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "${var.vpc_name}-${var.aws_region}-rds"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create route53 resolver endpoint
resource "aws_route53_resolver_endpoint" "route53_outbound_infoblox" {
  name      = "${var.vpc_name}-route53-outbound-infoblox"
  direction = "OUTBOUND"

  security_group_ids = [
    aws_security_group.endpoint_shared.id,
  ]

  ip_address {
    subnet_id = module.private_tgw_subnet.subnets[0]
  }

  ip_address {
    subnet_id = module.private_tgw_subnet.subnets[1]
  }

  ip_address {
    subnet_id = module.private_tgw_subnet.subnets[2]
  }

  tags = {
    Name = "${var.vpc_name}-route53-outbound-infoblox"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create route53 rule
resource "aws_route53_resolver_rule" "amazonaws" {
  name = "${var.vpc_name}-amazonaws"
  domain_name = "amazonaws.com"
  rule_type   = "SYSTEM"

  tags = {
    Name = "${var.vpc_name}-amazonaws"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# create route53 rule
resource "aws_route53_resolver_rule" "default" {
  name = "${var.vpc_name}-default"
  domain_name          = "."
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.route53_outbound_infoblox.id

  target_ip {
    ip = "52.119.41.100"
  }
  target_ip {
    ip = "103.80.6.100"
  }
  target_ip {
    ip = "52.119.41.56"
  }
  target_ip {
    ip = "103.80.6.56"
  }
  target_ip {
    ip = "52.119.41.57"
  }
  target_ip {
    ip = "103.80.6.57"
  }

  tags = {
    Name = "${var.vpc_name}-default"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# route53 rule association
resource "aws_route53_resolver_rule_association" "amazonaws" {
  name = "${var.vpc_name}-amazonaws"
  resolver_rule_id = aws_route53_resolver_rule.amazonaws.id
  vpc_id           = aws_vpc.default.id
}

# route53 rule association
resource "aws_route53_resolver_rule_association" "default" {
  name = "${var.vpc_name}-default"
  resolver_rule_id = aws_route53_resolver_rule.default.id
  vpc_id           = aws_vpc.default.id
}

# route53 cloudwatch log group.
resource "aws_cloudwatch_log_group" "infoblox" {
  name = "infoblox"

  tags = {
    Name = "${var.vpc_name}-infoblox"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# query log config.
resource "aws_route53_resolver_query_log_config" "default" {
  name            = "default"
  destination_arn = aws_cloudwatch_log_group.infoblox.arn

  tags = {
    Name = "${var.vpc_name}-default"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

# query log config association.
resource "aws_route53_resolver_query_log_config_association" "default" {
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.default.id
  resource_id                  = aws_vpc.default.id
}

# create harbor s3 bucket
resource "aws_s3_bucket" "harbor" {
  bucket = "${var.vpc_name}-harbor-pro"
  tags = {
    Name = "${var.vpc_name}-harbor-pro"
    created-by = var.created-by
    owner = var.owner
    business-line = var.business-line
  }
}

resource "aws_s3_bucket_acl" "harbor_acl" {
  bucket = aws_s3_bucket.harbor.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "harbor_access_block" {
  bucket = aws_s3_bucket.harbor.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}