terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.66.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "ssh-key"
    storage_account_name = "coyhubstorage"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# module "bas_project102_prod_westeurope_001" {
#   source = "./modules/bastion_host"

#   name                = var.bas_project102_prod_westeurope_001.name
#   resource_group_name = var.bas_project102_prod_westeurope_001.resource_group_name
#   location            = var.bas_project102_prod_westeurope_001.location
#   ip_configuration    = var.bas_project102_prod_westeurope_001.ip_configuration

#   depends_on = [
#     module.vmss_project102_prod_westeurope_001,
#     module.pip_project102_prod_westeurope_001
#   ]
# }

module "fwp_project102_prod_eastus_001" {
  source = "./modules/firewall_policy"

  name                   = var.fwp_project102_prod_eastus_001.name
  resource_group_name    = var.fwp_project102_prod_eastus_001.resource_group_name
  location               = var.fwp_project102_prod_eastus_001.location
  sku                    = var.fwp_project102_prod_eastus_001.sku
  rule_collection_groups = var.fwp_project102_prod_eastus_001.rule_collection_groups

  depends_on = [
    module.rg_project102_prod_eastus_001
  ]
}

# module "afd_project102_prod_global_001" {
#   source = "./modules/front_door"

#   name                = var.afd_project102_prod_global_001.name
#   resource_group_name = var.afd_project102_prod_global_001.resource_group_name
#   sku_name            = var.afd_project102_prod_global_001.sku_name
#   endpoints           = var.afd_project102_prod_global_001.endpoints
#   origin_groups       = var.afd_project102_prod_global_001.origin_groups
#   origins             = var.afd_project102_prod_global_001.origins
#   routes              = var.afd_project102_prod_global_001.routes
#   rule_sets           = var.afd_project102_prod_global_001.rule_sets
#   rules               = var.afd_project102_prod_global_001.rules

#   depends_on = [
#     module.lb_project102_prod_westeurope_001
#     # module.aks_project102_prod_eastus_001
#   ]
# }

module "kvap_project102_prod_global_001" {
  source = "./modules/key_vault_access_policy"

  key_vault          = var.kvap_project102_prod_global_001.key_vault
  object             = var.kvap_project102_prod_global_001.object
  key_permissions    = var.kvap_project102_prod_global_001.key_permissions
  secret_permissions = var.kvap_project102_prod_global_001.secret_permissions
}

module "kvs_project102_prod_global_001" {
  source = "./modules/key_vault_secret"

  name      = var.kvs_project102_prod_global_001.name
  key_vault = var.kvs_project102_prod_global_001.key_vault

  depends_on = [
    module.kvap_project102_prod_global_001
  ]
}

# module "aks_project102_prod_eastus_001" {
#   source   = "./modules/kubernetes_cluster"

#   name                          = var.aks_project102_prod_eastus_001.name
#   resource_group_name           = var.aks_project102_prod_eastus_001.resource_group_name
#   location                      = var.aks_project102_prod_eastus_001.location
#   public_network_access_enabled = var.aks_project102_prod_eastus_001.public_network_access_enabled
#   private_cluster_enabled       = var.aks_project102_prod_eastus_001.private_cluster_enabled
#   subnet_aks                    = var.aks_project102_prod_eastus_001.subnet_aks
#   default_node_pool             = var.aks_project102_prod_eastus_001.default_node_pool
#   identity                      = var.aks_project102_prod_eastus_001.identity
#   subnet_agw                    = var.aks_project102_prod_eastus_001.subnet_agw
#   ingress_application_gateway   = var.aks_project102_prod_eastus_001.ingress_application_gateway
#   network_profile               = var.aks_project102_prod_eastus_001.network_profile

#   depends_on = [
#     module.vnet_project102_prod_eastus_001,
#     module.fw_project102_prod_eastus_001,
#     module.vwan_project102_prod_eastus_001
#   ]
# }

