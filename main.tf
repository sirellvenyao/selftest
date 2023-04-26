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
  availability_zone       = "ap-east-1c"
  map_public_ip_on_launch = false

  tags = {
    Name = "tf_a_new_one"
  }
}

resource "aws_subnet" "tf_a_new" {
  vpc_id                  = aws_vpc.tf_vpc2.id
  cidr_block              = "10.222.11.0/24"
  availability_zone       = "ap-east-1c"
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
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    self = true
  }
  ingress {
    cidr_blocks = ["10.0.0.0/16"]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    self = true
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  ingress {
    cidr_blocks = ["10.2.0.0/16"]
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    self = true
  }  
  tags = {
    Name = "endpoint_shared"
    business-line = "test"
  }
}

resource "aws_security_group" "sentinel_22_added_sg" {
  vpc_id = aws_vpc.tf_vpc2.id
  name = "sentinel_22_added_sg"
  description = "sentinel_22_added_sg"
  lifecycle {
    prevent_destroy = true
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  ingress {
    cidr_blocks = ["10.3.0.0/16"]
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    self = true
  }
  ingress {
    cidr_blocks = ["10.3.0.0/16"]
    from_port = 100
    protocol  = "-1"
    to_port   = 100
    self = true
  }    
  tags = {
    Name = "sentinel_22_added_sg"
    business-line = "test"
  }
}

resource "aws_security_group_rule" "just_test" {
  type              = "ingress"
  from_port         = 161
  to_port           = 161
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0","10.3.0.0/24"]
  security_group_id = aws_security_group.sentinel_22_added_sg.id
}

resource "aws_instance" "missed_file_instance" {
    ami = "ami-09d56f8956ab235b3"
    count = "1"
    subnet_id = aws_subnet.tf_a_new.id
    instance_type = "t2.micro"
    key_name = "tomcat"
    metadata_options  {
      http_endpoint               = "enabled"
//      http_tokens                 = "required"
      http_put_response_hop_limit = 5
      instance_metadata_tags      = "enabled"
    }   
} 

resource "aws_instance" "No_metadata_instance" {
    ami = "ami-09d56f8956ab235b3"
    count = "1"
    subnet_id = aws_subnet.tf_a_new.id
    instance_type = "t2.micro"
    key_name = "tomcat"
} 

resource "aws_instance" "correct_instance" {
    ami = "ami-09d56f8956ab235b3"
    count = "1"
    subnet_id = aws_subnet.tf_a_new.id
    instance_type = "t2.micro"
    key_name = "tomcat"
    metadata_options  {
      http_endpoint               = "enabled"
      http_tokens                 = "required"
      http_put_response_hop_limit = 5
      instance_metadata_tags      = "enabled"
    } 
} 

resource "aws_network_acl" "tf_nacl" {
  vpc_id = aws_vpc.tf_vpc2.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "main"
  }
}

resource "aws_db_instance" "education" {
  identifier             = "education"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = "edu"
  password               = "var.db_password"
  //db_subnet_group_name   = aws_db_subnet_group.education.name
  //vpc_security_group_ids = aws_security_group.sentinel_22_added_sg.id
  parameter_group_name   = "testname"
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_elasticsearch_domain" "example" {
  domain_name           = "example"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "r4.large.elasticsearch"
  }

  tags = {
    Domain = "TestDomain"
  }
}


resource "aws_elb" "wu-tang" {
  name               = "wu-tang"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port      = 443
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
  }

  tags = {
    Name = "wu-tang"
  }
}

resource "aws_load_balancer_policy" "wu-tang-ssl" {
  load_balancer_name = aws_elb.wu-tang.name
  policy_name        = "wu-tang-ssl"
  policy_type_name   = "SSLNegotiationPolicyType"

  policy_attribute {
    name  = "ECDHE-ECDSA-AES128-GCM-SHA256"
    value = "true"
  }

  policy_attribute {
    name  = "Protocol-TLSv1.2"
    value = "true"
  }
}

resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "iis",
    "image": "mcr.microsoft.com/windows/servercore/iis",
    "cpu": 1024,
    "memory": 2048,
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "WINDOWS_SERVER_2019_CORE"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_task_definition" "ellventest" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "iis",
    "image": "mcr.microsoft.com/windows/servercore/iis",
    "cpu": 1024,
    "memory": 2048,
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "WINDOWS_SERVER_2019_CORE"
    cpu_architecture        = "X86_64"
  }
}


resource "aws_ecs_service" "bar" {
  name                = "bar"
  scheduling_strategy = "DAEMON"
}

resource "aws_ecs_service" "test" {
  name                  = "test"
  scheduling_strategy   = "DAEMON"
  ordered_placement_strategy {
    type         = "binpack"
  }
  
}