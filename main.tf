provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    effect = "Allow"



    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}