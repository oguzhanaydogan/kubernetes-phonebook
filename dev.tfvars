resource_groups = {
  rg_project102_prod_eastus_001 = {
    name     = "rg-project102-prod-eastus-001"
    location = "East Us"
  }
  rg_project102_prod_westeurope_001 = {
    name     = "rg-project102-prod-westeurope-001"
    location = "West Europe"
  }
}

virtual_networks = {
  vnet_project102_prod_eastus_001 = { # app
    name           = "vnet-project102-prod-eastus-001"
    resource_group = "rg_project102_prod_eastus_001"
    address_space  = ["10.0.0.0/16"]
    subnets        = {
      snet_project102_prod_eastus_001 = { # app
        name             = "snet-project102-prod-eastus-001"
        address_prefixes = ["10.0.0.0/24"]
      }
      snet_project102_prod_eastus_002 = { # aks
        name             = "snet-project102-prod-eastus-002"
        address_prefixes = ["10.0.1.0/24"]
      }
      snet_project102_prod_eastus_003 = { # agw
        name             = "snet-project102-prod-eastus-003"
        address_prefixes = ["10.0.2.0/24"]
      }
    }
  }
  vnet_project102_prod_eastus_002 = { # acr
    name           = "vnet-project102-prod-eastus-002"
    resource_group = "rg_project102_prod_eastus_001"
    address_space  = ["10.1.0.0/16"]
    subnets = {
      snet_project102_prod_eastus_004 = { # acr
        name             = "snet-project102-prod-eastus-004"
        address_prefixes = ["10.1.0.0/24"]
      }
    }
  }
  vnet_project102_prod_eastus_003 = { # sql
    name           = "vnet-project102-prod-eastus-003"
    resource_group = "rg_project102_prod_eastus_001"
    address_space  = ["10.2.0.0/16"]
    subnets = {
      snet_project102_prod_eastus_005 = { # sql
        name             = "snet-project102-prod-eastus-005"
        address_prefixes = ["10.2.0.0/24"]
      }
      snet_project102_prod_eastus_006 = { # pep
        name             = "snet-project102-prod-eastus-006"
        address_prefixes = ["10.2.1.0/24"]
      }
    }
  }
  vnet_project102_prod_eastus_004 = { # agent
    name           = "vnet-project102-prod-eastus-004"
    resource_group = "rg_project102_prod_eastus_001"
    address_space  = ["10.3.0.0/16"]
    subnets = {
      snet_project102_prod_eastus_007 = { # agent
        name             = "snet-project102-prod-eastus-007"
        address_prefixes = ["10.3.0.0/24"]
      }
    }
  }
  vnet_project102_prod_eastus_005 = { # fw
    name           = "AzureFirewallSubnet"
    resource_group = "rg_project102_prod_eastus_001"
    address_space  = ["10.4.0.0/16"]
    subnets        = {
      snet_project102_prod_eastus_008 = { # fw
        name             = "snet-project102-prod-eastus-008"
        address_prefixes = ["10.4.0.0/24"]
      }
    }
  }
  vnet_project102_prod_westeurope_001 = { # app
    name           = "vnet-project102-prod-westeurope-001"
    resource_group = "rg_project102_prod_westeurope_001"
    address_space  = ["10.10.0.0/16"]
    subnets = {
      snet_project102_prod_westeurope_001 = { # app
        name             = "snet-project102-prod-westeurope-001"
        address_prefixes = ["10.10.0.0/24"]
      }
      snet_project102_prod_westeurope_002 = { # lb
        name             = "snet-project102-prod-westeurope-002"
        address_prefixes = ["10.10.1.0/24"]
      }
      snet_project102_prod_westeurope_003 = { # pls
        name                                          = "snet-project102-prod-westeurope-003"
        address_prefixes                              = ["10.10.2.0/24"]
        private_link_service_network_policies_enabled = false
      }
      snet_project102_prod_westeurope_004 = { # pep
        name             = "snet-project102-prod-westeurope-004"
        address_prefixes = ["10.10.3.0/24"]
      }
      snet_project102_prod_westeurope_005 = { # bastion
        name             = "AzureBastionSubnet"
        address_prefixes = ["10.10.4.0/24"]
      }
    }
  }
  vnet_project102_prod_westeurope_002 = { # sql
    name           = "vnet-project102-prod-westeurope-002"
    resource_group = "rg_project102_prod_westeurope_002"
    address_space  = ["10.11.0.0/16"]
    subnets = {
      snet_project102_prod_westeurope_006 = { # sql
        name             = "snet-project102-prod-westeurope-006"
        address_prefixes = ["10.11.0.0/24"]
      }
      snet_project102_prod_westeurope_007 = { # pep
        name             = "snet-project102-prod-westeurope-007"
        address_prefixes = ["10.11.1.0/24"]
      }
    }
  }
}

