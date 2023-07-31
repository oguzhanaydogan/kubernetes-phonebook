variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "ip_configuration" {
  type = object({
    name = string
    existing_subnet = optional(object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    }), null)
    new_subnet = optional(any, null) // Just pass it to the 'subnet' module
    existing_public_ip_address = optional(object({
      name                = string
      resource_group_name = string
    }), null)
    new_public_ip_address = optional(any, null) // Just pass it to the 'publi_ip_address' module
  })
  validation {
    condition     = (var.ip_configuration.existing_subnet == null && var.ip_configuration.new_subnet == null) || (var.ip_configuration.existing_subnet != null && var.ip_configuration.new_subnet != null)
    error_message = "Exactly one of 'existing_subnet' and 'new_subnet' variables should have a value."
  }
  validation {
    condition     = (var.ip_configuration.existing_public_ip_address == null && var.ip_configuration.new_public_ip_address == null) || (var.ip_configuration.existing_public_ip_address != null && var.ip_configuration.new_public_ip_address != null)
    error_message = "Exactly one of 'existing_public_ip_address' and 'new_public_ip_address' variables should have a value."
  }
}