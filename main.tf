provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "mytest" {
  bucket = "mytest"
}

resource "aws_s3_bucket_policy" "mytest" {
  bucket = aws_s3_bucket.mytest.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::mytest/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}