virtual_wans = {
  vwan_project102_prod_eastus_001 = {
    name = "vwan-project102-prod-eastus-001"
    resource_group = "rg_project102_prod_eastus_001"
    virtual_hubs = {
      vwanvh_project102_prod_eastus_001 = {
        name = "vwanvh-project102-prod-eastus-001"
        address_prefix = "10.30.0.0/16"
        virtual_hub_connections = {
          vwanwhc_project102_prod_eastus_001 = { # acr
            name = "vwanwhc-project102-prod-eastus-001"
            remote_virtual_network = {
              name = "vnet-project102-prod-eastus-002"
              resource_group_name = "rg-project102-prod-eastus-001"
            }
            routing = {
              associated_route_table = "Default"
              propagated_route_tables = [
                {
                  name = "Default"
                  virtual_hub = "vwanvh_project102_prod_eastus_001"
                }
              ]
            }
          }
          vwanwhc_project102_prod_eastus_002 = { # CI/CD agent
            name = "vwanwhc-project102-prod-eastus-002"
            remote_virtual_network = {
              name = "vnet_project102_prod_eastus_004"
              resource_group_name = "rg-project102-prod-eastus-001"
            }
            routing = {
              associated_route_table = "Default"
              propagated_route_tables = []
            }
          }
          vwanwhc_project102_prod_eastus_003 = { # SQL
            name = "vwanwhc-project102-prod-eastus-003"
            remote_virtual_network = {
              name = "vnet-project102-prod-eastus-003"
              resource_group_name = "rg-project102-prod-eastus-001"
            }
            routing = {
              associated_route_table = "Default"
              propagated_route_tables = [
                {
                  name = "Default"
                  virtual_hub = "vwanvh_project102_prod_eastus_001"
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
  peer_project102_prod_global_001 = { # sql-us_sql-eu
    name                    = "peer-project102-prod-global-001"
    virtual_network         = "vnet_project102_prod_eastus_003"
    remote_virtual_network  = "vnet_project102_prod_westeurope_001"
    resource_group          = "rg_project102_prod_eastus_001"
    allow_forwarded_traffic = true
  }
  peer_project102_prod_global_002 = { # sql-eu_sql-us
    name                    = "peer-project102-prod-global-002"
    virtual_network         = "vnet_project102_prod_westeurope_001"
    remote_virtual_network  = "vnet_project102_prod_eastus_003"
    resource_group          = "rg_project102_prod_westeurope_001"
    allow_forwarded_traffic = true
  }
  peer_project102_prod_global_003 = { # app-eu_db_eu
    name                    = "peer-project102-prod-global-003"
    virtual_network         = "vnet_project102_prod_westeurope_001"
    remote_virtual_network  = "vnet_project102_prod_westeurope_002"
    resource_group          = "rg_project102_prod_westeurope_001"
    allow_forwarded_traffic = true
  }
  peer_project102_prod_global_004 = { # db-eu_app-eu
    name                    = "peer-project102-prod-global-004"
    virtual_network         = "vnet_project102_prod_westeurope_002"
    remote_virtual_network  = "vnet_project102_prod_westeurope_001"
    resource_group          = "rg_project102_prod_westeurope_001"
    allow_forwarded_traffic = true
  }
}

route_tables = {}

public_ip_addresses = {
  pip_project102_prod_eastus_001 = { # CI/CD agent
    name              = "pip-project102-prod-eastus-001"
    allocation_method = "Static"
    sku               = "Standard"
    resource_group    = "rg_project102_prod_eastus_001"
  }
  pip_project102_prod_westeurope_001 = { # bastion
    name              = "pip-project102-prod-westeurope-001"
    allocation_method = "Static"
    sku               = "Standard"
    resource_group    = "rg_project102_prod_westeurope_001"
  }
}

network_security_groups = {
  nsg_project102_prod_eastus_001 = { # ssh
    name           = "nsg-project102-prod-eastus-001"
    resource_group = "rg_project102_prod_eastus_001"
    security_rules = {
      allow_ssh = {
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
  nsg_project102_prod_westeurope_001 = { # ssh and http
    name           = "nsg-project102-prod-westeurope-001"
    resource_group = "rg_project102_prod_westeurope_001"
    security_rules = {
      allow_ssh = {
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
      allow_http = {
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
  fw_project102_prod_eastus_001 = { # hub
    name           = "fw-project102-prod-eastus-001"
    resource_group = "rg_project102_prod_eastus_001"
    sku_name       = "AZFW_Hub"
    sku_tier       = "Basic"
    virtual_hub = {
      name = "vwanvh-project102-prod-eastus-001"
      resource_group_name = "rg-project102-prod-eastus-001"
    }
    ip_configuration = {
      name = "IPConfiguration"
      subnet = {
        name                 = "AzureFirewallSubnet"
        virtual_network_name = "vnet-project102-prod-eastus-005"
        resource_group_name  = "rg-project102-prod-eastus-001"
      }
    }
    management_ip_configuration = {
      enabled = false
    }
    firewall_network_rule_collections = {
      fwnrc_project102_prod_eastus_001 = {
        name = "fwnrc-project102-prod-eastus-001"
        priority = 100
        action = "Allow"
        firewall_network_rules = {
          allow_acr_to_everywhere = { // TODO: burasi yanlis
            name = "AllowACRtoEverywhere"
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
  vm_project102_prod_eastus_001 = { # ci/cd agent
  // TODO: boot_diagnosticsi enable et, passwordu enable et
    name           = "vm-project102-prod-eastus-001"
    resource_group = "rg_project102_prod_eastus_001"
    network_interface = {
      name = "nic-project102-prod-eastus-001"
      ip_configurations = {
        IPConfiguration1 = {
          name = "IPConfiguration1"
          subnet = {
            name                 = "snet-project102-prod-eastus-007"
            virtual_network_name = "vnet_project102_prod_eastus_004"
            resource_group_name  = "rg-project102-prod-eastus-001"
          }
          private_ip_address_allocation = "Dynamic"
          public_ip_assigned            = true
          public_ip_address = {
            name                = "pip-project102-prod-eastus-001"
            resource_group_name = "rg-project102-prod-eastus-001"
          }
        }
      }
    }
    size                             = "Standard_B1s"
    delete_data_disks_on_termination = true
    delete_os_disk_on_termination    = true
    identity = {
      // TODO: ENABLEDA GEREK YOK
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
      custom_data    = "modules/VirtualMachine/vm_project102_prod_eastus_001.sh"
    }
    os_profile_linux_config = {
      disable_password_authentication = true
      ssh_key = {
        resource_group_name = "ssh-key"
        name                = "azure"
      }
    }
    network_security_group_association = {
      // TODO: Enabled?
      enabled                                    = true
      network_security_group_name                = "nsg-project102-prod-eastus-001"
      network_security_group_resource_group_name = "rg-project102-prod-eastus-001"
    }
  }
}

key_vault_access_policies = {
  # TODO: Modularize
  kvap_project102_prod_global_001 = {
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
  kvs_project102_prod_global_001 = {
    name                          = "MSSQLPASSWORD"
    key_vault_resource_group_name = "ssh-key"
    key_vault_name                = "coyvault"
  }
}

mssql_servers = {
  sql_project102_prod_eastus_001 = {
    name                  = "sql-project102-prod-eastus-001"
    resource_group        = "rg_project102_prod_eastus_001"
    version               = "12.0"
    administrator_login   = "azureuser"
    // TODO: Key vaulttan al
    admin_password_key_vault_secret = "kvs_project102_prod_global_001"
    tags = {
      name = "sql-project102-prod-eastus-001"
    }
    mssql_databases = {
      sqldb_project102_prod_eastus_001 = {
        name                        = "sqldb-project102-prod-eastus-001"
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
  }
  sql_project102_prod_westeurope_001 = {
    name                  = "sql-project102-prod-westeurope-001"
    resource_group        = "rg_project102_prod_westeurope_001"
    version               = "12.0"
    administrator_login   = "azureuser"
    admin_password_key_vault_secret = "kvs_project102_prod_global_001"
    tags = {
      name = "sql-project102-prod-westeurope-001"
    }
    mssql_databases = {
      sqldb_project102_prod_westeurope_001 = {
        name                        = "sqldb-project102-prod-westeurope-001"
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
  }
}

load_balancers = {
  lb_project102_prod_westeurope_001 = {
    name           = "lb-project102-prod-westeurope-001"
    resource_group = "rg_project102_prod_westeurope_001"
    sku            = "Standard"
    frontend_ip_configurations = {
      FrontendIPConfiguration1 = {
        name = "FrontendIPConfiguration1"
        subnet = {
          name                 = "snet-project102-prod-westeurope-002"
          virtual_network_name = "vnet-project102-prod-westeurope-001"
          resource_group_name  = "rg-project102-prod-westeurope-001"
        }
      }
    }
    lb_backend_address_pools = {
      lbbap_project102_prod_westeurope_001 = {
        name = "lbbap-project102-prod-westeurope-001"
      }
    }
    lb_probes = {
      lbp_project102_prod_westeurope_001 = {
        name     = "lbp-project102-prod-westeurope-001"
        protocol = "Tcp"
        port     = "80"
      }
    }
    lb_rules = {
      lbr_project102_prod_westeurope_001 = {
        name                           = "lbr-project102-prod-westeurope-001"
        probe                          = "lbp_project102_prod_westeurope_001"
        backend_address_pools          = ["lbbap_project102_prod_westeurope_001"]
        frontend_ip_configuration_name = "FrontendIPConfiguration1"
        protocol                       = "Tcp"
        frontend_port                  = "80"
        backend_port                   = "80"
      }
    }
    private_link_service = {
      name = "pl-project102-prod-westeurope-001"
      nat_ip_configurations = {
        NATIPConfiguration1 = {
          name    = "NATIPConfiguration1"
          subnet  = {
            name                 = "snet-project102-prod-westeurope-003"
            virtual_network_name = "vnet-project102-prod-westeurope-001"
            resource_group_name  = "rg-project102-prod-westeurope-001"
          }
          primary = true
        }
      }
    }
  }
}

linux_virtual_machine_scale_sets = {
  vmss_project102_prod_westeurope_001 = { # phonebook
    name           = "vmss-project102-prod-westeurope-001"
    resource_group = "rg_project102_prod_westeurope_001"
    sku            = "Standard_B1s"
    instances      = 1
    admin_username = "azureuser" // TODO: Key vault?
    shared_image = {
      name                = "myimagedefinitongen"
      gallery_name        = "mygallery"
      resource_group_name = "ssh-key"
    }
    upgrade_mode = "Rolling"
    health_probe = {
      load_balancer = "lb_project102_prod_westeurope_001"
      name          = "lbp-project102-prod-westeurope-001"
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
      name    = "NetworkInterface1"
      primary = true
      network_security_group = {
        name                = "nsg-project102-prod-westeurope-001"
        resource_group_name = "rg-project102-prod-westeurope-001"
      }
      ip_configurations = {
        IPConfiguration1 = {
          name    = "IPConfiguration1"
          primary = true
          subnet = {
            name                 = "snet-project102-prod-westeurope-001"
            virtual_network_name = "vnet-project102-prod-westeurope-001"
            resource_group_name  = "rg-project102-prod-westeurope-001"
          }
          load_balancer_backend_address_pools = {
            lb_project102_prod_westeurope_001 = {
              load_balancer_name                = "lb-project102-prod-westeurope-001"
              load_balancer_resource_group_name = "rg-project102-prod-westeurope-001"
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
  bas_project102_prod_westeurope_001 = {
    name           = "bas-project102-prod-westeurope-001"
    resource_group = "rg_project102_prod_westeurope_001"
    ip_configurations = {
      IPConfiguration1 = {
        name = "IPConfiguration1"
        subnet = {
          name                 = "AzureBastionSubnet"
          virtual_network_name = "vnet-project102-prod-westeurope-001"
          resource_group_name  = "rg-project102-prod-westeurope-001"
        }
        public_ip_address = {
          name                = "pip-project102-prod-westeurope-001"
          resource_group_name = "rg-project102-prod-westeurope-001"
        }
      }
    }
  }
}

private_dns_zones = {
  privatelink_database_windows_net_project102_prod_global_001 = {
    name           = "privatelink.database.windows.net"
    resource_group = "rg_project102_prod_eastus_001"
    virtual_network_links = {
      vnet_sql_us = {
        name = "vnet-sql-us"
        virtual_network = {
          name                = "vnet-project102-prod-eastus-003"
          resource_group_name = "rg-project102-prod-eastus-001"
        }
      }
      vnet_sql_eu = {
        name = "vnet-sql-eu"
        virtual_network = {
          name                = "vnet-project102-prod-westeurope-002"
          resource_group_name = "rg-project102-prod-westeurope-001"
        }
      }
      vnet_app_us = {
        name = "vnet-app-us"
        virtual_network = {
          name                = "vnet-project102-prod-eastus-001"
          resource_group_name = "rg-project102-prod-eastus-001"
        }
      }
      vnet_app_eu = {
        name = "vnet-app-eu"
        virtual_network = {
          name                = "vnet-project102-prod-westeurope-001"
          resource_group_name = "rg-project102-prod-westeurope-001"
        }
      }
    }
  }
}

private_endpoints = {
  pep_project102_prod_eastus_001 = { # sql-us
    name = "pep-project102-prod-eastus-001"
    attached_resource = {
      name = "sql-project102-prod-eastus-001"
      type = "Microsoft.Sql/servers"
      required_tags = {
        name = "sql-project102-prod-eastus-001"
      }
    }
    resource_group = "rg_project102_prod_eastus_001"
    subnet         = {
      name = "snet-project102-prod-eastus-006"
      virtual_network_name = "vnet-project102-prod-eastus-003"
    }
    private_service_connection = {
      name = "PrivateServiceConnection"
      is_manual_connection = false
      subresource_names    = ["sqlServer"]
    }
    private_dns_zone_group = {
      name = "PrivateDNSZoneGroup"
      private_dns_zones = [
        {
          name = "privatelink.database.windows.net"
          resource_group_name = "rg-project102-prod-westeurope-001"
        }
      ]
    }
  }
  pep_project102_prod_westeurope_001 = { # sql-eu
    name = "pep-project102-prod-westeurope-001"
    attached_resource = {
      name = "sql-project102-prod-westeurope-001"
      type = "Microsoft.Sql/servers"
      required_tags = {
        name = "sql-project102-prod-westeurope-001"
      }
    }
    resource_group = "rg_project102_prod_westeurope_001"
    subnet         = {
      name = "snet-project102-prod-westeurope-007"
      virtual_network_name = "vnet-project102-prod-westeurope-001"
    }
    private_service_connection = {
      name = "PrivateServiceConnection"
      is_manual_connection = false
      subresource_names    = ["sqlServer"]
    }
    private_dns_zone_group = {
      name = "PrivateDNSZoneGroup"
      private_dns_zones = [
        {
          name = "privatelink.database.windows.net"
          resource_group_name = "rg-project102-prod-westeurope-001"
        }
      ]
    }
  }
}

kubernetes_clusters = {
  aks_project102_prod_eastus_001 = {
    subnet_aks = {
      name                 = "snet-project102-prod-eastus-002"
      virtual_network_name = "vnet-project102-prod-eastus-001"
      resource_group_name  = "rg-project102-prod-eastus-001"
    }
    snet_agw = {
      name                 = "snet-project102-prod-eastus-003"
      virtual_network_name = "vnet-project102-prod-eastus-001"
      resource_group_name  = "rg-project102-prod-eastus-001"
    }
    name                    = "aks-project102-prod-eastus-001"
    resource_group          = "rg_project102_prod_eastus_001"
    private_cluster_enabled = true
    default_node_pool = {
      name       = "default-node-pool"
      node_count = 1
      vm_size    = "Standard_B2s"
    }
    identity = {
      type = "SystemAssigned"
    }
    ingress_application_gateway = {
      enabled = true
      name = "agw-project102-prod-eastus-001"
    }
    network_profile = {
      network_plugin = "azure"
      outbound_type  = "userDefinedRouting"
    }
  }
}

front_doors = {
  afd_project102_prod_global_001 = { # phonebook
    name           = "afd-project102-prod-global-001"
    resource_group = "rg_project102_prod_eastus_001"
    sku_name       = "Premium_AzureFrontDoor"
    endpoints      = { # phonebook
      afde_project102_prod_global_001 = {
        name = "afde-project102-prod-global-001"
      }
    }
    origin_groups = {
      afdog_project102_prod_global_001 = {
        name                                                      = "afdog-project102-prod-global-001"
        session_affinity_enabled                                  = false
        restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
        health_probes = {
          http = {
            interval_in_seconds = 240
            path                = "/"
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
      afdo_project102_prod_global_001 = {
        name                           = "afdo-project102-prod-global-001"
        cdn_frontdoor_origin_group     = "afdog_project102_prod_global_001"
        enabled                        = true
        certificate_name_check_enabled = true
        host = {
          resource_group_name = "rg-project102-prod-westeurope-001"
          name                = "lb-project102-prod-westeurope-001"
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
            name                = "lb-project102-prod-westeurope-001-pls"
            resource_group_name = "rg-project102-prod-westeurope-001"
          }
        }
      }
    }
    routes = {
      afdr_project102_prod_global_001 = {
        name                       = "afdr-project102-prod-global-001"
        cdn_frontdoor_endpoint     = "afde_project102_prod_global_001"
        cdn_frontdoor_origin_group = "afdog_project102_prod_global_001"
        cdn_frontdoor_origins      = ["afdo_project102_prod_global_001"]
        cdn_frontdoor_rule_sets       = ["afdrs_project102_prod_global_001"]
        enabled                = true
        forwarding_protocol    = "HttpOnly"
        https_redirect_enabled = false
        patterns_to_match      = ["/*"]
        supported_protocols    = ["Http", "Https"]
      }
    }
    rule_sets = {
      afdrs_project102_prod_global_001 = {
        name = "afde-project102-prod-global-001"
      }
    }
    rules = [
      afdr_project102_prod_global_001 = { # HTTPS to HTTP
        name = "afdr-project102-prod-global-001"
        rule_set = "afdrs_project102_prod_global_001"
        conditions = {
          request_scheme_conditions = {
            equal_https = {
              operator         = "Equal"
              match_values     = ["HTTPS"]
            }
          }
        }
        actions = {
          url_redirect_actions = {
            movedhttp = {
              redirect_type        = "Moved"
              redirect_protocol    = "Http"
              destination_hostname = ""
            }
          }
        }
      }
    ]
  }
}