output "main" {
  sensitive = true
  value = {
    #    ecr = {
    #      backend = module.rbo-backend-ecr.repository_url
    #    },
    #    acm: module.acm.certificate_arn
#    vpn_client_cert : module.client-vpn.vpn_client_cert,
#    vpn_client_key : module.client-vpn.vpn_client_key,
#    vpn_endpoint_id : module.client-vpn.vpn_endpoint_id,
  }
}
