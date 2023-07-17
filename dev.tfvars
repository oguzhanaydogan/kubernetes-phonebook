resource_groups = {
  rg_eastus = {
    name     = "rg-eastus"
    location = "East Us"
  }
  rg_westeurope = {
    name     = "rg-westeurope"
    location = "West Europe"
  }
}

virtual_networks = {
  vnet_hub = {
    name           = "vnet-hub"
    resource_group = "rg_eastus"
    address_space  = ["10.0.0.0/16"]
  }
  vnet_app = {
    name           = "vnet-app"
    resource_group = "rg_eastus"
    address_space  = ["10.1.0.0/16"]
  }
  vnet_acr = {
    name           = "vnet-acr"
    resource_group = "rg_eastus"
    address_space  = ["10.2.0.0/16"]
  }
  vnet_db = {
    name           = "vnet-db"
    resource_group = "rg_eastus"
    address_space  = ["10.3.0.0/16"]
  }
  vnet_agent = {
    name           = "vnet-agent"
    resource_group = "rg_eastus"
    address_space  = ["10.4.0.0/16"]
  }
  vnet_app_eu = {
    name           = "vnet-app-eu"
    resource_group = "rg_westeurope"
    address_space  = ["10.11.0.0/16"]
  }
  vnet_db_eu = {
    name           = "vnet-db-eu"
    resource_group = "rg_westeurope"
    address_space  = ["10.12.0.0/16"]
  }
}

