locals {
  project          = "rbo"
  environment      = "development"
  zone_id          = ""
  root_domain_name = ""
  acm_arn          = ""
}

module "admin-site" {
  source             = "../../../modules/aws/static-site"
  bucket_name        = "${local.project}-${local.environment}-admin-staticsite"
  root_domain_name   = local.root_domain_name
  target_domain_name = "admin.${local.root_domain_name}"
  zone_id            = local.zone_id
  acm_arn            = local.acm_arn
}

module "client-site" {
  source             = "../../../modules/aws/static-site"
  bucket_name        = "${local.project}-${local.environment}-client-staticsite"
  root_domain_name   = local.root_domain_name
  target_domain_name = "client.${local.root_domain_name}"
  zone_id            = local.zone_id
  acm_arn            = local.acm_arn
}
