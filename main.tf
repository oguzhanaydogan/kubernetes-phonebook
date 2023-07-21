terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
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

module "resource_groups" {
  source   = "./modules/ResourceGroup"
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
}

module "virtual_networks" {
  source   = "./modules/VirtualNetworkWithSubnets"
  for_each = var.virtual_networks

  name                = each.value.name
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  address_space       = each.value.address_space
  subnets             = each.value.subnets
}

module "virtual_wans" {
  source = "./modules/VirtualWANWithHubs"
  for_each = var.virtual_wans

  name = each.value.name
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location = module.resource_groups[each.value.resource_group].location
  virtual_hubs = each.value.virtual_hubs
  
  depends_on = [ module.virtual_networks ]
}

module "virtual_network_peerings" {
  source   = "./modules/VirtualNetworkPeering"
  for_each = var.vnet_peerings

  resource_group_name       = module.resource_groups[each.value.resource_group].name
  name                      = each.value.name
  virtual_network_name      = module.virtual_networks[each.value.virtual_network].name
  remote_virtual_network_id = module.virtual_networks[each.value.remote_virtual_network].id
  allow_forwarded_traffic   = each.value.allow_forwarded_traffic
}

module "route_tables" {
  source   = "./modules/RouteTable"
  for_each = var.route_tables

  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  name                = each.value.name
  routes              = each.value.routes
  subnet_associations = each.value.subnet_associations

  depends_on = [module.virtual_networks]
}

# module "acrs" {
#   source                        = "./modules/ContainerRegistry"
#   for_each                      = var.acrs
#   name                          = each.key
#   resource_group_name           = module.resource_groups[each.value.resource_group].name
#   location                      = module.resource_groups[each.value.resource_group].location
#   admin_enabled                 = each.value.admin_enabled
#   sku                           = each.value.sku
#   public_network_access_enabled = each.value.public_network_access_enabled
#   network_rule_bypass_option    = each.value.network_rule_bypass_option
# }

module "public_ip_addresses" {
  source   = "./modules/PublicIPAddress"
  for_each = var.public_ip_addresses

  name                = each.value.name
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}

module "network_security_groups" {
  source   = "./modules/NetworkSecurityGroup"
  for_each = var.network_security_groups

  name                = each.value.name
  location            = module.resource_groups[each.value.resource_group].location
  resource_group_name = module.resource_groups[each.value.resource_group].name
  security_rules      = each.value.security_rules
}

module "linux_virtual_machines" {
  source   = "./modules/VirtualMachine"
  for_each = var.linux_virtual_machines

  name                               = each.value.name
  location                           = module.resource_groups[each.value.resource_group].location
  resource_group_name                = module.resource_groups[each.value.resource_group].name
  network_interface                  = each.value.network_interface
  size                               = each.value.size
  delete_os_disk_on_termination      = each.value.delete_os_disk_on_termination
  delete_data_disks_on_termination   = each.value.delete_data_disks_on_termination
  identity                           = each.value.identity
  storage_image_reference            = each.value.storage_image_reference
  storage_os_disk                    = each.value.storage_os_disk
  os_profile                         = each.value.os_profile
  os_profile_linux_config            = each.value.os_profile_linux_config
  network_security_group_association = each.value.network_security_group_association
  depends_on = [
    module.network_security_groups,
    module.virtual_networks
  ]
}

data "azurerm_key_vault" "key_vault" {
  name                = "coyvault"
  resource_group_name = "ssh-key"
}

data "azurerm_client_config" "client_config" {}

module "key_vault_access_policies" {
  source   = "./modules/KeyVaultAccessPolicy"
  for_each = var.key_vault_access_policies

  key_vault_name                = each.value.key_vault_name
  key_vault_resource_group_name = each.value.key_vault_resource_group_name
  object_id                     = data.azurerm_client_config.client_config.object_id
  key_permissions               = each.value.key_permissions
  secret_permissions            = each.value.secret_permissions
}

module "key_vault_secrets" {
  source   = "./modules/KeyVaultSecret"
  for_each = var.key_vault_secrets

  name                          = each.value.name
  key_vault_resource_group_name = each.value.key_vault_resource_group_name
  key_vault_name                = each.value.key_vault_name

