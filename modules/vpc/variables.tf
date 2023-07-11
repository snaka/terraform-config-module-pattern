variable "conf" {
  type = object({
    prefix = string
    env = string
    v = any
  })
  description = "values of configuration"
}
