locals {
  project            = "rbo"
  environment        = "development"
  aws_image_registry = "872692067237.dkr.ecr.ap-southeast-1.amazonaws.com"

  vpc = {
    cidr            = "10.7.0.0/16" # https://www.ipkeisan.com/subnet/?nw=10.7.0.0&len=16&sub=19
    public_subnets  = ["10.7.0.0/19", "10.7.32.0/19", "10.7.64.0/19"]
    private_subnets = ["10.7.128.0/19", "10.7.160.0/19", "10.7.192.0/19"]
  }

  alb_acm     = ""
  zone_id = ""

  aws_account_id = "872692067237"

  aws_region = "ap-southeast-1"

  backend_domain_name = "api."

  vpn = {
    vpn_client_cidr        = "20.7.0.0/16"
    client_certificate_arn = "arn:aws:acm:ap-southeast-1:872692067237:certificate/81b3efeb-8c94-42ce-8347-488541b7f7b2",
    server_certificate_arn = "arn:aws:acm:ap-southeast-1:872692067237:certificate/8415b473-5e7e-42b6-a9f0-c12effd47339",
  }
}
