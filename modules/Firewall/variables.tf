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

variable "virtual_hub" {
  default = {}
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "ip_configuration" {
  default = {
    name = ""
    subnet = {
      name                 = ""
      virtual_network_name = ""
      resource_group_name  = ""
    }
  }
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
  default = {
    enabled = false
  }
  type = object({
    enabled = bool
    name    = optional(string, "")
    subnet = optional(object({
      virtual_network_name = string
      resource_group_name  = string
    }), {
      virtual_network_name = ""
      resource_group_name = ""
    })
    public_ip_address = optional(object({
      name                = string
      resource_group_name = string
    }), {
      name = ""
      resource_group_name = ""
    })
  })
}

variable "firewall_network_rule_collections" {
  default = {
    name = ""
    priority = 0
    action = ""
    firewall_network_rules = {}
  }
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