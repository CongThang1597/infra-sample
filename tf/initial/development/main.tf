locals {
  project            = "rbo"
  environment        = "development"
  aws_image_registry = "872692067237.dkr.ecr.ap-northeast-1.amazonaws.com"

}

module "rbo-backend-ecr" {
  source          = "../../modules/aws/ecr"
  repository_name = "${local.project}/${local.environment}/rbo-backend"
  keep_last_image = 3
}

module "acm" {
  source           = "../../modules/aws/acm"
  root_domain_name = "snack.beauty"
}

module "acm_alb" {
  source           = "../../modules/aws/alb_acm"
  root_domain_name = "snack.beauty"
}
