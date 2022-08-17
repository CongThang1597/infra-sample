locals {
  project            = "rbo"
  environment        = "development"
  aws_image_registry = "872692067237.dkr.ecr.ap-northeast-1.amazonaws.com"

}

module "admin-site" {
  source             = "../../modules/aws/static-site"
  bucket_name        = "snack.beauty.local.1"
  root_domain_name   = "snack.beauty"
  target_domain_name = "admin.snack.beauty"
  zone_id            = "Z10100782EHJ2W85PY045"
  acm_arn            = "arn:aws:acm:us-east-1:872692067237:certificate/a8ddcbe8-4d4c-4562-a30a-2f3228babd47"
}

module "client-site" {
  source             = "../../modules/aws/static-site"
  bucket_name        = "snack.beauty.local.2"
  root_domain_name   = "snack.beauty"
  target_domain_name = "client.snack.beauty"
  zone_id            = "Z10100782EHJ2W85PY045"
  acm_arn            = "arn:aws:acm:us-east-1:872692067237:certificate/a8ddcbe8-4d4c-4562-a30a-2f3228babd47"
}
