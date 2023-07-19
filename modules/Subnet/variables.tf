variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}
variable "virtual_network_name" {
  type = string
}

variable "address_prefixes" {
  type = list(string)
}

variable "private_link_service_network_policies_enabled" {
  type = bool
}

variable "delegation" {
  type = object({
    name = string
    service_delegation = object({
      name    = string
      actions = optional(list(string))
    })
  })
}