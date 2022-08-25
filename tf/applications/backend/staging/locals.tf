locals {
  project            = "rbo"
  environment        = "staging"
  aws_image_registry = "794293228777.dkr.ecr.ap-northeast-1.amazonaws.com"

  vpc = {
    cidr            = "10.7.0.0/16" # https://www.ipkeisan.com/subnet/?nw=10.7.0.0&len=16&sub=19
    public_subnets  = ["10.7.0.0/19", "10.7.32.0/19", "10.7.64.0/19"]
    private_subnets = ["10.7.128.0/19", "10.7.160.0/19", "10.7.192.0/19"]
  }

  alb_acm     = ""
  zone_id = ""

  aws_account_id = "794293228777"

  aws_region = "ap-northeast-1"

  backend_domain_name = ""

  vpn = {
    vpn_client_cidr        = "20.7.0.0/16"
    client_certificate_arn = "",
    server_certificate_arn = "",
  }
}
