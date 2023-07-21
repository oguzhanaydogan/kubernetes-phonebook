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
  vnet_app = {
    name           = "vnet-app"
    resource_group = "rg_eastus"
    address_space  = ["10.1.0.0/16"]
    subnets        = {
      subnet_app = {
        name             = "subnet-app"
        address_prefixes = ["10.1.0.0/24"]
      }
      subnet_aks = {
        name             = "subnet-aks"
        address_prefixes = ["10.1.1.0/24"]
      }
      subnet_appgw = {
        name             = "subnet-appgw"
        address_prefixes = ["10.1.2.0/24"]
      }
    }
  }
  vnet_acr = {
    name           = "vnet-acr"
    resource_group = "rg_eastus"
    address_space  = ["10.2.0.0/16"]
    subnets = {
      subnet_acr = {
        name             = "subnet-acr"
        address_prefixes = ["10.2.0.0/24"]
      }
    }
  }
  vnet_db = {
    name           = "vnet-db"
    resource_group = "rg_eastus"
    address_space  = ["10.3.0.0/16"]
    subnets = {
      subnet_db = {
        name             = "subnet-db"
        address_prefixes = ["10.3.0.0/24"]
      }
      subnet_db_pep = {
        name             = "subnet-db-pep"
        address_prefixes = ["10.3.1.0/24"]
      }
    }
  }
  vnet_agent = {
    name           = "vnet-agent"
    resource_group = "rg_eastus"
    address_space  = ["10.4.0.0/16"]
    subnets = {
      subnet_agent = {
        name             = "subnet-agent"
        address_prefixes = ["10.4.0.0/24"]
      }
    }
  }
  vnet_app_eu = {
    name           = "vnet-app-eu"
    resource_group = "rg_westeurope"
    address_space  = ["10.11.0.0/16"]
    subnets = {
      subnet_app = {
        name             = "subnet-app"
        address_prefixes = ["10.11.0.0/24"]
      }
      subnet_lb = {
        name             = "subnet-lb"
        address_prefixes = ["10.11.1.0/24"]
      }
      subnet_lb_pls = {
        name                                          = "subnet-lb-pls"
        address_prefixes                              = ["10.11.2.0/24"]
        private_link_service_network_policies_enabled = false
      }
      subnet_lb_pls_pep = {
        name             = "subnet-lb-pls-pep"
        address_prefixes = ["10.11.4.0/24"]
      }
      subnet_bastion = {
        name             = "AzureBastionSubnet"
        address_prefixes = ["10.11.3.0/24"]
      }
    }
  }
  vnet_db_eu = {
    name           = "vnet-db-eu"
    resource_group = "rg_westeurope"
    address_space  = ["10.12.0.0/16"]
    subnets = {
      subnet_db = {
        name             = "subnet-db"
        address_prefixes = ["10.12.0.0/24"]
      }
      subnet_db_pep = {
        name             = "subnet-db-pep"
        address_prefixes = ["10.12.1.0/24"]
      }
    }
  }
}

virtual_wans = {
  project_102_virtual_wan = {
    name = "project-102-virtual-wan"
    resource_group = "rg_eastus"
    virtual_hubs = {
      eastus_virtual_hub = {
        name = "eastus-virtual-hub"
        address_prefix = "10.30.0.0/16"
        virtual_hub_connections = {
          connection_01 = {
            name = "acr-connection"
            remote_virtual_network = {
              name = "vnet-acr"
              resource_group_name = "rg-eastus"
            }
            routing = {
              associated_route_table = "Default"
              propagated_route_tables = [
                {
                  name = "Default"
                  hub = "eastus_virtual_hub"
                }
              ]
            }
          }
          connection_02 = {
            name = "agent-connection"
            remote_virtual_network = {
              name = "vnet-agent"
              resource_group_name = "rg-eastus"
            }
            routing = {
              associated_route_table = "Default"
              propagated_route_tables = []
            }
          }
          connection_03 = {
            name = "db-connection"
            remote_virtual_network = {
              name = "vnet-db"
              resource_group_name = "rg-eastus"
            }
            routing = {
              associated_route_table = "Default"
              propagated_route_tables = [
                {
                  name = "Default"
                  hub = "eastus_virtual_hub"
                }
              ]
            }
          }
        }
        # route_table_routes = {
        #   route_01 = {
        #     name =
        #     destinations_type =
        #     destinations =
        #     next_hop_type =
        #     next_hop_connection =
        #   }
        # }
      }
    }
  }
}

