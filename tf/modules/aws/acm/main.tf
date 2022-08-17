provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_acm_certificate" "ssl_certificate" {
  provider                  = aws.virginia
  domain_name               = var.root_domain_name
  subject_alternative_names = ["*.${var.root_domain_name}"]
  validation_method         = "DNS"
}

data "aws_route53_zone" "root" {
  name         = var.root_domain_name
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
  for d in aws_acm_certificate.ssl_certificate.domain_validation_options : d.domain_name => {
    name   = d.resource_record_name
    record = d.resource_record_value
    type   = d.resource_record_type
  }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.root.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.virginia
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
