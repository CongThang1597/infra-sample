output "main" {
  value = {
    ecr = {
      backend = module.rbo-backend-ecr.repository_url
    },
    acm = {
      certificate_arn     = module.acm.certificate_arn,
      zone_id             = module.acm.zone_id
      alb_certificate_arn = module.acm_alb.certificate_arn
    }
  }
}
