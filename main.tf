provider "aws" {
  region = var.region
}
resource "aws_s3_bucket" "mytestssakvnkasicsk19230dklsc" {
  bucket = "mytestssakvnkasicsk19230dklsc"
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
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::mytestssakvnkasicsk19230dklsc/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "8.8.8.8/32"}
      }
    }
  ]
}
POLICY
}