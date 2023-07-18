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
  # skip_provider_registration = true
}

module "resource_groups" {
  source   = "./modules/ResourceGroup"
  for_each = var.resource_groups

  name     = each.value.name
  location = each.value.location
}

module "virtual_networks" {
  source   = "./modules/VirtualNetwork"
  for_each = var.virtual_networks

  name                = each.value.name
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  address_space       = each.value.address_space
}

module "subnets" {
  source   = "./modules/Subnet"
  for_each = var.subnets

  name                                          = each.value.name
  address_prefixes                              = each.value.address_prefixes
  resource_group_name                           = module.resource_groups[each.value.resource_group].name
  virtual_network_name                          = module.virtual_networks[each.value.virtual_network].name
  delegation                                    = each.value.delegation
  delegation_name                               = each.value.delegation_name
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
}

module "vnet_peerings" {
  source   = "./modules/VirtualNetworkPeering"
  for_each = var.vnet_peerings

  resource_group_name       = module.resource_groups[each.value.resource_group].name
  name                      = each.value.name
  virtual_network_name      = module.virtual_networks[each.value.virtual_network].name
  remote_virtual_network_id = module.virtual_networks[each.value.remote_virtual_network].id
}

module "route_tables" {
  source   = "./modules/RouteTable"
  for_each = var.route_tables

  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  name                = each.value.name
  routes              = each.value.routes
  subnet_associations = each.value.subnet_associations

  depends_on = [module.subnets]
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

  name           = each.value.name
  location       = module.resource_groups[each.value.resource_group].location
  resourcegroup  = module.resource_groups[each.value.resource_group].name
  security_rules = each.value.security_rules
}

module "linux_virtual_machines" {
  source   = "./modules/VirtualMachine"
  for_each = var.linux_virtual_machines

  name                               = each.value.name
  location                           = module.resource_groups[each.value.resource_group].location
  resource_group_name                = module.resource_groups[each.value.resource_group].name
  network_interface = each.value.network_interface
  size                               = each.value.size
  delete_os_disk_on_termination      = each.value.delete_os_disk_on_termination
  delete_data_disks_on_termination   = each.value.delete_data_disks_on_termination
  identity                           = each.value.identity
  storage_image_reference            = each.value.storage_image_reference
  storage_os_disk                    = each.value.storage_os_disk
  os_profile                         = each.value.os_profile
  os_profile_linux_config            = each.value.os_profile_linux_config
  ip_configurations                  = each.value.network_interface.ip_configurations
  network_security_group_association = each.value.network_security_group_association
}

data "azurerm_key_vault" "example" {
  name                = "coyvault"
  resource_group_name = "ssh-key"
}

data "azurerm_client_config" "current" {}

module "key_vault_access_policies" {
  source   = "./modules/KeyVaultAccessPolicy"
  for_each = var.key_vault_access_policies

  key_vault_name                = each.value.key_vault_name
  key_vault_resource_group_name = each.value.key_vault_resource_group_name
  key_permissions               = each.value.key_permissions
  secret_permissions            = each.value.secret_permissions
  object_id                     = data.azurerm_client_config.current.object_id
}

module "key_vault_secrets" {
  source   = "./modules/KeyVaultSecret"
  for_each = var.key_vault_secrets

  key_vault_name                = each.value.key_vault_name
  key_vault_resource_group_name = each.value.key_vault_resource_group_name
  secret_name                   = each.value.secret_name
  depends_on                    = [module.key_vault_access_policies]
}

module "mssql_servers" {
  source   = "./modules/MsSqlServer"
  for_each = var.mssql_servers

  name                         = each.value.name
  resource_group_name          = module.resource_groups[each.value.resource_group].name
  location                     = module.resource_groups[each.value.resource_group].location
  administrator_login          = each.value.administrator_login
  administrator_login_password = module.key_vault_secrets[each.value.admin_password_secret].value
  tags                         = each.value.tags
}

module "mssql_databases" {
  source   = "./modules/MsSqlDatabase"
  for_each = var.mssql_databases

