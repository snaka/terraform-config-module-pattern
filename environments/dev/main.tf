provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment        = module.config.env
      TerraformWorkspace = terraform.workspace
    }
  }
}

module "config" {
  source = "../../modules/config"
}

module "vpc" {
  source = "../../modules/vpc"
  conf   = module.config
}