  depends_on = [
    module.key_vault_access_policies
  ]
}

module "mssql_servers" {
  source   = "./modules/MSSQLServerWithDatabases"
  for_each = var.mssql_servers

  name                         = each.value.name
  resource_group_name          = module.resource_groups[each.value.resource_group].name
  location                     = module.resource_groups[each.value.resource_group].location
  msqql_version                = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = module.key_vault_secrets[each.value.admin_password_key_vault_secret].value
  tags                         = each.value.tags
  mssql_databases = each.value.mssql_databases
}

# module "azapi_create_phonebook_sync_group" {
#   source    = "./modules/AzAPI"
#   name      = "phonebook-sync-group"
#   type      = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
#   parent_id = module.mssql_databases["phonebook_us"].id
#   body = {
#     properties = {
#       conflictResolutionPolicy = "HubWin"
#       hubDatabasePassword      = "Test1234."
#       hubDatabaseUserName      = "azureuser"
#       interval                 = 60
#       syncDatabaseId           = "${module.mssql_databases["phonebook_us"].id}"
#       usePrivateLinkConnection = false
#     }
#   }
# }

# module "arm_template_deployment_create_phonebook_sync_group_member_phonebook_eu" {
#   source              = "./modules/ARMTemplateDeployment"
#   name                = "create-phonebook-sync-group-member-phonebook-eu"
#   resource_group_name = module.resource_groups["rg_eastus"].name
#   deployment_mode     = "Incremental"
#   depends_on          = [module.azapi_create_phonebook_sync_group]
#   template_content    = <<TEMPLATE
#   {
#     "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
#     "contentVersion": "1.0.0.0",
#     "parameters": {},
#     "variables": {},
#     "resources": [
#       {
#         "type": "Microsoft.Sql/servers/databases/syncGroups/syncMembers",
#         "apiVersion": "2022-05-01-preview",
#         "name": "coyhub-db-us/phonebook/phonebook-sync-group/coyhub-db-eu",
#         "properties": {
#           "databaseName": "phonebook",
#           "databaseType": "AzureSqlDatabase",
#           "userName": "azureuser",
#           "password": "Test1234.",
#           "serverName": "coyhub-db-eu.database.windows.net",
#           "syncDirection": "Bidirectional",
#           "syncMemberAzureDatabaseResourceId": "${module.mssql_databases["phonebook_eu"].id}",
#           "usePrivateLinkConnection": false
#         }
#       }
#     ]
#   }
#   TEMPLATE
# }
#
# module "azapi_update_phonebook_sync_group" {
#   source      = "./modules/AzAPIUpdateResource"
#   type        = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
#   resource_id = "/subscriptions/14528ad0-4c9e-48a9-8ed0-111c1034b033/resourceGroups/rg-eastus/providers/Microsoft.Sql/servers/coyhub-db-us/databases/phonebook/syncGroups/phonebook-sync-group"
#   depends_on = [
#     module.azapi_create_phonebook_sync_group,
#     module.arm_template_deployment_create_phonebook_sync_group_member_phonebook_eu
#   ]
#   body = {
#     properties = {
#       schema = {
#         masterSyncMemberName = "phonebook"
#         tables = [
#           {
#             quotedName = "dbo.phonebook"
#             columns = [
#               {
#                 dataSize   = "100"
#                 dataType   = "varchar"
#                 quotedName = "name"
#               },
#               {
#                 dataSize   = "100"
#                 dataType   = "varchar"
#                 quotedName = "number"
#               }
#             ]
#           }
#         ]
#       }
#     }
#   }
# }

module "load_balancers" {
  source   = "./modules/LoadBalancer"
  for_each = var.load_balancers

  name                       = each.value.name
  location                   = module.resource_groups[each.value.resource_group].location
  resource_group_name        = module.resource_groups[each.value.resource_group].name
  sku                        = each.value.sku
  frontend_ip_configurations = each.value.frontend_ip_configurations
  lb_backend_address_pools   = each.value.lb_backend_address_pools
  lb_probes                  = each.value.lb_probes
  lb_rules                   = each.value.lb_rules
  private_link_service       = each.value.private_link_service

  depends_on                 = [module.virtual_networks]
}

