locals {
  project            = "rbo"
  environment        = "development"
  aws_image_registry = "872692067237.dkr.ecr.ap-southeast-1.amazonaws.com"

  vpc = {
    cidr            = "10.7.0.0/16" # https://www.ipkeisan.com/subnet/?nw=10.7.0.0&len=16&sub=19
    public_subnets  = ["10.7.0.0/19", "10.7.32.0/19", "10.7.64.0/19"]
    private_subnets = ["10.7.128.0/19", "10.7.160.0/19", "10.7.192.0/19"]
  }

  # Development
  acm     = "arn:aws:acm:ap-southeast-1:872692067237:certificate/72761e50-2119-4aae-9229-66ce5f876bf5"
  zone_id = "Z10100782EHJ2W85PY045"

  aws_account_id = "872692067237"

  aws_region = "ap-southeast-1"

  backend_domain_name = "api.snack.beauty"

  vpn = {
    vpn_client_cidr        = "20.7.0.0/16"
    client_certificate_arn = "",
    server_certificate_arn = "",
  }
}
