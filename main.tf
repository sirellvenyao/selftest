provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "my_tf_test_bucket" {
  bucket = "my_tf_test_bucket"
}

resource "aws_s3_bucket_policy" "my_tf_test_bucket" {
  bucket = aws_s3_bucket.my_tf_test_bucket.id

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
      "Resource": "arn:aws:s3:::my_tf_test_bucket/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}