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
