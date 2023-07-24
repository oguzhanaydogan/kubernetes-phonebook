variable "key_vault" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "key_permissions" {
  type = list(string)
}

variable "secret_permissions" {
  type = list(string)
}

variable "object" {
  type = object({
    type = string
    name = string
  })
  description = "Possible type values are 'security-group', 'service-principal', 'user'"
}