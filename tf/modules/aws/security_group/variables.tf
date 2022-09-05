variable "vpc_id" {
  type = string
}

variable "alb_sg_name" {
  type = string
}

variable "common_sg_name" {
  type = string
}

variable "internal_sg_name" {
  type = string
}

variable "cidr_blocks" {
  type = string
}

variable "client_cidr_blocks" {
  type = string
}

variable "ssh_sg_name" {
  type = string
}