module "vm_project102_prod_eastus_001" {
  source = "./modules/linux_virtual_machine"

  name                               = var.vm_project102_prod_eastus_001.name
  resource_group_name                = var.vm_project102_prod_eastus_001.resource_group_name
  location                           = var.vm_project102_prod_eastus_001.location
  network_interface                  = var.vm_project102_prod_eastus_001.network_interface
  size                               = var.vm_project102_prod_eastus_001.size
  delete_os_disk_on_termination      = var.vm_project102_prod_eastus_001.delete_os_disk_on_termination
  delete_data_disks_on_termination   = var.vm_project102_prod_eastus_001.delete_data_disks_on_termination
  identity                           = var.vm_project102_prod_eastus_001.identity
  storage_image_reference            = var.vm_project102_prod_eastus_001.storage_image_reference
  storage_os_disk                    = var.vm_project102_prod_eastus_001.storage_os_disk
  os_profile                         = var.vm_project102_prod_eastus_001.os_profile
  os_profile_linux_config            = var.vm_project102_prod_eastus_001.os_profile_linux_config
  boot_diagnostics                   = var.vm_project102_prod_eastus_001.boot_diagnostics
  network_security_group_association = var.vm_project102_prod_eastus_001.network_security_group_association

  depends_on = [
    module.vnet_project102_prod_eastus_004,
    module.pip_project102_prod_eastus_001,
    module.nsg_project102_prod_eastus_001
  ]
}

# module "vmss_project102_prod_westeurope_001" {
#   source = "./modules/linux_virtual_machine_scale_set"

#   name                   = var.vmss_project102_prod_westeurope_001.name
#   resource_group_name    = var.vmss_project102_prod_westeurope_001.resource_group_name
#   location               = var.vmss_project102_prod_westeurope_001.location
#   sku                    = var.vmss_project102_prod_westeurope_001.sku
#   instances              = var.vmss_project102_prod_westeurope_001.instances
#   admin_username         = var.vmss_project102_prod_westeurope_001.admin_username
#   shared_image           = var.vmss_project102_prod_westeurope_001.shared_image
#   upgrade_mode           = var.vmss_project102_prod_westeurope_001.upgrade_mode
#   load_balancer          = var.vmss_project102_prod_westeurope_001.load_balancer
#   health_probe_name      = var.vmss_project102_prod_westeurope_001.health_probe_name
#   admin_ssh_key          = var.vmss_project102_prod_westeurope_001.admin_ssh_key
#   os_disk                = var.vmss_project102_prod_westeurope_001.os_disk
#   network_interface      = var.vmss_project102_prod_westeurope_001.network_interface
#   rolling_upgrade_policy = var.vmss_project102_prod_westeurope_001.rolling_upgrade_policy

#   depends_on = [
#     module.vnet_project102_prod_westeurope_001,
#     module.nsg_project102_prod_westeurope_001,
#     module.lb_project102_prod_westeurope_001
#   ]
# }

# module "lb_project102_prod_westeurope_001" {
#   source = "./modules/load_balancer"

#   name                       = var.lb_project102_prod_westeurope_001.name
#   resource_group_name        = var.lb_project102_prod_westeurope_001.resource_group_name
#   location                   = var.lb_project102_prod_westeurope_001.location
#   sku                        = var.lb_project102_prod_westeurope_001.sku
#   frontend_ip_configurations = var.lb_project102_prod_westeurope_001.frontend_ip_configurations
#   lb_backend_address_pools   = var.lb_project102_prod_westeurope_001.lb_backend_address_pools
#   lb_probes                  = var.lb_project102_prod_westeurope_001.lb_probes
#   lb_rules                   = var.lb_project102_prod_westeurope_001.lb_rules
#   private_link_service       = var.lb_project102_prod_westeurope_001.private_link_service

#   depends_on = [
#     module.vnet_project102_prod_westeurope_001
#   ]
# }

