terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.10"
    }
  }

  backend "s3" {
    bucket         = "rbo-check-ag-local-development-tfstate"
    region         = "ap-southeast-1"
    key            = "terraform-backend-backend.tfstate"
    encrypt        = true
    profile        = "default"
  }
}
