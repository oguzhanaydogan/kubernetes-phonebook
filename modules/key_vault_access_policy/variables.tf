variable "key_vault_name" {
  type = string
}

variable "key_vault_resource_group_name" {
  type = string
}

variable "key_permissions" {
  type = list(string)
}

variable "secret_permissions" {
  type = list(string)
}

variable "object_id" {
  type = string // TODO: Hallet
}