module "nsg_project102_prod_eastus_001" {
  source = "./modules/network_security_group"

  name                = var.nsg_project102_prod_eastus_001.name
  resource_group_name = var.nsg_project102_prod_eastus_001.resource_group_name
  location            = var.nsg_project102_prod_eastus_001.location
  security_rules      = var.nsg_project102_prod_eastus_001.security_rules

  depends_on = [
    module.rg_project102_prod_eastus_001
  ]
}

# module "nsg_project102_prod_westeurope_001" {
#   source = "./modules/network_security_group"

#   name                = var.nsg_project102_prod_westeurope_001.name
#   resource_group_name = var.nsg_project102_prod_westeurope_001.resource_group_name
#   location            = var.nsg_project102_prod_westeurope_001.location
#   security_rules      = var.nsg_project102_prod_westeurope_001.security_rules

#   depends_on = [
#     module.rg_project102_prod_westeurope_001
#   ]
# }

module "privatelink_database_windows_net_project102_prod_global_001" {
  source = "./modules/private_dns_zone"

  name                  = var.privatelink_database_windows_net_project102_prod_global_001.name
  resource_group_name   = var.privatelink_database_windows_net_project102_prod_global_001.resource_group_name
  virtual_network_links = var.privatelink_database_windows_net_project102_prod_global_001.virtual_network_links

  depends_on = [
    module.vnet_project102_prod_eastus_001,
    module.vnet_project102_prod_eastus_003,
    module.vnet_project102_prod_westeurope_001,
    module.vnet_project102_prod_westeurope_002
  ]
}

module "pep_project102_prod_eastus_001" {
  source = "./modules/private_endpoint"

  name                       = var.pep_project102_prod_eastus_001.name
  resource_group_name        = var.pep_project102_prod_eastus_001.resource_group_name
  location                   = var.pep_project102_prod_eastus_001.location
  subnet                     = var.pep_project102_prod_eastus_001.subnet
  attached_resource          = var.pep_project102_prod_eastus_001.attached_resource
  private_service_connection = var.pep_project102_prod_eastus_001.private_service_connection
  private_dns_zone_group     = var.pep_project102_prod_eastus_001.private_dns_zone_group

  depends_on = [
    module.privatelink_database_windows_net_project102_prod_global_001,
    module.sql_project102_prod_eastus_001
  ]
}

# module "pep_project102_prod_westeurope_001" {
#   source = "./modules/private_endpoint"

#   name                       = var.pep_project102_prod_westeurope_001.name
#   resource_group_name        = var.pep_project102_prod_westeurope_001.resource_group_name
#   location                   = var.pep_project102_prod_westeurope_001.location
#   subnet                     = var.pep_project102_prod_westeurope_001.subnet
#   attached_resource          = var.pep_project102_prod_westeurope_001.attached_resource
#   private_service_connection = var.pep_project102_prod_westeurope_001.private_service_connection
#   private_dns_zone_group     = var.pep_project102_prod_westeurope_001.private_dns_zone_group

#   depends_on = [
#     module.privatelink_database_windows_net_project102_prod_global_001,
#     module.sql_project102_prod_westeurope_001
#   ]
# }

module "pip_project102_prod_eastus_001" {
  source = "./modules/public_ip_address"

  name                = var.pip_project102_prod_eastus_001.name
  resource_group_name = var.pip_project102_prod_eastus_001.resource_group_name
  location            = var.pip_project102_prod_eastus_001.location
  allocation_method   = var.pip_project102_prod_eastus_001.allocation_method
  sku                 = var.pip_project102_prod_eastus_001.sku

  depends_on = [
    module.rg_project102_prod_eastus_001
  ]
}

# module "pip_project102_prod_westeurope_001" {
#   source = "./modules/public_ip_address"

#   name                = var.pip_project102_prod_westeurope_001.name
#   resource_group_name = var.pip_project102_prod_westeurope_001.resource_group_name
#   location            = var.pip_project102_prod_westeurope_001.location
#   allocation_method   = var.pip_project102_prod_westeurope_001.allocation_method
#   sku                 = var.pip_project102_prod_westeurope_001.sku

