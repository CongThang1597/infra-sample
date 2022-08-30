locals {
  project            = "rbo"
  environment        = "development"
  aws_image_registry = ""

}

module "rbo-backend-ecr" {
  source          = "../../modules/aws/ecr"
  repository_name = "${local.project}/${local.environment}/rbo-backend"
  keep_last_image = 3
}

module "acm" {
  source           = "../../modules/aws/acm"
  root_domain_name = ""
  profile          = "rbo-master"
}

module "acm_alb" {
  source           = "../../modules/aws/alb_acm"
  root_domain_name = ""
}

module "ses" {
  source        = "../../modules/aws/ses"
  domain        = ""
  email_address = ""
  zone_id       = ""
}
