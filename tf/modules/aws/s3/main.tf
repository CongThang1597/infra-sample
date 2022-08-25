resource "aws_s3_bucket" "root" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.root.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3block" {
  bucket                  = aws_s3_bucket.root.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}


resource "aws_s3_bucket_ownership_controls" "root" {
  bucket = aws_s3_bucket.root.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_policy" "allow_access" {
  count  = var.attach_policy
  bucket = aws_s3_bucket.root.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    sid     = "S3Policy"
    effect  = "Allow"
    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.root.arn,
      "${aws_s3_bucket.root.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_cors_configuration" "root-cors" {
  bucket = aws_s3_bucket.root.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}
