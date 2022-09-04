provider "aws" {
  region  = "ap-southeast-1"
  profile = "default"
  default_tags {
    tags = {
      Project    = "rbo"
      Env        = "development"
      Repository = "https://git.vmo.dev/c12/rbo22077-rbo-blockchain/rbo-dev/rbo-backend"
    }
  }
}
