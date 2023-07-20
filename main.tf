provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "mytestssakvnkasicsk19230dklsc" {
  bucket = "mytestssakvnkasicsk19230dklsc"
}
resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
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