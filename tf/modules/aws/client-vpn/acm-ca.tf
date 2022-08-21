#resource "tls_private_key" "ca" {
#  algorithm = "RSA"
#}
#
#resource "tls_self_signed_cert" "ca" {
#  private_key_pem = tls_private_key.ca.private_key_pem
#
#  subject {
#    common_name = "${var.name}.vpn.ca"
#  }
#
#  validity_period_hours = 87600
#  is_ca_certificate     = true
#
#  allowed_uses = [
#    "cert_signing",
#    "crl_signing",
#  ]
#}
#
#resource "aws_acm_certificate" "ca" {
#  private_key      = tls_private_key.ca.private_key_pem
#  certificate_body = tls_self_signed_cert.ca.cert_pem
#
#  provisioner "local-exec" {
#    command = <<-EOT
#      echo "${tls_private_key.ca.private_key_pem}" > ca.key;
#      echo "${tls_self_signed_cert.ca.cert_pem}" > ca.crt;
#    EOT
#  }
#}
