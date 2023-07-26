variable "name" {
  type = string
}

variable "key_vault" {
  type = object({
    name                = string
    resource_group_name = string
  })
}