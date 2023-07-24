variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type = string
}

variable "frontend_ip_configurations" {
  type = map(object({
    name = string
    subnet = object({
      name                 = string
      virtual_network_name = string
      resource_group_name  = string
    })
  }))
}

variable "lb_backend_address_pools" {
  type = map(object({
    name = string
  }))
}

variable "lb_probes" {
  type = map(object({
    name     = string
    protocol = string
    port     = string
  }))
}

variable "lb_rules" {
  type = map(object({
    name                           = string
    probe                          = string
    backend_address_pools          = list(string)
    frontend_ip_configuration_name = string
    protocol                       = string
    frontend_port                  = string
    backend_port                   = string
  }))
}

variable "private_link_service" {
  default = {
    name                  = ""
    nat_ip_configurations = {}
  }
  type = object({
    name = string
    nat_ip_configurations = map(object({
      name = string
      subnet = object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      })
      primary = bool
    }))
  })
}