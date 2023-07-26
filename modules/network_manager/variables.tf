variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "scope_accesses" {
  type = list(string)
}

variable "scope" {
  type = object({
    current_subscription_enabled = bool
    other_subscription_ids       = optional(list(string), [])
  })
}

variable "network_groups" {
  default = null
  type = map(object({
    name = string
    policies = map(object({
      name = string
      rule = object({
        effect     = string
        conditions = string
      })
    }))
    connectivity_configurations = map(object({
      name                  = string
      connectivity_topology = string
      applies_to_group = object({
        group_connectivity = string
      })
    }))
  }))
}