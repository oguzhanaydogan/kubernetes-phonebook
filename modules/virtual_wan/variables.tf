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
    default_route_table_routes = optional(map(object({
      name              = string
      route_table = string
      destinations_type = string
      destinations      = list(string)
      next_hop_type     = string
      next_hop = object({
        firewall = optional(object({
          name                = string
          resource_group_name = string
        }), null)
        connection_name = optional(string)
      })
    })), {})
  }))
}