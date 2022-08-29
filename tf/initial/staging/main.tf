locals {
  project            = "rbo"
  environment        = "staging"
  aws_image_registry = "794293228777.dkr.ecr.ap-northeast-1.amazonaws.com"

}

module "rbo-backend-ecr" {
  source          = "../../modules/aws/ecr"
  repository_name = "${local.project}/${local.environment}/rbo-backend"
  keep_last_image = 3
}

module "acm" {
  source           = "../../modules/aws/acm"
  root_domain_name = "staging-cvalue.jp"
  profile          = "rbo-master"
}

module "acm_alb" {
  source           = "../../modules/aws/alb_acm"
  root_domain_name = "staging-cvalue.jp"
}

#module "ses" {
#  source           = "../../modules/aws/ses"
#  domain           = "snack.beauty"
#  email_address    = "snack@snack.beauty"
#  zone_id          = "Z10100782EHJ2W85PY045"
#}
