output "main" {
  sensitive = true
  value = {
#    configuration_endpoint_address = module.elastic_cache.configuration_endpoint_address
    #    ecr = {
    #      backend = module.rbo-backend-ecr.repository_url
    #    },
    #    acm: module.acm.certificate_arn
#    vpn_client_cert : module.client-vpn.vpn_client_cert,
#    vpn_client_key : module.client-vpn.vpn_client_key,
#    vpn_endpoint_id : module.client-vpn.vpn_endpoint_id,
  }
}
