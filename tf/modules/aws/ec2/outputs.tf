output "instance-private-ip" {
  value = aws_instance.instance.private_ip
}

output "instance-public-ip" {
  value = aws_instance.instance.public_ip
}
