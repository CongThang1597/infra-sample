resource "aws_network_interface" "ani" {
  subnet_id       = var.subnet_id
  private_ips     = var.private_ips
  security_groups = var.security_groups

  attachment {
    instance     = var.aws_instance_id
    device_index = var.device_index
  }
}