#   depends_on = [
#     module.rg_project102_prod_westeurope_001
#   ]
# }

module "rg_project102_prod_eastus_001" {
  source = "./modules/resource_group"

  name     = var.rg_project102_prod_eastus_001.name
  location = var.rg_project102_prod_eastus_001.location
}

module "rg_project102_prod_westeurope_001" {
  source = "./modules/resource_group"

  name     = var.rg_project102_prod_westeurope_001.name
  location = var.rg_project102_prod_westeurope_001.location
}

module "sql_project102_prod_eastus_001" {
  source = "./modules/mssql_server"

  name                = var.sql_project102_prod_eastus_001.name
  resource_group_name = var.sql_project102_prod_eastus_001.resource_group_name
  location            = var.sql_project102_prod_eastus_001.location
  msqql_version       = var.sql_project102_prod_eastus_001.version
  administrator_login = var.sql_project102_prod_eastus_001.administrator_login
  tags                = var.sql_project102_prod_eastus_001.tags
  mssql_databases     = var.sql_project102_prod_eastus_001.mssql_databases

  depends_on = [
    module.rg_project102_prod_eastus_001,
    module.kvs_project102_prod_global_001
  ]
}

# module "sql_project102_prod_westeurope_001" {
#   source = "./modules/mssql_server"

#   name                = var.sql_project102_prod_westeurope_001.name
#   resource_group_name = var.sql_project102_prod_westeurope_001.resource_group_name
#   location            = var.sql_project102_prod_westeurope_001.location
#   msqql_version       = var.sql_project102_prod_westeurope_001.version
#   administrator_login = var.sql_project102_prod_westeurope_001.administrator_login
#   tags                = var.sql_project102_prod_westeurope_001.tags
#   mssql_databases     = var.sql_project102_prod_westeurope_001.mssql_databases

#   depends_on = [
#     module.rg_project102_prod_westeurope_001,
#     module.kvs_project102_prod_global_001,
#     module.sql_project102_prod_eastus_001
#   ]
# }

module "vnet_project102_prod_eastus_001" {
  source = "./modules/virtual_network"

  name                = var.vnet_project102_prod_eastus_001.name
  resource_group_name = var.vnet_project102_prod_eastus_001.resource_group_name
  location            = var.vnet_project102_prod_eastus_001.location
  address_space       = var.vnet_project102_prod_eastus_001.address_space
  subnets             = var.vnet_project102_prod_eastus_001.subnets

  depends_on = [
    module.rg_project102_prod_eastus_001
  ]
}

module "vnet_project102_prod_eastus_002" {
  source = "./modules/virtual_network"

  name                = var.vnet_project102_prod_eastus_002.name
  resource_group_name = var.vnet_project102_prod_eastus_002.resource_group_name
  location            = var.vnet_project102_prod_eastus_002.location
  address_space       = var.vnet_project102_prod_eastus_002.address_space
  subnets             = var.vnet_project102_prod_eastus_002.subnets

  depends_on = [
    module.rg_project102_prod_eastus_001
  ]
}

module "vnet_project102_prod_eastus_003" {
  source = "./modules/virtual_network"

  name                = var.vnet_project102_prod_eastus_003.name
  resource_group_name = var.vnet_project102_prod_eastus_003.resource_group_name
  location            = var.vnet_project102_prod_eastus_003.location
  address_space       = var.vnet_project102_prod_eastus_003.address_space
  subnets             = var.vnet_project102_prod_eastus_003.subnets

  depends_on = [
    module.rg_project102_prod_eastus_001
  ]
}

module "vnet_project102_prod_eastus_004" {
  source = "./modules/virtual_network"

