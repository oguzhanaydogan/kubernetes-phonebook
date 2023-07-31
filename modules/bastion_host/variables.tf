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
    subnet = object({
      existing = optional(object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      }), null)
      new = optional(any, null) // Pass directly to the 'subnet' module
    })
    public_ip_address = object({
      existing = optional(object({
        name                = string
        resource_group_name = string
      }), null)
      new = optional(any, null) // Pass directly to the 'public_ip_address' module
    })
  })
  validation {
    condition     = (
      (var.ip_configuration.subnet.existing != null && var.ip_configuration.subnet.new == null) ||
      (var.ip_configuration.subnet.existing == null && var.ip_configuration.subnet.new != null)
    )
    error_message = "Exactly one of the 'existing' and 'new' variables of the 'subnet' variable should have a value."
  }
  validation {
    condition     = (
      (var.ip_configuration.public_ip_address.existing != null && var.ip_configuration.public_ip_address.new == null) ||
      (var.ip_configuration.public_ip_address.existing == null && var.ip_configuration.public_ip_address.new != null)
    )
    error_message = "Exactly one of the 'existing' and 'new' variables of the 'public_ip_address' variable should have a value."
  }
}