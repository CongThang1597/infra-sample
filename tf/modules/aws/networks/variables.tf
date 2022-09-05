variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "private_ips" {
  type = list(string)
}

variable "device_index" {
  type    = number
  default = 0
}

variable "aws_instance_id" {
  type = string
}
