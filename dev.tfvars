resource_groups = {
  rg-eastus     = "East Us"
  rg-westeurope = "West Europe"
}

virtual_networks = {
  #EAST US
  vnet-hub = {
    resource_group = "rg-eastus"
    address_space  = ["10.0.0.0/16"]
  }
  vnet-app = {
    resource_group = "rg-eastus"
    address_space  = ["10.1.0.0/16"]
  }
  vnet-acr = {
    resource_group = "rg-eastus"
    address_space  = ["10.2.0.0/16"]
  }
  vnet-db = {
    resource_group = "rg-eastus"
    address_space  = ["10.3.0.0/16"]
  }
  vnet-agent = {
    resource_group = "rg-eastus"
    address_space  = ["10.4.0.0/16"]
  }
  #WEST euROPE
  vnet-app-eu = {
    resource_group = "rg-westeurope"
    address_space  = ["10.11.0.0/16"]
  }
  vnet-db-eu = {
    resource_group = "rg-westeurope"
    address_space  = ["10.12.0.0/16"]
  }
}

subnets = {
  #EAST US
  vnet_hub_subnet_firewall = {
    name             = "AzureFirewallSubnet"
    resource_group   = "rg-eastus"
    virtual_network  = "vnet-hub"
    address_prefixes = ["10.0.0.0/26"]
    delegation       = false
    delegation_name  = ""
  }

  vnet_hub_subnet_firewall_management = {
    name             = "AzureFirewallSubnetManagement"
    resource_group   = "rg-eastus"
    virtual_network  = "vnet-hub"
    address_prefixes = ["10.0.1.0/26"]
    delegation       = false
    delegation_name  = ""
  }

  vnet_app_subnet_app = {
    name             = "subnet-app"
    resource_group   = "rg-eastus"
    virtual_network  = "vnet-app"
    address_prefixes = ["10.1.0.0/24"]
    delegation       = false
    delegation_name  = ""
  }

  vnet_app_subnet_bastion = {
    name             = "AzureBastionSubnet"
    resource_group   = "rg-eastus"
    virtual_network  = "vnet-app"
    address_prefixes = ["10.1.1.0/24"]
    delegation       = false
    delegation_name  = ""
  }

  vnet_acr_subnet_acr = {
    name             = "subnet-acr"
    resource_group   = "rg-eastus"
    virtual_network  = "vnet-acr"
    address_prefixes = ["10.2.0.0/24"]
    delegation       = false
    delegation_name  = ""
  }

  vnet_db_subnet_db = {
    name             = "subnet-db"
    resource_group   = "rg-eastus"
    virtual_network  = "vnet-db"
    address_prefixes = ["10.3.0.0/24"]
    delegation       = false
    delegation_name  = ""
  }

  vnet_agent_subnet_agent = {
    name             = "subnet-agent"
    resource_group   = "rg-eastus"
    virtual_network  = "vnet-agent"
    address_prefixes = ["10.4.0.0/24"]
    delegation       = false
    delegation_name  = ""
  }

  #WEST EUROPE
  vnet_app_eu_subnet_app = {
    name             = "subnet-app"
    resource_group   = "rg-westeurope"
    virtual_network  = "vnet-app-eu"
    address_prefixes = ["10.11.0.0/24"]
    delegation       = false
    delegation_name  = ""
  }

  vnet_db_eu_subnet_db = {
    name             = "subnet-db"
    resource_group   = "rg-westeurope"
    virtual_network  = "vnet-db-eu"
    address_prefixes = ["10.12.0.0/24"]
    delegation       = false
    delegation_name  = ""
  }
}

vnet_peerings = {
  db-hub = {
    virtual_network        = "vnet-db"
    remote_virtual_network = "vnet-hub"
    resource_group         = "rg-eastus"
  }
  hub-db = {
    virtual_network        = "vnet-hub"
    remote_virtual_network = "vnet-db"
    resource_group         = "rg-eastus"
  }
  app-hub = {
    virtual_network        = "vnet-app"
    remote_virtual_network = "vnet-hub"
    resource_group         = "rg-eastus"
  }
  hub-app = {
    virtual_network        = "vnet-hub"
    remote_virtual_network = "vnet-app"
    resource_group         = "rg-eastus"
  }
  acr-hub = {
    virtual_network        = "vnet-acr"
    remote_virtual_network = "vnet-hub"
    resource_group         = "rg-eastus"
  }
  hub-acr = {
    virtual_network        = "vnet-hub"
    remote_virtual_network = "vnet-acr"
    resource_group         = "rg-eastus"
  }
  appeu-dbeu = {
    virtual_network        = "vnet-app-eu"
    remote_virtual_network = "vnet-db-eu"
    resource_group         = "rg-westeurope"
  }
  dbeu-appeu = {
    virtual_network        = "vnet-app-eu"
    remote_virtual_network = "vnet-db"
    resource_group         = "rg-westeurope"
  }
}

