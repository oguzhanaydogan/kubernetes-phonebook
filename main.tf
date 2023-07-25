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

# module "arm_template_deployment_create_phonebook_sync_group_member_phonebook_eu" {
#   source              = "./modules/arm_template_deployment"
#   name                = "create-phonebook-sync-group-member-phonebook-eu"
#   resource_group_name = module.resource_groups["rg_eastus"].name
#   deployment_mode     = "Incremental"
#   template_content    = <<TEMPLATE
#   {
#     "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
#     "contentVersion": "1.0.0.0",
#     "parameters": null,
#     "variables": null,
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
#
# depends_on = [
#   module.azapi_create_phonebook_sync_group
# ]
# }

# module "azapi_update_phonebook_sync_group" {
#   source      = "./modules/azapi_update_resource"
#   type        = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
#   resource_id = "/subscriptions/14528ad0-4c9e-48a9-8ed0-111c1034b033/resourceGroups/rg-eastus/providers/Microsoft.Sql/servers/coyhub-db-us/databases/phonebook/syncGroups/phonebook-sync-group"
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
#
#   depends_on = [
#     module.azapi_create_phonebook_sync_group,
#     module.arm_template_deployment_create_phonebook_sync_group_member_phonebook_eu
#   ]
# }

module "bastion_hosts" {
  source   = "./modules/bastion_host"
  for_each = var.bastion_hosts

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  ip_configuration    = each.value.ip_configuration

  depends_on = [
    module.virtual_networks,
    module.public_ip_addresses
  ]
}

module "firewalls" {
  source   = "./modules/firewall"
  for_each = var.firewalls

  name                              = each.value.name
  resource_group_name               = each.value.resource_group_name
  location                          = each.value.location
  sku_name                          = each.value.sku_name
  sku_tier                          = each.value.sku_tier
  firewall_policy                   = try(each.value.fireall_policy, null)
  virtual_hub                       = try(each.value.virtual_hub, null)
  ip_configuration                  = try(each.value.ip_configuration, null)
  management_ip_configuration       = try(each.value.management_ip_configuration, null)
  firewall_network_rule_collections = try(each.value.firewall_network_rule_collections, null)

  depends_on = [
    module.virtual_networks,
    module.public_ip_addresses,
    module.firewall_policies,
    module.virtual_wans
  ]
}

module "firewall_policies" {
  source   = "./modules/firewall_policy"
  for_each = var.firewall_policies

  name                   = each.value.name
  resource_group_name    = each.value.resource_group_name
  location               = each.value.location
  sku = each.value.sku
  rule_collection_groups = each.value.rule_collection_groups

  depends_on = [module.resource_groups]
}

module "front_doors" {
  source   = "./modules/front_door"
  for_each = var.front_doors

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
  endpoints           = each.value.endpoints
  origin_groups       = each.value.origin_groups
  origins             = each.value.origins
  routes              = each.value.routes
  rule_sets           = try(each.value.rule_sets, null)
  rules               = try(each.value.rules, null)

  depends_on = [
    module.load_balancers,
    module.kubernetes_clusters
  ]
}

module "key_vault_access_policies" {
  source   = "./modules/key_vault_access_policy"
  for_each = var.key_vault_access_policies

  key_vault          = each.value.key_vault
  object             = each.value.object
  key_permissions    = each.value.key_permissions
  secret_permissions = each.value.secret_permissions
}

module "key_vault_secrets" {
  source   = "./modules/key_vault_secret"
  for_each = var.key_vault_secrets

  name                          = each.value.name
  key_vault_name                = each.value.key_vault_name
  key_vault_resource_group_name = each.value.key_vault_resource_group_name

  depends_on = [module.key_vault_access_policies]
}

module "kubernetes_clusters" {
  source   = "./modules/kubernetes_cluster"
  for_each = var.kubernetes_clusters

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  public_network_access_enabled = each.value.public_network_access_enabled
  private_cluster_enabled       = each.value.private_cluster_enabled
  subnet_aks                    = each.value.subnet_aks
  default_node_pool             = each.value.default_node_pool
  identity                      = each.value.identity
  subnet_agw                    = each.value.subnet_agw
  ingress_application_gateway   = each.value.ingress_application_gateway
  network_profile               = each.value.network_profile

  depends_on = [ module.virtual_networks ]
}

module "linux_virtual_machines" {
  source   = "./modules/linux_virtual_machine"
  for_each = var.linux_virtual_machines

  name                               = each.value.name
  resource_group_name                = each.value.resource_group_name
  location                           = each.value.location
  network_interface                  = each.value.network_interface
  size                               = each.value.size
  delete_os_disk_on_termination      = each.value.delete_os_disk_on_termination
  delete_data_disks_on_termination   = each.value.delete_data_disks_on_termination
  identity                           = each.value.identity
  storage_image_reference            = each.value.storage_image_reference
  storage_os_disk                    = each.value.storage_os_disk
  os_profile                         = each.value.os_profile
  os_profile_linux_config            = each.value.os_profile_linux_config
  boot_diagnostics                   = each.value.boot_diagnostics
  network_security_group_association = each.value.network_security_group_association

