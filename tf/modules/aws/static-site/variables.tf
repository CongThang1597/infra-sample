variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "target_domain_name" {
  description = "Endpoint url"
  type        = string
}

variable "root_domain_name" {
  description = "Domain name"
  type        = string
}

variable "zone_id" {
  type = string
}

variable "acm_arn" {
  type = string
}
