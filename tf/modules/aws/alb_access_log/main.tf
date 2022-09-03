data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  force_destroy = true
}

data "aws_iam_policy_document" "main" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.main.json
}
