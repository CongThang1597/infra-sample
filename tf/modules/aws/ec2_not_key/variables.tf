variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}


variable "volume_size" {
  type    = number
  default = 32
}


variable "key_pair_name" {
  type    = string
  default = "ec2-private-key"
}

variable "ami_address" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220901"
}

variable "ami_owners" {
  type    = list(string)
  default = ["099720109477"]
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "vpc_cidr" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "key_pair_id" {
  type = string
}
