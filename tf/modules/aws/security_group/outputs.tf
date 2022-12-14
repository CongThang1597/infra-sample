output "ids" {
  value = [
    aws_security_group.alb.id,
    aws_security_group.common.id,
  ]
}

output "common_id" {
  value = aws_security_group.common.id
}

output "alb_id" {
  value = aws_security_group.alb.id
}

output "internal_id" {
  value = aws_security_group.internal.id
}

output "ssh_id" {
  value = aws_security_group.ssh.id
}
