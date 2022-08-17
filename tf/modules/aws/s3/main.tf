resource "aws_s3_bucket" "frontend" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.frontend.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3block" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.frontend.arn,
      "${aws_s3_bucket.frontend.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_cors_configuration" "frontend-cors" {
  bucket = aws_s3_bucket.frontend.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}
