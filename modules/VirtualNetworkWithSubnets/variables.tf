variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    private_link_service_network_policies_enabled = optional(bool, true)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    }),
    {
      name = ""
      service_delegation = {
        name = ""
      }
    })
  }))
  default = {}
}