  depends_on = [
    module.virtual_networks,
    module.public_ip_addresses,
    module.network_security_groups
  ]
}

module "linux_virtual_machine_scale_sets" {
  source   = "./modules/linux_virtual_machine_scale_set"
  for_each = var.linux_virtual_machine_scale_sets

  name                   = each.value.name
  resource_group_name    = each.value.resource_group_name
  location               = each.value.location
  sku                    = each.value.sku
  instances              = each.value.instances
  admin_username         = each.value.admin_username
  shared_image           = each.value.shared_image
  upgrade_mode           = each.value.upgrade_mode
  load_balancer          = try(each.value.load_balancer, null)
  health_probe_name      = each.value.health_probe_name
  admin_ssh_key          = each.value.admin_ssh_key
  os_disk                = each.value.os_disk
  network_interface      = each.value.network_interface
  rolling_upgrade_policy = try(each.value.rolling_upgrade_policy, null)

  depends_on = [
    module.virtual_networks,
    module.network_security_groups,
    module.load_balancers
  ]
}

module "load_balancers" {
  source   = "./modules/load_balancer"
  for_each = var.load_balancers

  name                       = each.value.name
  resource_group_name        = each.value.resource_group_name
  location                   = each.value.location
  sku                        = each.value.sku
  frontend_ip_configurations = each.value.frontend_ip_configurations
  lb_backend_address_pools   = each.value.lb_backend_address_pools
  lb_probes                  = each.value.lb_probes
  lb_rules                   = each.value.lb_rules
  private_link_service       = try(each.value.private_link_service)

  depends_on = [module.virtual_networks]
}

module "sql_project102_prod_eastus_001" {
  source   = "./modules/mssql_server"

  name                = var.sql_project102_prod_eastus_001.name
  resource_group_name = var.sql_project102_prod_eastus_001.resource_group_name
  location            = var.sql_project102_prod_eastus_001.location
  msqql_version       = var.sql_project102_prod_eastus_001.version
  administrator_login = var.sql_project102_prod_eastus_001.administrator_login
  tags                = var.sql_project102_prod_eastus_001.tags
  mssql_databases     = var.sql_project102_prod_eastus_001.mssql_databases

  depends_on = [module.key_vault_access_policies]
}

module "sql_project102_prod_westeurope_001" {
  source   = "./modules/mssql_server"

  name                = var.sql_project102_prod_westeurope_001.name
  resource_group_name = var.sql_project102_prod_westeurope_001.resource_group_name
  location            = var.sql_project102_prod_westeurope_001.location
  msqql_version       = var.sql_project102_prod_westeurope_001.version
  administrator_login = var.sql_project102_prod_westeurope_001.administrator_login
  tags                = var.sql_project102_prod_westeurope_001.tags
  mssql_databases     = var.sql_project102_prod_westeurope_001.mssql_databases
  

  depends_on = [module.key_vault_access_policies]
}

module "network_security_groups" {
  source   = "./modules/network_security_group"
  for_each = var.network_security_groups

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  security_rules      = try(each.value.security_rules, null)

  depends_on = [module.resource_groups]
}

module "private_dns_zones" {
  source   = "./modules/private_dns_zone"
  for_each = var.private_dns_zones

  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  virtual_network_links = each.value.virtual_network_links

  depends_on = [module.virtual_networks]
}

module "private_endpoints" {
  source   = "./modules/private_endpoint"
  for_each = var.private_endpoints

  name                       = each.value.name
  resource_group_name        = each.value.resource_group_name
  location                   = each.value.location
  subnet                     = each.value.subnet
  attached_resource          = each.value.attached_resource
  private_service_connection = each.value.private_service_connection
  private_dns_zone_group     = each.value.private_dns_zone_group

  depends_on = [
    module.private_dns_zones,
    module.mssql_servers
  ]
}

module "public_ip_addresses" {
  source   = "./modules/public_ip_address"
  for_each = var.public_ip_addresses

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku

  depends_on = [module.resource_groups]
}

module "resource_groups" {
  source   = "./modules/resource_group"
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
}

module "route_tables" {
  source   = "./modules/route_table"
  for_each = var.route_tables

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  routes              = each.value.routes
  subnet_associations = each.value.subnet_associations

  depends_on = [module.virtual_networks]
}

module "virtual_networks" {
  source   = "./modules/virtual_network"
  for_each = var.virtual_networks

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space
  subnets             = try(each.value.subnets, null)

  depends_on = [module.resource_groups]
}

module "virtual_network_peerings" {
  source   = "./modules/virtual_network_peering"
  for_each = var.vnet_peerings

  name                    = each.value.name
  resource_group_name     = each.value.resource_group_name
  virtual_network_name    = each.value.virtual_network_name
  remote_virtual_network  = each.value.remote_virtual_network
  allow_forwarded_traffic = each.value.allow_forwarded_traffic

  depends_on = [module.virtual_networks]
}

module "virtual_wans" {
  source   = "./modules/virtual_wan"
  for_each = var.virtual_wans

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  virtual_hubs        = try(each.value.virtual_hubs, null)

  depends_on = [module.virtual_networks]
}