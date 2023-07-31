variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
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
    existing = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    new = optional(any, null) // Pass it directly to the 'firewall_policy' module
  })
  validation {
    condition     = var.firewall_policy == null || ((var.firewall_policy.existing != null && var.firewall_policy.new == null) || (var.firewall_policy.existing == null && var.firewall_policy.new != null))
    error_message = "Exactly one of the 'existing' and 'new' variables in the 'firewall_policy' variable should have a value."
  }
}

variable "ip_configuration" {
  default = null
  type = object({
    name = string
    subnet = object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null) // Pass it directly to the 'subnet' module
    })
    public_ip_address = optional(object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null) // Pass it directly to the 'public_ip_address' module
    }), null)
  })
  # Either 'ip_configuration' is null, or exactly one of 'existing subnet' and 'new subnet' has a value
  validation {
    condition     = var.ip_configuration == null || ((try(var.ip_configuration.subnet.existing, null) != null && try(var.ip_configuration.subnet.new, null) == null) || (try(var.ip_configuration.subnet.existing, null) == null && try(var.ip_configuration.subnet.new, null) != null))
    error_message = "Exactly one of the 'existing' and 'new' variables in the 'subnet' variable should have a value."
  }
  # Either 'ip_configuration' is null, or 'ip_configuration.public_ip_address' is null, or both of 'existing subnet' and 'new subnet' don't have values at the same time
  validation {
    condition     = var.ip_configuration == null || try(var.ip_configuration.public_ip_address, null) == null || !(try(var.ip_configuration.public_ip_address.existing, null) != null && try(var.ip_configuration.public_ip_address.new, null) != null)
    error_message = "At most one of the 'existing' and 'new' variables in the 'public_ip_address' variable can have a value."
  }
}

variable "management_ip_configuration" {
  default = null
  type = object({
    name = string
    subnet = object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null) // Pass it directly to the 'subnet' module
    })
    public_ip_address = object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null) // Pass it directly to the 'public_ip_address' module
    })
  })
  # Either 'management_ip_configuration' is null, or exactly one of 'existing subnet' and 'new subnet' has a value
  validation {
    condition     = var.management_ip_configuration == null || ((try(var.management_ip_configuration.subnet.existing, null) != null && try(var.management_ip_configuration.subnet.new, null) == null) || (try(var.management_ip_configuration.subnet.existing, null) == null && try(var.management_ip_configuration.subnet.new, null) != null))
    error_message = "Exactly one of the 'existing' and 'new' variables in the 'subnet' variable should have a value."
  }
  # Either 'management_ip_configuration' is null, or exactly one of 'existing public IP address' and 'new public IP address' has a value
  validation {
    condition     = var.management_ip_configuration == null || ((try(var.management_ip_configuration.public_ip_address.existing, null) != null && try(var.management_ip_configuration.public_ip_address.new, null) == null) || (try(var.management_ip_configuration.public_ip_address.existing, null) == null && try(var.management_ip_configuration.public_ip_address.new, null) != null))
    error_message = "Exactly one of the 'existing' and 'new' variables in the 'public_ip_address' variable should have a value."
  }
}

variable "virtual_hub" {
  default = null
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "firewall_network_rule_collections" {
  default = {}
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