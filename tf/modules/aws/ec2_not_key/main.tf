data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_address]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = var.ami_owners
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ami.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_id
  vpc_security_group_ids      = var.security_groups
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_size           = var.volume_size
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }
}
