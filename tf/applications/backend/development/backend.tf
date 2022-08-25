terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.10"
    }
  }

  backend "s3" {
    bucket         = "rbo-s3-development-tfstate"
    region         = "ap-northeast-1"
    key            = "terraform-s3-backend.tfstate"
    encrypt        = true
    profile        = "rbo-master"
  }
}
