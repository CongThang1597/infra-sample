output "id" {
  value = aws_instance.instance.id
}

output "instance-private-ip" {
  value = aws_instance.instance.private_ip
}

output "instance-public-ip" {
  value = aws_instance.instance.public_ip
}

output "ec2_arn" {
  value = aws_instance.instance.arn
}

output "ec2_subnet_id" {
  value = aws_instance.instance.subnet_id
}

output "ec2_instance_id" {
  value = aws_instance.instance.id
}
