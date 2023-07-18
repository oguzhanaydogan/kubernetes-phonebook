variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
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
    network_interface = object({
      ip_configurations = map(object({
        name = string
        subnet = object({
          name = string
          virtual_network_name = string
          resource_group_name = string
        })
        private_ip_address_allocation = string
        public_ip_assigned            = bool
        public_ip_address = object({
          name                = string
          resource_group_name = string
        })
      }))
    })
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
      custom_data    = string
    })
    os_profile_linux_config = object({
      disable_password_authentication = bool
      ssh_key = object({
        name                = string
        resource_group_name = string
      })
    })
    network_security_group_association = object({
      enabled                                    = bool
      network_security_group_name                = string
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
    key_permissions               = list(string)
    secret_permissions            = list(string)
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
    tags                  = map(string)
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
    name           = string
    resource_group = string
    sku            = string
    frontend_ip_configurations = map(object({
      name = string
      subnet = object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      })
    }))
    lb_backend_address_pools = map(object({
      name = string
    }))
    lb_probes = map(object({
      name     = string
      protocol = string
      port     = string
    }))
    lb_rules = map(object({
      name                           = string
      probe                          = string
      backend_address_pools     = list(string)
      frontend_ip_configuration_name = string
      protocol                       = string
      frontend_port                  = string
      backend_port                   = string
    }))
  }))
}

variable "private_link_services" {
  type = map(object({
    name = string
    resource_group = string
    load_balancer  = string
    nat_ip_configurations = list(object({
      subnet  = string
      name    = string
      primary = bool
    }))
  }))
}

variable "linux_virtual_machine_scale_sets" {
  type = map(object({
    name           = string
    resource_group = string
    sku            = string
    instances      = number
    admin_username = string
    shared_image = object({
      name                = string
      gallery_name        = string
      resource_group_name = string
    })
    upgrade_mode               = string
    health_probe = object({
      name = string
      load_balancer = string
    })
    admin_ssh_key = object({
      resource_group_name = string
      name                = string
    })
    os_disk = object({
      storage_account_type = string
      caching              = string
    })
    network_interface = object({
      name    = string
      primary = bool
      network_security_group = object({
        name                = string
        resource_group_name = string
      })
      ip_configurations = map(object({
        name    = string
        primary = bool
        subnet = object({
          name                 = string
          virtual_network_name = string
          resource_group_name  = string
        })
        load_balancer_backend_address_pools = map(object({
          name                              = string
          load_balancer_name                = string
          load_balancer_resource_group_name = string
        }))
      }))
    })
    rolling_upgrade_policy = object({
      max_batch_instance_percent              = number
      max_unhealthy_instance_percent          = number
      max_unhealthy_upgraded_instance_percent = number
      pause_time_between_batches              = string
    })
  }))
}

variable "bastion_hosts" {
  type = map(object({
    name           = string
    resource_group = string
    ip_configurations = map(object({
      name = string
      subnet = object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      })
      public_ip_address = object({
        name                = string
        resource_group_name = string
      })
    }))
  }))
}

variable "private_dns_zones" {
  type = map(object({
    name           = string
    resource_group = string
    virtual_network_links = map(object({
      name = string
      virtual_network = object({
        name                = string
        resource_group_name = string
      })
    }))
  }))
}

variable "private_endpoints" {
  type = map(object({
    attached_resource = object({
      name          = string
      type          = string
      required_tags = map(string)
    })
    resource_group = string
    subnet         = string
    private_service_connection = object({
      is_manual_connection = bool
      subresource_names    = list(string)
    })
    private_dns_zone_group = object({
      private_dns_zones = list(string)
    })
  }))
}

variable "front_doors" {
  type = map(object({
    name           = string
    resource_group = string
    sku_name       = string
    endpoints      = list(string)
    origin_groups = map(object({
      name                                                      = string
      session_affinity_enabled                                  = bool
      restore_traffic_time_to_healed_or_new_endpoint_in_minutes = number
      health_probes = map(object({
        interval_in_seconds = number
        path                = string
        protocol            = string
        request_type        = string
      }))
      load_balancing = object({
        additional_latency_in_milliseconds = number
        sample_size                        = number
        successful_samples_required        = number
      })
    }))
    origins = map(object({
      name                           = string
      cdn_frontdoor_origin_group     = string
      enabled                        = bool
      certificate_name_check_enabled = bool
      host = object({
        resource_group_name = string
        name                = string
        type                = string
        pls_enabled         = bool
      })
      http_port  = number
      https_port = number
      priority   = number
      weight     = number
      private_link = object({
        request_message = string
        location        = string
        target = object({
          name                = string
          resource_group_name = string
        })
      })
    }))
    routes = map(object({
      name                       = string
      cdn_frontdoor_endpoint     = string
      cdn_frontdoor_origin_group = string
      cdn_frontdoor_origins      = list(string)
      # cdn_frontdoor_rule_sets       = list(string)
      enabled                = bool
      forwarding_protocol    = string
      https_redirect_enabled = bool
      patterns_to_match      = list(string)
      supported_protocols    = list(string)
    }))
    # rule_sets = map(object({
    #   name = string
    # }))
    # rules = list(object({
    #   name = string
    #   rule_set = string
    #   conditions = object({
    #     request_scheme_conditions = map(object({
    #       operator         = string
    #       match_values     = list(string)
    #     }))
    #   })
    #   actions = object({
    #     url_redirect_actions = map(object({
    #       redirect_type        = string
    #       redirect_protocol    = string
    #       destination_hostname = string
    #     }))
    #   })
    # }))
  }))
}