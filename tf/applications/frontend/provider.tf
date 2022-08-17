provider "aws" {
  alias = "default"
  region  = "ap-southeast-1"
  profile = "default"
  default_tags {
    tags = {
      Project    = "rbo"
      Env        = "development"
      Repository = "https://github.com/congthang1597/infra/tree/main/tf/initial/development"
    }
  }
}
