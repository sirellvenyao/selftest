provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "mytestssakvnkasicsk19230dklsc" {
  bucket = "mytestssakvnkasicsk19230dklsc"
}

resource "aws_iam_group" "group" {
  name = "test-group"
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_s3_bucket_policy" "mytestssakvnkasicsk19230dklsc" {
  bucket = aws_s3_bucket.mytestssakvnkasicsk19230dklsc.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": [
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning",
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Resource": "arn:aws:s3:::mytestssakvnkasicsk19230dklsc/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "Ellventestssakvnkasicsk19230dklsc" {
  bucket = "Ellventestssakvnkasicsk19230dklsc"
}

resource "aws_s3_bucket_policy" "Ellventestssakvnkasicsk19230dklsc" {
  bucket = aws_s3_bucket.Ellventestssakvnkasicsk19230dklsc.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "S3-Console-Auto-Gen-Policy-1670678796275",
    "Statement": [
        {
            "Sid": "S3PolicyStmt-DO-NOT-MODIFY-1670678792895",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::891189580005:root",
                    "arn:aws:iam::875537689616:root",
                    "arn:aws:iam::555625778301:root"
                ]
            },
            "Action": [
                "s3:GetBucketVersioning",
                "s3:PutBucketVersioning",
                "s3:ReplicateObject",
                "s3:ReplicateDelete"
            ],
            "Resource": [
                "arn:aws:s3:::kucoin-cloudtrail-central",
                "arn:aws:s3:::kucoin-cloudtrail-central/*"
            ]
        },
        {
            "Sid": "AWSCloudTrailAclCheck20131101",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::kucoin-cloudtrail-central"
        },
        {
            "Sid": "AWSCloudTrailWrite20131101",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::kucoin-cloudtrail-central/write/AWSLogs/*",
                "arn:aws:s3:::kucoin-cloudtrail-central/read/AWSLogs/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:SourceArn": [
                        "arn:aws:cloudtrail:ap-northeast-1:875537689616:trail/management-events-write-875537689616",
                        "arn:aws:cloudtrail:ap-northeast-1:875537689616:trail/management-events-read-875537689616",
                        "arn:aws:cloudtrail:ap-northeast-1:555625778301:trail/management-events-write-555625778301",
                        "arn:aws:cloudtrail:ap-northeast-1:555625778301:trail/management-events-read-555625778301",
                        "arn:aws:cloudtrail:ap-northeast-1:891189580005:trail/management-events-write-891189580005",
                        "arn:aws:cloudtrail:ap-northeast-1:891189580005:trail/management-events-read-891189580005"
                    ],
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSCloudTrailS3Write20131101",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": [
                "arn:aws:s3:::kucoin-cloudtrail-central/s3write/AWSLogs/*",
                "arn:aws:s3:::kucoin-cloudtrail-central/s3read/AWSLogs/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:SourceArn": [
                        "arn:aws:cloudtrail:ap-northeast-1:875537689616:trail/s3-events-write-875537689616",
                        "arn:aws:cloudtrail:ap-northeast-1:875537689616:trail/s3-events-read-875537689616",
                        "arn:aws:cloudtrail:ap-northeast-1:555625778301:trail/s3-events-write-555625778301",
                        "arn:aws:cloudtrail:ap-northeast-1:555625778301:trail/s3-events-read-555625778301",
                        "arn:aws:cloudtrail:ap-northeast-1:891189580005:trail/s3-events-write-891189580005",
                        "arn:aws:cloudtrail:ap-northeast-1:891189580005:trail/s3-events-read-891189580005"
                    ],
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSCloudTrailReadOnly20230506",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::892535148939:role/arron"
            },
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::kucoin-cloudtrail-central",
                "arn:aws:s3:::kucoin-cloudtrail-central/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role" "example" {
  name                = "yak_role"
  assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown)
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}


resource "aws_iam_policy" "policy_one" {
  name = "policy-618033"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:Describe*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "policy_two" {
  name = "policy-381966"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListAllMyBuckets", "s3:ListBucket", "s3:HeadBucket"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

//data "archive_file" "lambda" {
//  type        = "zip"
//  source_file = "lambda.js"
//  output_path = "lambda_function_payload.zip"
//}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.example.arn
  handler       = "index.test"

  //source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_function" "test_lambda_2" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.example.arn
  handler       = "index.test"

  //source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs18.x"
}

resource "aws_iam_role" "jsonencode" {
  name = "jsonencode"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

data "aws_iam_policy_document" "instance_assume_role_policy_jason" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "adsdata" {
  name               = "yak_role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy_jason.json # (not shown)

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ec2:Describe*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  inline_policy {
    name   = "policy-8675309"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions   = ["ec2:DescribeAccountAttributes"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "test"
  user = aws_iam_user.lb.name

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

resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/system/"
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.lb.name
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = "${aws_iam_role.test_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy123OOL" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "foobar" {
  name                          = "tf-trail-foobar"
  s3_bucket_name                = aws_s3_bucket.foo.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
}

resource "aws_s3_bucket" "foo" {
  bucket        = "tf-test-trail"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "foo" {
  bucket = aws_s3_bucket.foo.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.foo.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.foo.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "PublicAccesS3Example" {
  bucket = "PublicAccesS3Example"
}



resource "aws_s3_bucket_ownership_controls" "PublicAccesS3Example" {
  bucket = aws_s3_bucket.PublicAccesS3Example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "PublicAccesS3Example" {
  bucket = aws_s3_bucket.PublicAccesS3Example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "PublicAccesS3Example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.PublicAccesS3Example,
    aws_s3_bucket_public_access_block.PublicAccesS3Example,
  ]

  bucket = aws_s3_bucket.PublicAccesS3Example.id
  acl    = "public-read"
}

data "aws_canonical_user_id" "current" {}


resource "aws_s3_bucket_acl" "PublicAccesS3Example2xa" {
  depends_on = [aws_s3_bucket_ownership_controls.PublicAccesS3Example]
  bucket = aws_s3_bucket.PublicAccesS3Example.id
  access_control_policy {
    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "READ_ACP"
    }
    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}