vnet_peerings = {
  # db_hub = {
  #   name                    = "db-hub"
  #   virtual_network         = "vnet_db"
  #   remote_virtual_network  = "vnet_hub"
  #   resource_group          = "rg_eastus"
  #   allow_forwarded_traffic = true
  # }
  # hub_db = {
  #   name                    = "hub-db"
  #   virtual_network         = "vnet_hub"
  #   remote_virtual_network  = "vnet_db"
  #   resource_group          = "rg_eastus"
  #   allow_forwarded_traffic = true
  # }
  # app_hub = {
  #   name                    = "app-hub"
  #   virtual_network         = "vnet_app"
  #   remote_virtual_network  = "vnet_hub"
  #   resource_group          = "rg_eastus"
  #   allow_forwarded_traffic = true
  # }
  # hub_app = {
  #   name                    = "hub-app"
  #   virtual_network         = "vnet_hub"
  #   remote_virtual_network  = "vnet_app"
  #   resource_group          = "rg_eastus"
  #   allow_forwarded_traffic = true
  # }
  # acr_hub = {
  #   name                    = "acr-hub"
  #   virtual_network         = "vnet_acr"
  #   remote_virtual_network  = "vnet_hub"
  #   resource_group          = "rg_eastus"
  #   allow_forwarded_traffic = true
  # }
  # hub_acr = {
  #   name                    = "hub-acr"
  #   virtual_network         = "vnet_hub"
  #   remote_virtual_network  = "vnet_acr"
  #   resource_group          = "rg_eastus"
  #   allow_forwarded_traffic = true
  # }
  db_dbeu = {
    name                    = "db-dbeu"
    virtual_network         = "vnet_db"
    remote_virtual_network  = "vnet_db_eu"
    resource_group          = "rg_eastus"
    allow_forwarded_traffic = true
  }
  dbeu_db = {
    name                    = "dbeu-db"
    virtual_network         = "vnet_db_eu"
    remote_virtual_network  = "vnet_db"
    resource_group          = "rg_westeurope"
    allow_forwarded_traffic = true
  }
  appeu_dbeu = {
    name                    = "appeu-dbeu"
    virtual_network         = "vnet_app_eu"
    remote_virtual_network  = "vnet_db_eu"
    resource_group          = "rg_westeurope"
    allow_forwarded_traffic = true
  }
  dbeu_appeu = {
    name                    = "dbeu-appeu"
    virtual_network         = "vnet_db_eu"
    remote_virtual_network  = "vnet_app_eu"
    resource_group          = "rg_westeurope"
    allow_forwarded_traffic = true
  }
  app_agent = {
    name                    = "app-agent"
    virtual_network         = "vnet_app"
    remote_virtual_network  = "vnet_agent"
    resource_group          = "rg_eastus"
    allow_forwarded_traffic = true
  }
  agent_app = {
    name                    = "agent-app"
    virtual_network         = "vnet_agent"
    remote_virtual_network  = "vnet_app"
    resource_group          = "rg_eastus"
    allow_forwarded_traffic = true
  }
}

