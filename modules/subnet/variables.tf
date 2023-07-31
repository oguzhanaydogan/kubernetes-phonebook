variable "name" {
  type = string
}

variable "virtual_network" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "address_prefixes" {
  type = list(string)
}

variable "private_link_service_network_policies_enabled" {
  default = null
  type    = bool
}

variable "delegation" {
  default = null
  type = object({
    name = string
    service_delegation = object({
      name    = string
      actions = optional(list(string), null)
    })
  })
}