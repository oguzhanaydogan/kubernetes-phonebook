variable "resource_groups" {
  type = map(object({
    name           = string
    location       = string
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
  type = map(object({
    name                             = string
    resource_group                   = string
    size                             = string
    delete_data_disks_on_termination = bool
    delete_os_disk_on_termination    = bool
    identity = object({
      enabled = bool
      type    = string
    })
    storage_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    storage_os_disk = object({
      caching           = string
      create_option     = string
      managed_disk_type = string
    })
    os_profile = object({
      admin_username = string
      custom_data = string 
    })
    os_profile_linux_config = object({
      disable_password_authentication = bool
      ssh_key = object({
        name = string
        resource_group_name = string 
      }) 
    })
    ip_configurations = map(object({
      name = string
      subnet = object({
        name = string
        virtual_network_name = string
        resource_group_name = string 
      })
      private_ip_address_allocation = string
      public_ip_assigned = bool
      public_ip_address = object({
        name = string
        resource_group_name = string
      })
    }))
    network_security_group_association = object({
      enabled = bool
      network_security_group_name = string
      network_security_group_resource_group_name = string 
    })
  }))
}

variable "key_vault_access_policies" {
  description = "This is for Terraform"
  type = map(object({
    key_vault_name                = string
    key_vault_resource_group_name = string
    key_vault_access_owner        = string
    key_permissions = list(string)
    secret_permissions = list(string)
  }))
  
}
variable "key_vault_secrets" {
  type = map(object({
    key_vault_name                = string
    key_vault_resource_group_name = string
    secret_name                   = string
  }))
}

variable "mssql_servers" {
  type = map(object({
    name                  = string
    resource_group        = string
    administrator_login   = string
    admin_password_secret = string
    tags = map(string)
  }))
}

variable "mssql_databases" {
  type = map(object({
    name                        = string
    server                      = string
    collation                   = string
    max_size_gb                 = number
    sku_name                    = string
    min_capacity                = number
    auto_pause_delay_in_minutes = number
    read_replica_count          = number
    read_scale                  = bool
    zone_redundant              = bool
  }))
}

variable "load_balancers" {
  type = map(object({
    name = string
    resource_group                   = string
    sku                              = string
    frontend_ip_configurations   = map(object({
      name = string
      subnet = object({
        name = string
        virtual_network_name = string
        resource_group_name = string
      })
    }))
    lb_backend_address_pool_name     = string
    lb_probe_name                    = string
    lb_probe_protocol                = string
    lb_probe_port                    = string
    lb_rule_name                     = string
  }))
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