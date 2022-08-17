data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.ami.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.this.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.volume_size
    delete_on_termination = true
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.project}-${var.environment}-${var.instance_name}"
  description = "${var.project}-${var.environment}-${var.instance_name}-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id
}


resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.this.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo "${tls_private_key.this.private_key_pem}" > "${var.key_pair_name}.pem"
    EOT
  }
}