route_tables = {
  route-table-subnet-app = {
    resource_group = "rg-eastus"
    routes = {
      subnet-app-to-subnet-acr = {
        address_prefix         = "10.2.0.0/24"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.0.4"
      }
      subnet-app-to-subnet-db = {
        address_prefix         = "10.3.0.0/24"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.0.4"
      }
    }
  }
  route-table-subnet-db = {
    resource_group = "rg-eastus"
    routes = {
      subnet-db-to-subnet-app = {
        address_prefix         = "10.1.0.0/24"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.0.4"
      }
    }
  }
  route-table-subnet-acr = {
    resource_group = "rg-eastus"
    routes = {
      subnet-acr-to-everywhere = {
        address_prefix         = "10.0.0.0/8"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.4.0.4"
      }
    }
  }
}

route_table_associations = {
  route-table-subnet-app = "vnet_app_subnet_app"
  route-table-subnet-acr = "vnet_acr_subnet_acr"
  route-table-subnet-db  = "vnet_db_subnet_db"
}

acrs = {
  coyhub = {
    sku                           = "Premium"
    admin_enabled                 = false
    public_network_access_enabled = false
    network_rule_bypass_option    = "None"
    resource_group                = "rg-eastus"
  }
}

public_ip_addresses = {
  public-ip-hub-firewall-management = {
    allocation_method = "Static"
    sku               = "Standard"
    resource_group    = "rg-eastus"
  }
  public-ip-application-gateway = {
    allocation_method = "Static"
    sku               = "Standard"
    resource_group    = "rg-eastus"
  }
  public-ip-agent = {
    allocation_method = "Static"
    sku               = "Standard"
    resource_group    = "rg-eastus"
  }
}

network_security_groups = {
  nsg-ssh = {
    resource_group = "rg-eastus"
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
}
linux_virtual_machines = {
  vm-agent = {
    resource_group                                          = "rg-eastus"
    vm_size                                                 = "Standard_B1s"
    delete_data_disks_on_termination                        = true
    delete_os_disk_on_termination                           = true
    identity_enabled                                        = true
    vm_identity_type                                        = "SystemAssigned"
    storage_image_reference_publisher                       = "Canonical"
    storage_image_reference_offer                           = "UbuntuServer"
    storage_image_reference_sku                             = "18.04-LTS"
    storage_image_reference_version                         = "latest"
    storage_os_disk_name                                    = "myosdisk1"
    storage_os_disk_caching                                 = "ReadWrite"
    storage_os_disk_create_option                           = "FromImage"
    storage_os_disk_managed_disk_type                       = "Standard_LRS"
    admin_username                                          = "azureuser"
    custom_data                                             = "modules/VirtualMachine/agent.sh"
    os_profile_linux_config_disable_password_authentication = true
    ip_configuration_name                                   = "testconfiguration1"
    ip_configuration_subnet                                 = "vnet_agent_subnet_agent"
    ip_configuration_private_ip_address_allocation          = "Dynamic"
    ip_configuration_public_ip_assigned                     = true
    ip_configuration_public_ip_address                      = "public-ip-agent"
    ssh_key_rg                                              = "ssh-key"
    ssh_key_name                                            = "azure"
    nsg_association_enabled                                 = true
    nsg                                                     = "nsg-ssh"
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
  }
  coyhub-db-eu = {
    resource_group        = "rg-westeurope"
    administrator_login   = "azureuser"
    admin_password_secret = "key_vault_secret_mssql_password"
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

azapi_resources = {
  db-sync-group = {
    type = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
    parent = "coyhub-db-us"
    syncDatabase = "phonebook_us"
    schema_validation_enabled = false
  }
}

arm_template_deployments = {
  db-sync-group-member-eu = {
    resource_group = "rg-eastus"
    deployment_mode = "Incremental"
  }
}