  name                        = each.value.name
  server_id                   = module.mssql_servers[each.value.server].id
  collation                   = each.value.collation
  max_size_gb                 = each.value.max_size_gb
  sku_name                    = each.value.sku_name
  min_capacity                = each.value.min_capacity
  auto_pause_delay_in_minutes = each.value.auto_pause_delay_in_minutes
  read_replica_count          = each.value.read_replica_count
  read_scale                  = each.value.read_scale
  zone_redundant              = each.value.zone_redundant
}

module "azapi_create_phonebook_sync_group" {
  source    = "./modules/AzApi"
  name      = "phonebook-sync-group"
  type      = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
  parent_id = module.mssql_databases["phonebook_us"].id
  body = {
    properties = {
      conflictResolutionPolicy = "HubWin"
      hubDatabasePassword      = "Test1234."
      hubDatabaseUserName      = "azureuser"
      interval                 = 60
      syncDatabaseId           = "${module.mssql_databases["phonebook_us"].id}"
      usePrivateLinkConnection = false
    }
  }
}

module "arm_template_deployment_create_phonebook_sync_group_member_phonebook_eu" {
  source              = "./modules/ArmTemplateDeployment"
  name                = "create-phonebook-sync-group-member-phonebook-eu"
  resource_group_name = module.resource_groups["rg_eastus"].name
  deployment_mode     = "Incremental"
  depends_on          = [module.azapi_create_phonebook_sync_group]
  template_content    = <<TEMPLATE
  {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {},
    "resources": [
      {
        "type": "Microsoft.Sql/servers/databases/syncGroups/syncMembers",
        "apiVersion": "2022-05-01-preview",
        "name": "coyhub-db-us/phonebook/phonebook-sync-group/coyhub-db-eu",
        "properties": {
          "databaseName": "phonebook",
          "databaseType": "AzureSqlDatabase",
          "userName": "azureuser",
          "password": "Test1234.",
          "serverName": "coyhub-db-eu.database.windows.net",
          "syncDirection": "Bidirectional",
          "syncMemberAzureDatabaseResourceId": "${module.mssql_databases["phonebook_eu"].id}",
          "usePrivateLinkConnection": false
        }
      }
    ]
  }
  TEMPLATE
}

# module "azapi_update_phonebook_sync_group" {
#   source      = "./modules/AzApiUpdate"
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
  depends_on = [ module.subnets ]
}

module "private_link_services" {
  source   = "./modules/PrivateLinkService"
  for_each = var.private_link_services

  link_name                                   = each.value.link_name
  resource_group_name                         = module.resource_groups[each.value.resource_group].name
  location                                    = module.resource_groups[each.value.resource_group].location
  auto_approval_subscription_ids              = [data.azurerm_client_config.current.subscription_id]
  visibility_subscription_ids                 = [data.azurerm_client_config.current.subscription_id]
  load_balancer_frontend_ip_configuration_ids = [module.load_balancers[each.value.load_balancer].frontend_ip_configuration_id]
  nat_ip_configurations = {
    for nat_ip_config in each.value.nat_ip_configurations : nat_ip_config.name => {
      name      = nat_ip_config.name
      primary   = nat_ip_config.primary
      subnet_id = module.subnets[nat_ip_config.subnet].id
    }
  }
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
  health_probe_id        = module.load_balancers[each.value.health_probe_load_balancer].health_probe_id
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
  depends_on = [ module.public_ip_addresses,module.subnets ]    
}

module "private_dns_zones" {
  source   = "./modules/PrivateDnsZone"
  for_each = var.private_dns_zones

  name                  = each.value.name
  resource_group_name   = module.resource_groups[each.value.resource_group].name
  virtual_network_links = each.value.virtual_network_links

  depends_on = [
    module.virtual_networks
  ]
}

module "private_endpoints" {
  source   = "./modules/PrivateEndpoint"
  for_each = var.private_endpoints

  attached_resource          = each.value.attached_resource
  resource_group_name        = module.resource_groups[each.value.resource_group].name
  location                   = module.resource_groups[each.value.resource_group].location
  subnet_id                  = module.subnets[each.value.subnet].id
  private_service_connection = each.value.private_service_connection
  private_dns_zone_ids = [
    for private_dns_zone in each.value.private_dns_zone_group.private_dns_zones :
    module.private_dns_zones[private_dns_zone].id
  ]

  depends_on = [
    module.mssql_servers
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
    module.private_link_services
  ]
}