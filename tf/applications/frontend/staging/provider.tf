provider "aws" {
  region  = "ap-northeast-1"
  profile = "rbo-master"
  default_tags {
    tags = {
      Project    = "rbo"
      Env        = "staging"
      Repository = "https://git.vmo.dev/c12/rbo22077-rbo-blockchain/rbo-dev/rbo-web-admin"
    }
  }
}
