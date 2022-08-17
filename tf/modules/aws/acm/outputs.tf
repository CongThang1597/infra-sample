output "certificate_arn" {
  value = aws_acm_certificate.ssl_certificate.arn
}

output "zone_id" {
  value = data.aws_route53_zone.root.zone_id
}
