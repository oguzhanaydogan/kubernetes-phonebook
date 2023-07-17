variable "resource_groups" {
  type = map(object({
    name           = string
    resource_group = string
    address_space  = list(string)
  }))
}

variable "virtual_networks" {
  type = map(object({
    name           = string
    resource_group = string
    address_space  = list(string)
  }))
}

variable "subnets" {
  type = map(object({
    name                                          = string
    resource_group                                = string
    virtual_network                               = string
    address_prefixes                              = list(string)
    delegation                                    = bool
    delegation_name                               = string
    private_link_service_network_policies_enabled = bool
  }))
}

variable "vnet_peerings" {
  type = map(object({
    name                   = string
    virtual_network        = string
    remote_virtual_network = string
    resource_group         = string
  }))
}

variable "route_tables" {
  type = map(object({
    name           = string
    resource_group = string
    routes = map(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
    subnet_associations = map(object({
      subnet_name          = string
      resource_group_name  = string
      virtual_network_name = string
    }))
  }))
}

variable "public_ip_addresses" {
  type = map(object({
    name              = string
    allocation_method = string
    sku               = string
    resource_group    = string
  }))
}

variable "network_security_groups" {
  type = map(object({
    name           = string
    resource_group = string
    security_rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "linux_virtual_machines" {
}

variable "key_vault_access_policies" {
  description = "This is for Terraform"
}
variable "key_vault_secrets" {
}

variable "mssql_servers" {
}

variable "mssql_databases" {
}

variable "load_balancers" {
}

variable "private_link_services" {
}

variable "linux_virtual_machine_scale_sets" {
}

variable "bastion_hosts" {
}

variable "private_dns_zones" {
}

variable "private_endpoints" {
}

variable "front_doors" {
}