subnets = {
  vnet_hub_subnet_firewall = {
    name                                          = "AzureFirewallSubnet"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_hub"
    address_prefixes                              = ["10.0.0.0/26"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_hub_subnet_firewall_management = {
    name                                          = "AzureFirewallSubnetManagement"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_hub"
    address_prefixes                              = ["10.0.1.0/26"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_app_subnet_app = {
    name                                          = "subnet-app"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_app"
    address_prefixes                              = ["10.1.0.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_acr_subnet_acr = {
    name                                          = "subnet-acr"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_acr"
    address_prefixes                              = ["10.2.0.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_db_subnet_db = {
    name                                          = "subnet-db"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_db"
    address_prefixes                              = ["10.3.0.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_db_subnet_db_pep = {
    name                                          = "subnet-db-pep"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_db"
    address_prefixes                              = ["10.3.1.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_agent_subnet_agent = {
    name                                          = "subnet-agent"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_agent"
    address_prefixes                              = ["10.4.0.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_app_eu_subnet_app = {
    name                                          = "subnet-app"
    resource_group                                = "rg_westeurope"
    virtual_network                               = "vnet_app_eu"
    address_prefixes                              = ["10.11.0.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_app_eu_subnet_lb = {
    name                                          = "subnet-lb"
    resource_group                                = "rg_westeurope"
    virtual_network                               = "vnet_app_eu"
    address_prefixes                              = ["10.11.1.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_app_eu_subnet_lb_pls = {
    name                                          = "subnet-lb-pls"
    resource_group                                = "rg_westeurope"
    virtual_network                               = "vnet_app_eu"
    address_prefixes                              = ["10.11.2.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = false
  }
  vnet_app_eu_subnet_lb_pls_pep = {
    name                                          = "subnet-lb-pls-pep"
    resource_group                                = "rg_westeurope"
    virtual_network                               = "vnet_app_eu"
    address_prefixes                              = ["10.11.4.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_app_eu_subnet_bastion = {
    name                                          = "AzureBastionSubnet"
    resource_group                                = "rg_westeurope"
    virtual_network                               = "vnet_app_eu"
    address_prefixes                              = ["10.11.3.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_db_eu_subnet_db = {
    name                                          = "subnet-db"
    resource_group                                = "rg_westeurope"
    virtual_network                               = "vnet_db_eu"
    address_prefixes                              = ["10.12.0.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_db_eu_subnet_db_pep = {
    name                                          = "subnet-db-pep"
    resource_group                                = "rg_westeurope"
    virtual_network                               = "vnet_db_eu"
    address_prefixes                              = ["10.12.1.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
}

vnet_peerings = {
  db_hub = {
    name                   = "db-hub"
    virtual_network        = "vnet_db"
    remote_virtual_network = "vnet_hub"
    resource_group         = "rg_eastus"
  }
  hub_db = {
    name                   = "hub-db"
    virtual_network        = "vnet_hub"
    remote_virtual_network = "vnet_db"
    resource_group         = "rg_eastus"
  }
  app_hub = {
    name                   = "app-hub"
    virtual_network        = "vnet_app"
    remote_virtual_network = "vnet_hub"
    resource_group         = "rg_eastus"
  }
  hub_app = {
    name                   = "hub-app"
    virtual_network        = "vnet_hub"
    remote_virtual_network = "vnet_app"
    resource_group         = "rg_eastus"
  }
  acr_hub = {
    name                   = "acr-hub"
    virtual_network        = "vnet_acr"
    remote_virtual_network = "vnet_hub"
    resource_group         = "rg_eastus"
  }
  hub_acr = {
    name                   = "hub-acr"
    virtual_network        = "vnet_hub"
    remote_virtual_network = "vnet_acr"
    resource_group         = "rg_eastus"
  }
  db_dbeu = {
    name                   = "db-dbeu"
    virtual_network        = "vnet_db"
    remote_virtual_network = "vnet_db_eu"
    resource_group         = "rg_eastus"
  }
  dbeu_db = {
    name                   = "dbeu-db"
    virtual_network        = "vnet_db_eu"
    remote_virtual_network = "vnet_db"
    resource_group         = "rg_westeurope"
  }
  appeu_dbeu = {
    name                   = "appeu-dbeu"
    virtual_network        = "vnet_app_eu"
    remote_virtual_network = "vnet_db_eu"
    resource_group         = "rg_westeurope"
  }
  dbeu_appeu = {
    name                   = "dbeu-appeu"
    virtual_network        = "vnet_db_eu"
    remote_virtual_network = "vnet_app_eu"
    resource_group         = "rg_westeurope"
  }
}

route_tables = {
  vnet_app_subnet_app = {
    name           = "vnet-app-subnet-app"
    resource_group = "rg_eastus"
    routes = {
      vnet_app_subnet_app_to_vnet_acr_subnet_acr = {
        name                   = "vnet-app-subnet-app-to-vnet-acr-subnet-acr"
        address_prefix         = "10.2.0.0/24"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.0.4"
      }
      vnet_app_subnet_app_to_vnet_db_subnet_db = {
        name                   = "vnet-app-subnet-app-to-vnet-db-subnet-db"
        address_prefix         = "10.3.0.0/24"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.0.4"
      }
    }
    subnet_associations = {
      vnet_app_subnet_app = {
        subnet_name          = "subnet-app"
        resource_group_name  = "rg-eastus"
        virtual_network_name = "vnet-app"
      }
    }
  }
  vnet_app_subnet_db = {
    name           = "vnet-app-subnet-db"
    resource_group = "rg_eastus"
    routes = {
      vnet_db_subnet_db_to_vnet_app_subnet_app = {
        name                   = "vnet-db-subnet-db-to-vnet-app-subnet-app"
        address_prefix         = "10.1.0.0/24"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.0.4"
      }
    }
    subnet_associations = {
      vnet_db_subnet_db = {
        subnet_name          = "subnet-db"
        resource_group_name  = "rg-eastus"
        virtual_network_name = "vnet-db"
      }
    }
  }
  vnet_app_subnet_acr = {
    name           = "vnet-app-subnet-acr"
    resource_group = "rg_eastus"
    routes = {
      vnet_acr_subnet_acr_to_everywhere = {
        name                   = "vnet-acr-subnet-acr-to-everywhere"
        address_prefix         = "10.0.0.0/8"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.4.0.4"
      }
    }
    subnet_associations = {
      vnet_acr_subnet_acr = {
        subnet_name          = "vnet_acr_subnet_acr"
        resource_group_name  = "rg-eastus"
        virtual_network_name = "vnet-acr"
      }
    }
  }
}

# acrs = {
#   coyhub = {
#     sku                           = "Premium"
#     admin_enabled                 = false
#     public_network_access_enabled = false
#     network_rule_bypass_option    = "None"
#     resource_group                = "rg-eastus"
#   }
# }

public_ip_addresses = {
  hub_firewall_management = {
    name              = "hub-firewall-management"
    allocation_method = "Dynamic"
    sku               = "Standard"
    resource_group    = "rg_eastus"
  }
  ci_cd_agent = {
    name              = "ci-cd-agent"
    allocation_method = "Static"
    sku               = "Standard"
    resource_group    = "rg_eastus"
  }
  bastion_host_eu = {
    name              = "bastion-host-eu"
    allocation_method = "Dynamic"
    sku               = "Standard"
    resource_group    = "rg_westeurope"
  }
}

network_security_groups = {
  ssh = {
    name           = "ssh"
    resource_group = "rg_eastus"
    security_rules = {
      allowssh = {
        name                       = "AllowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
  ssh_and_http = {
    name           = "ssh-and-http"
    resource_group = "rg_westeurope"
    security_rules = {
      allowssh = {
        name                       = "AllowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
      allowhttp = {
        name                       = "AllowHTTP"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
}

linux_virtual_machines = {
  ci_cd_agent = {
    name                                                    = "ci-cd-agent"
    resource_group                                          = "rg-eastus"
    size                                                    = "Standard_B1s"
    delete_data_disks_on_termination                        = true
    delete_os_disk_on_termination                           = true
    identity = {
      enabled                                        = true
      type                                           = "SystemAssigned"
    }
    storage_image_reference = {
      publisher                       = "Canonical"
      offer                           = "UbuntuServer"
      sku                             = "18.04-LTS"
      version                         = "latest"
    }
    storage_os_disk = {
      caching                                 = "ReadWrite"
      create_option                           = "FromImage"
      managed_disk_type                       = "Standard_LRS"
    }
    os_profile = {
      admin_username                                          = "azureuser"
      custom_data                                             = "modules/VirtualMachine/agent.sh"
    }
    os_profile_linux_config = {
      disable_password_authentication = true
      ssh_key = {
        resource_group_name                                 = "ssh-key"
        name                               = "azure"
      }
    }
    ip_configurations = {
      ipConfiguration1 = {
        name = "ipConfiguration1"
        subnet = {
          name                 = "vnet-agent-subnet-agent"
          virtual_network_name = "vnet-agent"
          resource_group_name  = "rg-eastus"
        }
        private_ip_address_allocation = "Dynamic"
        public_ip_assigned            = true
        public_ip_address = {
          name                = "ci-cd-agent"
          resource_group_name = "rg-eastus"
        }
      }
    }
    network_security_group_association = {
      enabled = true
      network_security_group_name = "nsg-ssh"
      network_security_group_resource_group_name = "rg-eastus"
    }
  }
}

key_vault_access_policies = {
  key_vault_access_policy_coy_vault = {
    key_vault_name                = "coyvault"
    key_vault_resource_group_name = "ssh-key"
    key_vault_access_owner        = "client_config"
    key_permissions = [
      "Get", "List",
    ]
    secret_permissions = [
      "Get", "List",
    ]
  }
}

key_vault_secrets = {
  key_vault_secret_mssql_password = {
    key_vault_name                = "coyvault"
    key_vault_resource_group_name = "ssh-key"
    secret_name                   = "MSSQLPASSWORD"
  }
}

mssql_servers = {
  coyhub-db-us = {
    resource_group        = "rg-eastus"
    administrator_login   = "azureuser"
    admin_password_secret = "key_vault_secret_mssql_password"
    tags = {
      name = "coyhub-db-us"
    }
  }
  coyhub-db-eu = {
    resource_group        = "rg-westeurope"
    administrator_login   = "azureuser"
    admin_password_secret = "key_vault_secret_mssql_password"
    tags = {
      name = "coyhub-db-eu"
    }
  }
}

mssql_databases = {
  phonebook_us = {
    name                        = "phonebook"
    server                      = "coyhub-db-us"
    collation                   = "SQL_Latin1_General_CP1_CI_AS"
    max_size_gb                 = 32
    sku_name                    = "GP_S_Gen5_1"
    min_capacity                = 0.5
    auto_pause_delay_in_minutes = 60
    read_replica_count          = 0
    read_scale                  = false
    zone_redundant              = false
  }

  phonebook_eu = {
    name                        = "phonebook"
    server                      = "coyhub-db-eu"
    collation                   = "SQL_Latin1_General_CP1_CI_AS"
    max_size_gb                 = 32
    sku_name                    = "GP_S_Gen5_1"
    min_capacity                = 0.5
    auto_pause_delay_in_minutes = 60
    read_replica_count          = 0
    read_scale                  = false
    zone_redundant              = false
  }
}

load_balancers = {
  phonebook-lb = {
    resource_group                   = "rg-westeurope"
    sku                              = "Standard"
    frontend_ip_configuration_name   = "internal"
    frontend_ip_configuration_subnet = "vnet_app_eu_subnet_lb"
    lb_backend_address_pool_name     = "backend-pool"
    lb_probe_name                    = "probe-http"
    lb_probe_protocol                = "Tcp"
    lb_probe_port                    = "80"
    lb_rule_name                     = "rule-http"
  }
}

private_link_services = {
  phonebook-lb-pls = {
    resource_group = "rg-westeurope"
    load_balancer  = "phonebook-lb"
    nat_ip_configurations = [
      {
        subnet  = "vnet_app_eu_subnet_lb_pls"
        name    = "primary"
        primary = true
      }
    ]
  }
}

linux_virtual_machine_scale_sets = {
  app-vmss = {
    ssh_key_rg                       = "ssh-key"
    ssh_key_name                     = "azure"
    shared_image_name                = "myimagedefinitongen"
    shared_image_gallery_name        = "mygallery"
    shared_image_resource_group_name = "ssh-key"
    resource_group                   = "rg-westeurope"
    sku                              = "Standard_B1s"
    instances                        = 2
    admin_username                   = "azureuser"
    load_balancer                    = "phonebook-lb"
    os_disk_storage_account_type     = "Standard_LRS"
    os_disk_caching                  = "ReadWrite"
    network_interface_name           = "example"
    network_interface_primary        = true
    network_security_group           = "nsg-ssh-and-http"
    ip_configuration_name            = "internal"
    ip_configuration_primary         = true
    ip_configuration_subnet          = "vnet_app_eu_subnet_app"
    ip_configuration_load_balancer   = "phonebook-lb"
  }
}

bastion_hosts = {
  bastion-eu = {
    resource_group    = "rg-westeurope"
    subnet            = "vnet_app_eu_subnet_bastion"
    public_ip_address = "public-ip-bastion-eu"
  }
}

private_dns_zones = {
  db = {
    name           = "privatelink.database.windows.net"
    resource_group = "rg-eastus"
    virtual_network_links = {
      zone_db_to_vnet_db = {
        virtual_network_name                = "vnet-db"
        virtual_network_resource_group_name = "rg-eastus"
        link_name                           = "zone-db-to-vnet-db"
        dns_zone_resource_group_name        = "rg-eastus"
      }
      zone_db_to_vnet_db_eu = {
        virtual_network_name                = "vnet-db-eu"
        virtual_network_resource_group_name = "rg-westeurope"
        link_name                           = "zone-db-to-vnet-db-eu"
        dns_zone_resource_group_name        = "rg-eastus"
      }
      zone_db_to_vnet_app = {
        virtual_network_name                = "vnet-app"
        virtual_network_resource_group_name = "rg-eastus"
        link_name                           = "zone-db-to-vnet-app"
        dns_zone_resource_group_name        = "rg-eastus"
      }
      zone_db_to_vnet_app_eu = {
        virtual_network_name                = "vnet-app-eu"
        virtual_network_resource_group_name = "rg-westeurope"
        link_name                           = "zone-db-to-vnet-app-eu"
        dns_zone_resource_group_name        = "rg-eastus"
      }
    }
  }
}

private_endpoints = {
  pep_db = {
    resource_group         = "rg-eastus"
    attached_resource_type = "Microsoft.Sql/servers"
    attached_resource_required_tags = {
      name = "coyhub-db-us"
    }
    attached_resource    = "coyhub-db-us"
    is_manual_connection = false
    subnet               = "vnet_db_subnet_db_pep"
    private_dns_zones    = ["db"]
    subresource_names    = ["sqlServer"]
  }
  pep_db_eu = {
    resource_group         = "rg-westeurope"
    attached_resource_type = "Microsoft.Sql/servers"
    attached_resource_required_tags = {
      name = "coyhub-db-eu"
    }
    attached_resource    = "coyhub-db-eu"
    is_manual_connection = false
    subnet               = "vnet_db_eu_subnet_db_pep"
    private_dns_zones    = ["db"]
    subresource_names    = ["sqlServer"]
  }
}

front_doors = {
  front_door_1 = {
    name           = "front-door-1"
    resource_group = "rg-eastus"
    sku_name       = "Premium_AzureFrontDoor"
    endpoints      = ["phonebook"]
    origin_groups = {
      phonebook-origin-group = {
        name                                                      = "phonebook-origin-group"
        session_affinity_enabled                                  = false
        restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
        health_probes = {
          health_probe_http = {
            interval_in_seconds = 240
            path                = "/healthProbe"
            protocol            = "Http"
            request_type        = "GET"
          }
        }
        load_balancing = {
          additional_latency_in_milliseconds = 0
          sample_size                        = 16
          successful_samples_required        = 3
        }
      }
    }
    origins = {
      phonebook-eu = {
        name                           = "phonebook-eu"
        cdn_frontdoor_origin_group     = "phonebook-origin-group"
        enabled                        = true
        certificate_name_check_enabled = true
        host = {
          resource_group_name = "rg-westeurope"
          name                = "phonebook-lb"
          type                = "Microsoft.Network/loadBalancers"
          pls_enabled         = true
        }
        http_port  = 80
        https_port = 443
        priority   = 1
        weight     = 500
        private_link = {
          request_message = "Gimme gimme"
          location        = "West Europe"
          target = {
            name                = "phonebook-lb-pls"
            resource_group_name = "rg-westeurope"
          }
        }
      }
    }
    routes = {
      phonebook-route-http = {
        name                       = "phonebook-route-http"
        cdn_frontdoor_endpoint     = "phonebook"
        cdn_frontdoor_origin_group = "phonebook-origin-group"
        cdn_frontdoor_origins      = ["phonebook-eu"]
        # cdn_frontdoor_rule_sets       = ["phonebookruleset"]
        enabled                = true
        forwarding_protocol    = "HttpOnly"
        https_redirect_enabled = false
        patterns_to_match      = ["/*"]
        supported_protocols    = ["Http", "Https"]
      }
    }
    # rule_sets = {
    #   phonebookruleset = {
    #     name = "phonebookruleset"
    #   }
    # }
    # rules = [
    #   {
    #     name = "httpstohttp"
    #     rule_set = "phonebookruleset"
    #     conditions = {
    #       request_scheme_conditions = {
    #         equal_https = {
    #           operator         = "Equal"
    #           match_values     = ["HTTPS"]
    #         }
    #       }
    #     }
    #     actions = {
    #       url_redirect_actions = {
    #         movedhttp = {
    #           redirect_type        = "Moved"
    #           redirect_protocol    = "Http"
    #           destination_hostname = ""
    #         }
    #       }
    #     }
    #   }
    # ]
  }
}