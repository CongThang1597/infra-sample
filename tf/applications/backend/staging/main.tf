module "static-metadata-file" {
  source        = "../../../modules/aws/s3"
  bucket_name   = "${local.project}-${local.environment}-metadata"
  attach_policy = 0
}
