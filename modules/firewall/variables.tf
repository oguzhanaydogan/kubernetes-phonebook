variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "firewall_policy" {
  default = null
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "virtual_hub" {
  default = null
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "ip_configuration" {
  default = null
  type = object({
    name = string
    subnet = object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    })
  })
}

variable "management_ip_configuration" {
  default = null
  type = object({
    enabled = bool
    name    = optional(string, "")
    subnet = optional(object({
      virtual_network_name = string
      resource_group_name  = string
    }), null)
    public_ip_address = optional(object({
      name                = string
      resource_group_name = string
    }), null)
  })
}

variable "firewall_network_rule_collections" {
  default = null
  type = map(object({
    name     = string
    priority = number
    action   = string
    firewall_network_rules = map(object({
      name                  = string
      source_addresses      = list(string)
      destination_ports     = list(string)
      destination_addresses = list(string)
      protocols             = list(string)
    }))
  }))
}