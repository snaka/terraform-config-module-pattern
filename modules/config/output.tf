output "prefix" {
  value = local.prefix
}
output "v" {
  value = local.merged_conf
  description = "Configuraion values according to environment which is to constructed"
}

output "env" {
  value = local.env
  description = "Environment name"
}

output "account_id" {
  value = local.account_id
  description = "AWS account ID"
}
