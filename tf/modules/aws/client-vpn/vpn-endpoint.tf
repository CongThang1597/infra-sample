resource "aws_ec2_client_vpn_authorization_rule" "example" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  target_network_cidr    = "10.7.0.0/16"
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_endpoint" "default" {
  description            = "${var.name}-Client-VPN"
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr
  split_tunnel           = var.split_tunnel
  dns_servers            = var.dns_servers

  authentication_options {
    type                       = var.authentication_type
    root_certificate_chain_arn = var.authentication_type != "certificate-authentication" ? null : var.client_certificate_arn
  }

  connection_log_options {
    enabled = false
  }

  tags = merge(
    var.tags,
    tomap({
      "Name"    = "${var.name}-Client-VPN",
      "EnvName" = var.name
    })
  )
}

resource "aws_ec2_client_vpn_network_association" "default" {
  count                  = length(var.subnet_ids)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  subnet_id              = element(var.subnet_ids, count.index)
}

resource "aws_ec2_client_vpn_authorization_rule" "all_groups" {
  count                  = length(var.allowed_access_groups) > 0 ? 0 : length(var.allowed_cidr_ranges)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
  target_network_cidr    = var.allowed_cidr_ranges[count.index]
  authorize_all_groups   = true
}
