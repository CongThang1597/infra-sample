resource "aws_cloudtrail" "foobar" {
  name                          = "${var.project}-${var.environment}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  s3_key_prefix                 = "trail"
  include_global_service_events = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.project}-${var.environment}-cloudtrail"
  force_destroy = true
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "foo" {
  bucket = aws_s3_bucket.cloudtrail.id
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
                  "Resource": "${aws_s3_bucket.cloudtrail.arn}"
              },
              {
                  "Sid": "AWSCloudTrailWrite",
                  "Effect": "Allow",
                  "Principal": {
                    "Service": "cloudtrail.amazonaws.com"
                  },
                  "Action": "s3:PutObject",
                  "Resource": "${aws_s3_bucket.cloudtrail.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
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

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name = "${var.project}-${var.environment}-cloudwatch"
}
