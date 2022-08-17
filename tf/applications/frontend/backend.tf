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
    key            = "terraform-static-site.tfstate"
    encrypt        = true
    dynamodb_table = "rbo-check-ag-local-development-tfstate"
    profile        = "default"
  }
}
