locals {
  project            = "rbo"
  environment        = "staging"
  aws_image_registry = "794293228777.dkr.ecr.ap-northeast-1.amazonaws.com"

  vpc = {
    cidr            = "10.7.0.0/16" # https://www.ipkeisan.com/subnet/?nw=10.7.0.0&len=16&sub=19
    public_subnets  = ["10.7.0.0/19", "10.7.32.0/19", "10.7.64.0/19"]
    private_subnets = ["10.7.128.0/19", "10.7.160.0/19", "10.7.192.0/19"]
  }

  alb_acm = "arn:aws:acm:ap-northeast-1:794293228777:certificate/c9e078a9-76a2-496f-85da-b823b07e365a"
  zone_id = "Z0385594DZ7HIG1O2YUI"

  aws_account_id = "794293228777"

  aws_region = "ap-northeast-1"

  backend_domain_name = "api.staging-cvalue.jp"

  vpn = {
    vpn_client_cidr        = "20.7.0.0/16"
    server_certificate_arn = "arn:aws:acm:ap-northeast-1:794293228777:certificate/ec6d3629-81a3-4c0e-8ecb-7070af1764ea",
    client_certificate_arn = "arn:aws:acm:ap-northeast-1:794293228777:certificate/e28cc043-692f-4191-b92d-2397a6f1b5ae",
  }
}
