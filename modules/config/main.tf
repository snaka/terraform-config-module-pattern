data "aws_caller_identity" "current" {}

locals {
  prefix = "example"
  env_root_path = coalesce(var.env_root_path, path.root)

  common_conf = yamldecode(file("${local.env_root_path}/../../config.yml"))
  env_conf = yamldecode(file("${local.env_root_path}/config.yml"))
  merged_conf = merge(local.common_conf, local.env_conf)

  env = basename(abspath(local.env_root_path))

  account_id = data.aws_caller_identity.current.account_id
}
