locals {
  project          = "rbo"
  environment      = "staging"
  zone_id          = "Z0385594DZ7HIG1O2YUI"
  root_domain_name = "staging-cvalue.jp"
  acm_arn          = "arn:aws:acm:us-east-1:794293228777:certificate/fbaa483b-3bc8-44c1-b7aa-3d74d06aae5d"
}

module "admin-site" {
  source             = "../../../modules/aws/static-site"
  bucket_name        = "${local.project}-${local.environment}-admin-staticsite"
  root_domain_name   = local.root_domain_name
  target_domain_name = "admin.${local.root_domain_name}"
  zone_id            = local.zone_id
  acm_arn            = local.acm_arn
}

#module "client-site" {
#  source             = "../../../modules/aws/static-site"
#  bucket_name        = "${local.project}-${local.environment}-client-staticsite"
#  root_domain_name   = local.root_domain_name
#  target_domain_name = "client.${local.root_domain_name}"
#  zone_id            = local.zone_id
#  acm_arn            = local.acm_arn
#}