route_tables = {
  # route_table_1 = {
  #   name           = "route-table-1"
  #   resource_group = "rg_eastus"
  #   routes = {
  #     route_to_vnet_acr_subnet_acr = {
  #       name                   = "route-to-vnet-acr-subnet-acr"
  #       address_prefix         = "10.2.0.0/24"
  #       next_hop_type          = "VirtualAppliance"
  #       next_hop_in_ip_address = "10.0.0.4"
  #     }
  #     route_to_vnet_db_subnet_db = {
  #       name                   = "route-to-vnet-db-subnet-db"
  #       address_prefix         = "10.3.0.0/24"
  #       next_hop_type          = "VirtualAppliance"
  #       next_hop_in_ip_address = "10.0.0.4"
  #     }
  #   }
  #   subnet_associations = {
  #     vnet_app_subnet_app = {
  #       subnet_name          = "subnet-app"
  #       resource_group_name  = "rg-eastus"
  #       virtual_network_name = "vnet-app"
  #     }
  #     vnet_app_subnet_aks = {
  #       subnet_name          = "subnet-aks"
  #       resource_group_name  = "rg-eastus"
  #       virtual_network_name = "vnet-app"
  #     }
  #   }
  # }
  # route_table_2 = {
  #   name           = "route-table-2"
  #   resource_group = "rg_eastus"
  #   routes = {
  #     route_to_vnet_app_subnet_app = {
  #       name                   = "route-to-vnet-app-subnet-app"
  #       address_prefix         = "10.1.0.0/24"
  #       next_hop_type          = "VirtualAppliance"
  #       next_hop_in_ip_address = "10.0.0.4"
  #     }
  #   }
  #   subnet_associations = {
  #     vnet_db_subnet_db = {
  #       subnet_name          = "subnet-db"
  #       resource_group_name  = "rg-eastus"
  #       virtual_network_name = "vnet-db"
  #     }
  #   }
  # }
  # route_table_3 = {
  #   name           = "route-table-3"
  #   resource_group = "rg_eastus"
  #   routes = {
  #     route_to_everywhere = {
  #       name                   = "route-to-everywhere"
  #       address_prefix         = "10.0.0.0/8"
  #       next_hop_type          = "VirtualAppliance"
  #       next_hop_in_ip_address = "10.4.0.4"
  #     }
  #   }
  #   subnet_associations = {
  #     vnet_acr_subnet_acr = {
  #       subnet_name          = "subnet-acr"
  #       resource_group_name  = "rg-eastus"
  #       virtual_network_name = "vnet-acr"
  #     }
  #   }
  # }
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
  # hub_firewall_management = {
  #   name              = "hub-firewall-management"
  #   allocation_method = "Static"
  #   sku               = "Standard"
  #   resource_group    = "rg_eastus"
  # }
  ci_cd_agent = {
    name              = "ci-cd-agent"
    allocation_method = "Static"
    sku               = "Standard"
    resource_group    = "rg_eastus"
  }
  # bastion_host_eu = {
  #   name              = "bastion-host-eu"
  #   allocation_method = "Static"
  #   sku               = "Standard"
  #   resource_group    = "rg_westeurope"
  # }
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

firewalls = {
  hub_us = {
    name           = "hub"
    resource_group = "rg_eastus"
    sku_name       = "AZFW_Hub"
    sku_tier       = "Basic"
    virtual_hub = {
      name = "eastus-virtual-hub"
      resource_group_name = "rg-eastus"
    }
    ip_configuration = {
      subnet = {
        name                 = "AzureFirewallSubnet"
        virtual_network_name = "vnet-hub"
        resource_group_name  = "rg-eastus"
      }
    }
    management_ip_configuration = {
      enabled = true
      subnet = {
        virtual_network_name = "vnet-hub"
        resource_group_name  = "rg-eastus"
      }
      public_ip_address = {
        name                = "hub-firewall-management"
        resource_group_name = "rg-eastus"
      }
    }
    firewall_network_rule_collections = {
      collection_01 = {
        name = "firewall_hub"
        priority = 100
        action = "Allow"
        firewall_network_rules = {
          rule_01 = {
            name = "firewall_hub"
            source_addresses = ["10.1.1.0/24"]
            destination_ports = ["*"]
            destination_addresses = ["0.0.0.0/0"]
            protocols =["Any"]
          }
        }
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
  coy_vault = {
    key_vault_name                = "coyvault"
    key_vault_resource_group_name = "ssh-key"
    key_permissions = [
      "Get", "List",
    ]
    secret_permissions = [
      "Get", "List",
    ]
  }
}

key_vault_secrets = {
  mssql_password = {
    name                          = "MSSQLPASSWORD"
    key_vault_resource_group_name = "ssh-key"
    key_vault_name                = "coyvault"
  }
}

mssql_servers = {
  # coyhub_db_us = {
  #   name                  = "coyhub-db-us"
  #   resource_group        = "rg_eastus"
  #   version               = "12.0"
  #   administrator_login   = "azureuser"
  #   admin_password_key_vault_secret = "mssql_password"
  #   tags = {
  #     name = "coyhub-db-us"
  #   }
  #   mssql_databases = {
  #     phonebook_us = {
  #       name                        = "phonebook"
  #       collation                   = "SQL_Latin1_General_CP1_CI_AS"
  #       max_size_gb                 = 32
  #       sku_name                    = "GP_S_Gen5_1"
  #       min_capacity                = 0.5
  #       auto_pause_delay_in_minutes = 60
  #       read_replica_count          = 0
  #       read_scale                  = false
  #       zone_redundant              = false
  #     }
  #   }

  # }
  # coyhub_db_eu = {
  #   name                  = "coyhub-db-eu"
  #   resource_group        = "rg_westeurope"
  #   version               = "12.0"
  #   administrator_login   = "azureuser"
  #   admin_password_key_vault_secret = "mssql_password"
  #   tags = {
  #     name = "coyhub-db-eu"
  #   }
  #   mssql_databases = {
  #     phonebook_eu = {
  #       name                        = "phonebook"
  #       collation                   = "SQL_Latin1_General_CP1_CI_AS"
  #       max_size_gb                 = 32
  #       sku_name                    = "GP_S_Gen5_1"
  #       min_capacity                = 0.5
  #       auto_pause_delay_in_minutes = 60
  #       read_replica_count          = 0
  #       read_scale                  = false
  #       zone_redundant              = false
  #     }
  #   }
  # }
}

load_balancers = {
  # phonebook_lb = {
  #   name           = "phonebook-lb"
  #   resource_group = "rg_westeurope"
  #   sku            = "Standard"
  #   frontend_ip_configurations = {
  #     internal = {
  #       name = "internal"
  #       subnet = {
  #         name                 = "subnet-lb"
  #         virtual_network_name = "vnet-app-eu"
  #         resource_group_name  = "rg-westeurope"
  #       }
  #     }
  #   }
  #   lb_backend_address_pools = {
  #     backend_pool = {
  #       name = "backend-pool"
  #     }
  #   }
  #   lb_probes = {
  #     http = {
  #       name     = "http"
  #       protocol = "Tcp"
  #       port     = "80"
  #     }
  #   }
  #   lb_rules = {
  #     http = {
  #       name                           = "http"
  #       probe                          = "http"
  #       backend_address_pools          = ["backend_pool"]
  #       frontend_ip_configuration_name = "internal"
  #       protocol                       = "Tcp"
  #       frontend_port                  = "80"
  #       backend_port                   = "80"
  #     }
  #   }
  #   private_link_service = {
  #     name = "phonebook-lb-pls"
  #     nat_ip_configurations = {
  #       nat_ip_configuration_01 = {
  #         name    = "primary"
  #         subnet  = {
  #           name                 = "subnet-lb-pls"
  #           virtual_network_name = "vnet-app-eu"
  #           resource_group_name  = "rg-westeurope"
  #         }
  #         primary = true
  #       }
  #     }
  #   }
  # }
}

linux_virtual_machine_scale_sets = {
  # app_vmss = {
  #   name           = "phonebook-vmss"
  #   resource_group = "rg_westeurope"
  #   sku            = "Standard_B1s"
  #   instances      = 1
  #   admin_username = "azureuser"
  #   shared_image = {
  #     name                = "myimagedefinitongen"
  #     gallery_name        = "mygallery"
  #     resource_group_name = "ssh-key"
  #   }
  #   upgrade_mode = "Rolling"
  #   health_probe = {
  #     load_balancer = "phonebook_lb"
  #     name          = "http"
  #   }
  #   admin_ssh_key = {
  #     resource_group_name = "ssh-key"
  #     name                = "azure"
  #   }
  #   os_disk = {
  #     storage_account_type = "Standard_LRS"
  #     caching              = "ReadWrite"
  #   }
  #   network_interface = {
  #     name    = "example"
  #     primary = true
  #     network_security_group = {
  #       name                = "ssh-and-http"
  #       resource_group_name = "rg-westeurope"
  #     }
  #     ip_configurations = {
  #       internal = {
  #         name    = "internal"
  #         primary = true
  #         subnet = {
  #           name                 = "subnet-app"
  #           virtual_network_name = "vnet-app-eu"
  #           resource_group_name  = "rg-westeurope"
  #         }
  #         load_balancer_backend_address_pools = {
  #           phonebook_lb_backend_pool = {
  #             name                              = "backend-pool"
  #             load_balancer_name                = "phonebook-lb"
  #             load_balancer_resource_group_name = "rg-westeurope"
  #           }
  #         }
  #       }
  #     }
  #   }
  #   rolling_upgrade_policy = {
  #     max_batch_instance_percent              = 20
  #     max_unhealthy_instance_percent          = 20
  #     max_unhealthy_upgraded_instance_percent = 5
  #     pause_time_between_batches              = "PT0S"
  #   }
  # }
}

bastion_hosts = {
  # bastion_eu = {
  #   name           = "bastion-eu"
  #   resource_group = "rg_westeurope"
  #   ip_configurations = {
  #     ipConfiguration1 = {
  #       name = "ipConfiguration1"
  #       subnet = {
  #         name                 = "AzureBastionSubnet"
  #         virtual_network_name = "vnet-app-eu"
  #         resource_group_name  = "rg-westeurope"
  #       }
  #       public_ip_address = {
  #         name                = "bastion-host-eu"
  #         resource_group_name = "rg-westeurope"
  #       }
  #     }
  #   }
  # }
}

private_dns_zones = {
  # db = {
  #   name           = "privatelink.database.windows.net"
  #   resource_group = "rg_eastus"
  #   virtual_network_links = {
  #     zone_db_to_vnet_db = {
  #       name = "zone-db-to-vnet-db"
  #       virtual_network = {
  #         name                = "vnet-db"
  #         resource_group_name = "rg-eastus"
  #       }
  #     }
  #     zone_db_to_vnet_db_eu = {
  #       name = "zone-db-to-vnet-db-eu"
  #       virtual_network = {
  #         name                = "vnet-db-eu"
  #         resource_group_name = "rg-westeurope"
  #       }
  #     }
  #     zone_db_to_vnet_app = {
  #       name = "zone-db-to-vnet-app"
  #       virtual_network = {
  #         name                = "vnet-app"
  #         resource_group_name = "rg-eastus"
  #       }
  #     }
  #     zone_db_to_vnet_app_eu = {
  #       name = "zone-db-to-vnet-app-eu"
  #       virtual_network = {
  #         name                = "vnet-app-eu"
  #         resource_group_name = "rg-westeurope"
  #       }
  #     }
  #   }
  # }
}

private_endpoints = {
  # pep_db = {
  #   attached_resource = {
  #     name = "coyhub-db-us"
  #     type = "Microsoft.Sql/servers"
  #     required_tags = {
  #       name = "coyhub-db-us"
  #     }
  #   }
  #   resource_group = "rg_eastus"
  #   subnet         = {
  #     reference_name = "subnet_db_pep"
  #     virtual_network_reference_name = "vnet_db"
  #   }
  #   private_service_connection = {
  #     is_manual_connection = false
  #     subresource_names    = ["sqlServer"]
  #   }
  #   private_dns_zone_group = {
  #     private_dns_zones = ["db"]
  #   }
  # }
  # pep_db_eu = {
  #   attached_resource = {
  #     name = "coyhub-db-eu"
  #     type = "Microsoft.Sql/servers"
  #     required_tags = {
  #       name = "coyhub-db-eu"
  #     }
  #   }
  #   resource_group = "rg_westeurope"
  #   subnet         = {
  #     reference_name = "subnet_db_pep"
  #     virtual_network_reference_name = "vnet_db_eu"
  #   }
  #   private_service_connection = {
  #     is_manual_connection = false
  #     subresource_names    = ["sqlServer"]
  #   }
  #   private_dns_zone_group = {
  #     private_dns_zones = ["db"]
  #   }
  # }
}

kubernetes_clusters = {
  # phonebook = {
  #   subnet_aks = {
  #     name                 = "subnet-aks"
  #     virtual_network_name = "vnet-app"
  #     resource_group_name  = "rg-eastus"
  #   }
  #   subnet_appgw = {
  #     name                 = "subnet-appgw"
  #     virtual_network_name = "vnet-app"
  #     resource_group_name  = "rg-eastus"
  #   }
  #   name                    = "phonebook"
  #   resource_group          = "rg_eastus"
  #   private_cluster_enabled = true
  #   default_node_pool = {
  #     name       = "default"
  #     node_count = 1
  #     vm_size    = "Standard_B2s"
  #   }
  #   identity = {
  #     type = "SystemAssigned"
  #   }
  #   ingress_application_gateway = {
  #     enabled      = true
  #     gateway_name = "phonebook"
  #   }
  #   network_profile = {
  #     network_plugin = "azure"
  #     outbound_type  = "userDefinedRouting"
  #   }
  # }
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