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
  vnet_app_subnet_aks = {
    name                                          = "subnet-aks"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_app"
    address_prefixes                              = ["10.1.1.0/24"]
    delegation                                    = false
    delegation_name                               = ""
    private_link_service_network_policies_enabled = true
  }
  vnet_app_subnet_appgw = {
    name                                          = "subnet-appgw"
    resource_group                                = "rg_eastus"
    virtual_network                               = "vnet_app"
    address_prefixes                              = ["10.1.2.0/24"]
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
        subnet_name          = "subnet-acr"
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
    allocation_method = "Static"
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
    allocation_method = "Static"
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
    name           = "ci-cd-agent"
    resource_group = "rg_eastus"
    network_interface = {
      ip_configurations = {
        ipConfiguration1 = {
          name = "ipConfiguration1"
          subnet = {
            name                 = "subnet-agent"
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
    }
    size                             = "Standard_B1s"
    delete_data_disks_on_termination = true
    delete_os_disk_on_termination    = true
    identity = {
      enabled = true
      type    = "SystemAssigned"
    }
    storage_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    storage_os_disk = {
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
    os_profile = {
      admin_username = "azureuser"
      custom_data    = "modules/VirtualMachine/agent.sh"
    }
    os_profile_linux_config = {
      disable_password_authentication = true
      ssh_key = {
        resource_group_name = "ssh-key"
        name                = "azure"
      }
    }
    network_security_group_association = {
      enabled                                    = true
      network_security_group_name                = "ssh"
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
  coyhub_db_us = {
    name                  = "coyhub-db-us"
    resource_group        = "rg_eastus"
    administrator_login   = "azureuser"
    admin_password_secret = "key_vault_secret_mssql_password"
    tags = {
      name = "coyhub-db-us"
    }
  }
  # coyhub_db_eu = {
  #   name                  = "coyhub-db-eu"
  #   resource_group        = "rg_westeurope"
  #   administrator_login   = "azureuser"
  #   admin_password_secret = "key_vault_secret_mssql_password"
  #   tags = {
  #     name = "coyhub-db-eu"
  #   }
  # }
}

mssql_databases = {
  phonebook_us = {
    name                        = "phonebook"
    server                      = "coyhub_db_us"
    collation                   = "SQL_Latin1_General_CP1_CI_AS"
    max_size_gb                 = 32
    sku_name                    = "GP_S_Gen5_1"
    min_capacity                = 0.5
    auto_pause_delay_in_minutes = 60
    read_replica_count          = 0
    read_scale                  = false
    zone_redundant              = false
  }

  # phonebook_eu = {
  #   name                        = "phonebook"
  #   server                      = "coyhub_db_eu"
  #   collation                   = "SQL_Latin1_General_CP1_CI_AS"
  #   max_size_gb                 = 32
  #   sku_name                    = "GP_S_Gen5_1"
  #   min_capacity                = 0.5
  #   auto_pause_delay_in_minutes = 60
  #   read_replica_count          = 0
  #   read_scale                  = false
  #   zone_redundant              = false
  # }
}

load_balancers = {
  phonebook_lb = {
    name           = "phonebook-lb"
    resource_group = "rg_westeurope"
    sku            = "Standard"
    frontend_ip_configurations = {
      internal = {
        name = "internal"
        subnet = {
          name                 = "subnet-lb"
          virtual_network_name = "vnet-app-eu"
          resource_group_name  = "rg-westeurope"
        }
      }
    }
    lb_backend_address_pools = {
      backend_pool = {
        name = "backend-pool"
      }
    }
    lb_probes = {
      http = {
        name     = "http"
        protocol = "Tcp"
        port     = "80"
      }
    }
    lb_rules = {
      http = {
        name                           = "http"
        probe                          = "http"
        backend_address_pools          = ["backend_pool"]
        frontend_ip_configuration_name = "internal"
        protocol                       = "Tcp"
        frontend_port                  = "80"
        backend_port                   = "80"
      }
    }
  }
}

private_link_services = {
  phonebook_lb_pls = {
    name           = "phonebook-lb-pls"
    resource_group = "rg_westeurope"
    load_balancer  = "phonebook_lb"
    nat_ip_configurations = [
      {
        name    = "primary"
        subnet  = "vnet_app_eu_subnet_lb_pls"
        primary = true
      }
    ]
  }
}

linux_virtual_machine_scale_sets = {
  app_vmss = {
    name           = "phonebook-vmss"
    resource_group = "rg_westeurope"
    sku            = "Standard_B1s"
    instances      = 1
    admin_username = "azureuser"
    shared_image = {
      name                = "myimagedefinitongen"
      gallery_name        = "mygallery"
      resource_group_name = "ssh-key"
    }
    upgrade_mode = "Rolling"
    health_probe = {
      load_balancer = "phonebook_lb"
      name          = "http"
    }
    admin_ssh_key = {
      resource_group_name = "ssh-key"
      name                = "azure"
    }
    os_disk = {
      storage_account_type = "Standard_LRS"
      caching              = "ReadWrite"
    }
    network_interface = {
      name    = "example"
      primary = true
      network_security_group = {
        name                = "ssh-and-http"
        resource_group_name = "rg-westeurope"
      }
      ip_configurations = {
        internal = {
          name    = "internal"
          primary = true
          subnet = {
            name                 = "subnet-app"
            virtual_network_name = "vnet-app-eu"
            resource_group_name  = "rg-westeurope"
          }
          load_balancer_backend_address_pools = {
            phonebook_lb_backend_pool = {
              name                = "backend-pool"
              load_balancer_name  = "phonebook-lb"
              load_balancer_resource_group_name = "rg-westeurope"
            }
          }
        }
      }
    }
    rolling_upgrade_policy = {
      max_batch_instance_percent              = 20
      max_unhealthy_instance_percent          = 20
      max_unhealthy_upgraded_instance_percent = 5
      pause_time_between_batches              = "PT0S"
    }
  }
}

bastion_hosts = {
  bastion_eu = {
    name           = "bastion-eu"
    resource_group = "rg_westeurope"
    ip_configurations = {
      ipConfiguration1 = {
        name = "ipConfiguration1"
        subnet = {
          name                 = "AzureBastionSubnet"
          virtual_network_name = "vnet-app-eu"
          resource_group_name  = "rg-westeurope"
        }
        public_ip_address = {
          name                = "bastion-host-eu"
          resource_group_name = "rg-westeurope"
        }
      }
    }
  }
}

private_dns_zones = {
  db = {
    name           = "privatelink.database.windows.net"
    resource_group = "rg_eastus"
    virtual_network_links = {
      zone_db_to_vnet_db = {
        name = "zone-db-to-vnet-db"
        virtual_network = {
          name                = "vnet-db"
          resource_group_name = "rg-eastus"
        }
      }
      zone_db_to_vnet_db_eu = {
        name = "zone-db-to-vnet-db-eu"
        virtual_network = {
          name                = "vnet-db-eu"
          resource_group_name = "rg-westeurope"
        }
      }
      zone_db_to_vnet_app = {
        name = "zone-db-to-vnet-app"
        virtual_network = {
          name                = "vnet-app"
          resource_group_name = "rg-eastus"
        }
      }
      zone_db_to_vnet_app_eu = {
        name = "zone-db-to-vnet-app-eu"
        virtual_network = {
          name                = "vnet-app-eu"
          resource_group_name = "rg-westeurope"
        }
      }
    }
  }
}

private_endpoints = {
  pep_db = {
    attached_resource = {
      name = "coyhub-db-us"
      type = "Microsoft.Sql/servers"
      required_tags = {
        name = "coyhub-db-us"
      }
    }
    resource_group = "rg_eastus"
    subnet         = "vnet_db_subnet_db_pep"
    private_service_connection = {
      is_manual_connection = false
      subresource_names    = ["sqlServer"]
    }
    private_dns_zone_group = {
      private_dns_zones = ["db"]
    }
  }
  pep_db_eu = {
    attached_resource = {
      name = "coyhub-db-eu"
      type = "Microsoft.Sql/servers"
      required_tags = {
        name = "coyhub-db-eu"
      }
    }
    resource_group = "rg_westeurope"
    subnet         = "vnet_db_eu_subnet_db_pep"
    private_service_connection = {
      is_manual_connection = false
      subresource_names    = ["sqlServer"]
    }
    private_dns_zone_group = {
      private_dns_zones = ["db"]
    }
  }
}

front_doors = {
  # phonebook = {
  #   name           = "phonebook"
  #   resource_group = "rg_eastus"
  #   sku_name       = "Premium_AzureFrontDoor"
  #   endpoints      = ["phonebook"]
  #   origin_groups = {
  #     phonebook_origin_group = {
  #       name                                                      = "phonebook-origin-group"
  #       session_affinity_enabled                                  = false
  #       restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
  #       health_probes = {
  #         health_probe_http = {
  #           interval_in_seconds = 240
  #           path                = "/"
  #           protocol            = "Http"
  #           request_type        = "GET"
  #         }
  #       }
  #       load_balancing = {
  #         additional_latency_in_milliseconds = 0
  #         sample_size                        = 16
  #         successful_samples_required        = 3
  #       }
  #     }
  #   }
  #   origins = {
  #     phonebook_eu = {
  #       name                           = "phonebook-eu"
  #       cdn_frontdoor_origin_group     = "phonebook_origin_group"
  #       enabled                        = true
  #       certificate_name_check_enabled = true
  #       host = {
  #         resource_group_name = "rg-westeurope"
  #         name                = "phonebook-lb"
  #         type                = "Microsoft.Network/loadBalancers"
  #         pls_enabled         = true
  #       }
  #       http_port  = 80
  #       https_port = 443
  #       priority   = 1
  #       weight     = 500
  #       private_link = {
  #         request_message = "Gimme gimme"
  #         location        = "West Europe"
  #         target = {
  #           name                = "phonebook-lb-pls"
  #           resource_group_name = "rg-westeurope"
  #         }
  #       }
  #     }
  #   }
  #   routes = {
  #     phonebook_route_http = {
  #       name                       = "phonebook-route-http"
  #       cdn_frontdoor_endpoint     = "phonebook"
  #       cdn_frontdoor_origin_group = "phonebook_origin_group"
  #       cdn_frontdoor_origins      = ["phonebook_eu"]
  #       # cdn_frontdoor_rule_sets       = ["phonebookruleset"]
  #       enabled                = true
  #       forwarding_protocol    = "HttpOnly"
  #       https_redirect_enabled = false
  #       patterns_to_match      = ["/*"]
  #       supported_protocols    = ["Http", "Https"]
  #     }
  #   }
  #   # rule_sets = {
  #   #   phonebookruleset = {
  #   #     name = "phonebookruleset"
  #   #   }
  #   # }
  #   # rules = [
  #   #   {
  #   #     name = "httpstohttp"
  #   #     rule_set = "phonebookruleset"
  #   #     conditions = {
  #   #       request_scheme_conditions = {
  #   #         equal_https = {
  #   #           operator         = "Equal"
  #   #           match_values     = ["HTTPS"]
  #   #         }
  #   #       }
  #   #     }
  #   #     actions = {
  #   #       url_redirect_actions = {
  #   #         movedhttp = {
  #   #           redirect_type        = "Moved"
  #   #           redirect_protocol    = "Http"
  #   #           destination_hostname = ""
  #   #         }
  #   #       }
  #   #     }
  #   #   }
  #   # ]
  # }
}