  name                = var.vnet_project102_prod_eastus_004.name
  resource_group_name = var.vnet_project102_prod_eastus_004.resource_group_name
  location            = var.vnet_project102_prod_eastus_004.location
  address_space       = var.vnet_project102_prod_eastus_004.address_space
  subnets             = var.vnet_project102_prod_eastus_004.subnets

  depends_on = [
    module.rg_project102_prod_eastus_001
  ]
}

module "vnet_project102_prod_westeurope_001" {
  source = "./modules/virtual_network"

  name                = var.vnet_project102_prod_westeurope_001.name
  resource_group_name = var.vnet_project102_prod_westeurope_001.resource_group_name
  location            = var.vnet_project102_prod_westeurope_001.location
  address_space       = var.vnet_project102_prod_westeurope_001.address_space
  subnets             = var.vnet_project102_prod_westeurope_001.subnets

  depends_on = [
    module.rg_project102_prod_westeurope_001
  ]
}

module "vnet_project102_prod_westeurope_002" {
  source = "./modules/virtual_network"

  name                = var.vnet_project102_prod_westeurope_002.name
  resource_group_name = var.vnet_project102_prod_westeurope_002.resource_group_name
  location            = var.vnet_project102_prod_westeurope_002.location
  address_space       = var.vnet_project102_prod_westeurope_002.address_space
  subnets             = var.vnet_project102_prod_westeurope_002.subnets

  depends_on = [
    module.rg_project102_prod_westeurope_001
  ]
}

module "peer_project102_prod_global_001" {
  source = "./modules/virtual_network_peering"

  name                    = var.peer_project102_prod_global_001.name
  resource_group_name     = var.peer_project102_prod_global_001.resource_group_name
  virtual_network_name    = var.peer_project102_prod_global_001.virtual_network_name
  remote_virtual_network  = var.peer_project102_prod_global_001.remote_virtual_network
  allow_forwarded_traffic = var.peer_project102_prod_global_001.allow_forwarded_traffic

  depends_on = [
    module.vnet_project102_prod_eastus_003,
    module.vnet_project102_prod_westeurope_001
  ]
}

module "peer_project102_prod_global_002" {
  source = "./modules/virtual_network_peering"

  name                    = var.peer_project102_prod_global_002.name
  resource_group_name     = var.peer_project102_prod_global_002.resource_group_name
  virtual_network_name    = var.peer_project102_prod_global_002.virtual_network_name
  remote_virtual_network  = var.peer_project102_prod_global_002.remote_virtual_network
  allow_forwarded_traffic = var.peer_project102_prod_global_002.allow_forwarded_traffic

  depends_on = [
    module.vnet_project102_prod_eastus_003,
    module.vnet_project102_prod_westeurope_001
  ]
}

module "vwan_project102_prod_eastus_001" {
  source = "./modules/virtual_wan"

  name                = var.vwan_project102_prod_eastus_001.name
  resource_group_name = var.vwan_project102_prod_eastus_001.resource_group_name
  location            = var.vwan_project102_prod_eastus_001.location
  virtual_hubs        = var.vwan_project102_prod_eastus_001.virtual_hubs

  depends_on = [
    module.vnet_project102_prod_eastus_002,
    module.vnet_project102_prod_eastus_003,
    module.vnet_project102_prod_eastus_004,
    module.fwp_project102_prod_eastus_001
  ]
}

# module "nm_project102_prod_westeurope_001" {
#   source = "./modules/network_manager"

#   name                = var.nm_project102_prod_westeurope_001.name
#   location            = var.nm_project102_prod_westeurope_001.location
#   resource_group_name = var.nm_project102_prod_westeurope_001.resource_group_name
#   scope_accesses      = var.nm_project102_prod_westeurope_001.scope_accesses
#   scope               = var.nm_project102_prod_westeurope_001.scope
#   network_groups      = var.nm_project102_prod_westeurope_001.network_groups

#   depends_on = [
#     module.rg_project102_prod_westeurope_001
#   ]
# }