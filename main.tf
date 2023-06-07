provider "aws" {
  region = var.region
}

# 1.for Ensure permissions are tightly controlled for AWS ElasticSearch Domains

variable "domain" {
  default = "tf-test"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "example" {
  domain_name = var.domain

  # ... other configuration ...

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*",
      "Condition": {
        "IpAddress": {"aws:SourceIp": ["66.193.100.22/32"]}
      }
    }
  ]
}
POLICY
}


# 2. Ensure public access is disabled for Amazon Simple Notification Service (SNS)

resource "aws_sns_topic" "test" {
  name = "my-topic-with-policy"
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.test.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account-id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.test.arn,
    ]

    sid = "__default_statement_ID"
  }
}


# 3. Ensure permissions are tightly controlled for Amazon Elastic Container Registry (Amazon ECR)

resource "aws_ecr_repository" "foo" {
  name = "bar"
}

data "aws_iam_policy_document" "foopolicy" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "foopolicy" {
  repository = aws_ecr_repository.foo.name
  policy     = data.aws_iam_policy_document.foopolicy.json
}


# 4. Ensure permissions are tightly controlled for AWS EFS File System

resource "aws_efs_file_system" "fs" {
  creation_token = "my-product"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "ExampleStatement01"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
    ]

    resources = [aws_efs_file_system.fs.arn]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.fs.id
  policy         = data.aws_iam_policy_document.policy.json
}


# 5. Ensure principal is defined for every IAM policy attached to AWS Key Management Service (KMS) key

resource "aws_kms_key" "a" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}



# 6. Ensure that IAM Users are Unauthorized to Edit Access Policies

resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


# 7. Ensure there are no public file systems for AWS Elastic File System (EFS)

resource "aws_efs_file_system" "fs" {
  creation_token = "my-product"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "ExampleStatement01"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
    ]

    resources = [aws_efs_file_system.fs.arn]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.fs.id
  policy         = data.aws_iam_policy_document.policy.json
}


# 8. Ensure Amazon Simple Queue Service (SQS) is not exposed to public

resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terraform-example-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "production"
  }
}

# 9. RDS SG

resource "aws_security_group" "wp_db_security_group" {
  name        = "wp_db_security_group"
  description = "Control access to the wp database server."
}

# TCP

# INGRESS

# allow ssh access from port 3306 (sql) from ${var.ec2_instance_wp_private_ips}/32
resource "aws_security_group_rule" "ingress_sql" {
  security_group_id = "${aws_security_group.wp_db_security_group.id}"
  type              = "ingress"
  cidr_blocks       = ["${var.ec2_instance_wp_private_ips[0]}/32"]
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
}
# EXGRESS

# allow reply traffic from the server to the internet on ephemeral ports
resource "aws_security_group_rule" "engress_sql" {
  security_group_id = "${aws_security_group.wp_db_security_group.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 1024
  to_port           = 65535
}


# 10. RDS 

resource "aws_db_instance" "wp_db" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.2"
  instance_class       = "db.t2.micro"
  name                 = "wp_db"
  username             = "wp_db_user"
  password             = "wp_db_pass"
  parameter_group_name = "default.mariadb10.2"
  skip_final_snapshot  = true

  # list of security groups for the instance
  vpc_security_group_ids = [
    "${aws_security_group.wp_db_security_group.name}"
  ]

  tags {
    Name     = "wp"
    stage    = "demo"
    language = "sql"
    service  = "sql"
  }
}