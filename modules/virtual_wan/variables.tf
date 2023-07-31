variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "virtual_hubs" {
  default = {}
  type = map(object({
    name           = string
    address_prefix = string
    firewall = optional(object({
      existing = optional(object({
        name                = string
        resource_group_name = string
      }), null)
      new = optional(any, null) // Pass directly to 'firewall' module
      firewall_policy = optional(object({
        existing = optional(object({
          name                = string
          resource_group_name = string
        }), null)
        new = optional(any, null) // Pass directly to 'firewall_policy' module
      }), null)
    }), null)
    virtual_hub_connections = optional(map(object({
      name = string
      remote_virtual_network = object({
        name                = string
        resource_group_name = string
      })
      routing = object({
        associated_route_table = string
        propagated_route_tables = list(object({
          name        = string
          virtual_hub = string
        }))
      })
    })), {})
    route_tables = optional(map(object({
      name = string
    })), {})
    route_table_routes = optional(map(object({
      name              = string
      route_table       = string
      destinations_type = string
      destinations      = list(string)
      next_hop_type     = string
      next_hop = object({
        firewall = optional(object({
          name                = string
          resource_group_name = string
        }))
        connection_name = optional(string, "")
      })
    })), {})
  }))
}