module "linux_virtual_machine_scale_sets" {
  source   = "./modules/VirtualMachineScaleSet"
  for_each = var.linux_virtual_machine_scale_sets

  name                   = each.value.name
  resource_group_name    = module.resource_groups[each.value.resource_group].name
  location               = module.resource_groups[each.value.resource_group].location
  sku                    = each.value.sku
  instances              = each.value.instances
  admin_username         = each.value.admin_username
  shared_image           = each.value.shared_image
  upgrade_mode           = each.value.upgrade_mode
  health_probe_id        = module.load_balancers[each.value.health_probe.load_balancer].health_probes[each.value.health_probe.name].id
  admin_ssh_key          = each.value.admin_ssh_key
  os_disk                = each.value.os_disk
  network_interface      = each.value.network_interface
  rolling_upgrade_policy = try(each.value.rolling_upgrade_policy, [])

  depends_on = [
    module.load_balancers
  ]
}

module "bastion_hosts" {
  source   = "./modules/BastionHost"
  for_each = var.bastion_hosts

  name                = each.value.name
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  ip_configurations   = each.value.ip_configurations

  depends_on          = [
    module.public_ip_addresses,
    module.virtual_networks
  ]
}

module "private_dns_zones" {
  source   = "./modules/PrivateDNSZone"
  for_each = var.private_dns_zones

  name                  = each.value.name
  resource_group_name   = module.resource_groups[each.value.resource_group].name
  virtual_network_links = each.value.virtual_network_links

  depends_on = [
    module.virtual_networks
  ]
}

# module "private_endpoints" {
#   source   = "./modules/PrivateEndpoint"
#   for_each = var.private_endpoints

#   attached_resource          = each.value.attached_resource
#   resource_group_name        = module.resource_groups[each.value.resource_group].name
#   location                   = module.resource_groups[each.value.resource_group].location
#   subnet_id                  = module.virtual_networks[each.value.subnet.virtual_network_reference_name].subnets[each.value.subnet.reference_name].id
#   private_service_connection = each.value.private_service_connection
#   private_dns_zone_ids = [
#     for private_dns_zone in each.value.private_dns_zone_group.private_dns_zones :
#     module.private_dns_zones[private_dns_zone].id
#   ]

#   depends_on = [
#     module.mssql_servers
#   ]
# }

module "kubernetes_clusters" {
  source   = "./modules/KubernetesCluster"
  for_each = var.kubernetes_clusters

  subnet_aks                  = each.value.subnet_aks
  subnet_appgw                = each.value.subnet_appgw
  name                        = each.value.name
  location                    = module.resource_groups[each.value.resource_group].location
  resource_group_name         = module.resource_groups[each.value.resource_group].name
  private_cluster_enabled     = each.value.private_cluster_enabled
  default_node_pool           = each.value.default_node_pool
  identity                    = each.value.identity
  ingress_application_gateway = each.value.ingress_application_gateway
  network_profile             = each.value.network_profile

  depends_on = [
    module.virtual_networks,
    module.route_tables,
    module.firewalls
  ]
}

module "front_doors" {
  source   = "./modules/FrontDoor"
  for_each = var.front_doors

  name                = each.value.name
  resource_group_name = module.resource_groups[each.value.resource_group].name
  sku_name            = each.value.sku_name
  endpoints           = each.value.endpoints
  origin_groups       = each.value.origin_groups
  origins             = each.value.origins
  routes              = each.value.routes
  # rule_sets = each.value.rule_sets
  # rules = each.value.rules

  depends_on = [
    module.load_balancers,
    module.kubernetes_clusters
  ]
}

module "firewalls" {
  source   = "./modules/Firewall"
  for_each = var.firewalls

  name                        = each.value.name
  location                    = module.resource_groups[each.value.resource_group].location
  resource_group_name         = module.resource_groups[each.value.resource_group].name
  sku_name                    = each.value.sku_name
  sku_tier                    = each.value.sku_tier
  ip_configuration            = each.value.ip_configuration
  management_ip_configuration = each.value.management_ip_configuration
  firewall_network_rule_collections = each.value.firewall_network_rule_collections

  depends_on = [
    module.virtual_networks,
    module.public_ip_addresses
  ]
}