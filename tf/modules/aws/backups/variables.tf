variable "action_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "backup_service_role_arn" {
  type = string
}

variable "schedule" {
  type    = string
  default = "cron(0 12 * * ? *)"
}


variable "selection_resources" {
  type    = list(string)
  default = []
}
