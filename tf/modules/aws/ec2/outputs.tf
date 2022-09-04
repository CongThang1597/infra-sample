output "instance-private-ip" {
  value = aws_instance.instance.private_ip
}

output "instance-public-ip" {
  value = aws_instance.instance.public_ip
}

output "ec2_arn" {
  value = aws_instance.instance.arn
}

output "ec2-sg" {
  value = aws_security_group.sg.id
}
