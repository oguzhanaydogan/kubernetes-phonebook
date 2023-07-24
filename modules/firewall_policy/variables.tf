variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type = string
}

variable "rule_collection_groups" {
  default = null
  type = map(object({
    name     = string
    priority = number
    network_rule_collections = optional(map(object({
      name     = string
      priority = number
      action   = string
      rules = optional(map(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
      })), {})
    })), {})
  }))
}