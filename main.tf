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
  name     = each.key
  location = each.value
}

module "virtual_networks" {
  source              = "./modules/VirtualNetwork"
  for_each            = var.virtual_networks
  name                = each.key
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  address_space       = each.value.address_space
}

module "subnets" {
  source               = "./modules/Subnet"
  for_each             = var.subnets
  subnet_name          = each.value.name
  address_prefixes     = each.value.address_prefixes
  resource_group_name  = module.resource_groups[each.value.resource_group].name
  virtual_network_name = module.virtual_networks[each.value.virtual_network].name
  delegation           = each.value.delegation
  delegation_name      = each.value.delegation_name
}

module "vnet_peerings" {
  source                    = "./modules/VirtualNetworkPeering"
  for_each                  = var.vnet_peerings
  resource_group_name       = module.resource_groups[each.value.resource_group].name
  name                      = each.key
  virtual_network_name      = module.virtual_networks[each.value.virtual_network].name
  remote_virtual_network_id = module.virtual_networks[each.value.remote_virtual_network].id
}

module "route_tables" {
  source              = "./modules/RouteTable"
  for_each            = var.route_tables
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  name                = each.key
  route               = each.value.routes
}

module "route_table_associations" {
  source         = "./modules/RouteTableAssociation"
  for_each       = var.route_table_associations
  route_table_id = module.route_tables[each.key].id
  subnet_id      = module.subnets[each.value].id
}

module "acrs" {
  source                        = "./modules/ContainerRegistry"
  for_each                      = var.acrs
  name                          = each.key
  resource_group_name           = module.resource_groups[each.value.resource_group].name
  location                      = module.resource_groups[each.value.resource_group].location
  admin_enabled                 = each.value.admin_enabled
  sku                           = each.value.sku
  public_network_access_enabled = each.value.public_network_access_enabled
  network_rule_bypass_option    = each.value.network_rule_bypass_option
}

module "public_ip_addresses" {
  source              = "./modules/PublicIPAddress"
  for_each            = var.public_ip_addresses
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location            = module.resource_groups[each.value.resource_group].location
  name                = each.key
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}

module "network_security_groups" {
  source         = "./modules/NetworkSecurityGroup"
  for_each       = var.network_security_groups
  location       = module.resource_groups[each.value.resource_group].location
  resourcegroup  = module.resource_groups[each.value.resource_group].name
  name           = each.key
  security_rules = each.value.security_rules
}

module "linux_virtual_machines" {
  source                                                  = "./modules/VirtualMachine"
  for_each                                                = var.linux_virtual_machines
  location                                                = module.resource_groups[each.value.resource_group].location
  resourcegroup                                           = module.resource_groups[each.value.resource_group].name
  vm_name                                                 = each.key
  vm_size                                                 = each.value.vm_size
  delete_os_disk_on_termination                           = each.value.delete_os_disk_on_termination
  delete_data_disks_on_termination                        = each.value.delete_data_disks_on_termination
  identity_enabled                                        = each.value.identity_enabled
  vm_identity_type                                        = each.value.vm_identity_type
  storage_image_reference_publisher                       = each.value.storage_image_reference_publisher
  storage_image_reference_offer                           = each.value.storage_image_reference_offer
  storage_image_reference_sku                             = each.value.storage_image_reference_sku
  storage_image_reference_version                         = each.value.storage_image_reference_version
  storage_os_disk_name                                    = each.value.storage_os_disk_name
  storage_os_disk_caching                                 = each.value.storage_os_disk_caching
  storage_os_disk_create_option                           = each.value.storage_os_disk_create_option
  storage_os_disk_managed_disk_type                       = each.value.storage_os_disk_managed_disk_type
  admin_username                                          = each.value.admin_username
  custom_data                                             = each.value.custom_data
  os_profile_linux_config_disable_password_authentication = each.value.os_profile_linux_config_disable_password_authentication
  ip_configuration_name                                   = each.value.ip_configuration_name
  ip_configuration_subnet_id                              = module.subnets[each.value.ip_configuration_subnet].id
  ip_configuration_private_ip_address_allocation          = each.value.ip_configuration_private_ip_address_allocation
  ip_configuration_public_ip_assigned                     = each.value.ip_configuration_public_ip_assigned
  ip_configuration_public_ip_address_id                   = each.value.ip_configuration_public_ip_assigned ? module.public_ip_addresses[each.value.ip_configuration_public_ip_address].id : null
  ssh_key_rg                                              = each.value.ssh_key_rg
  ssh_key_name                                            = each.value.ssh_key_name
  nsg_association_enabled                                 = each.value.nsg_association_enabled
  nsg_id                                                  = module.network_security_groups["${each.value.nsg}"].id
}

data "azurerm_key_vault" "example" {
  name                = "coyvault"
  resource_group_name = "ssh-key"
}

data "azurerm_client_config" "current" {}

module "key_vault_access_policies" {
  source                        = "./modules/KeyVaultAccessPolicy"
  for_each                      = var.key_vault_access_policies
  key_vault_name                = each.value.key_vault_name
  key_vault_resource_group_name = each.value.key_vault_resource_group_name
  key_permissions               = each.value.key_permissions
  secret_permissions            = each.value.secret_permissions
  object_id                     = data.azurerm_client_config.current.object_id
}

module "key_vault_secrets" {
  source                        = "./modules/KeyVaultSecret"
  for_each                      = var.key_vault_secrets
  key_vault_name                = each.value.key_vault_name
  key_vault_resource_group_name = each.value.key_vault_resource_group_name
  secret_name                   = each.value.secret_name
  depends_on                    = [module.key_vault_access_policies]
}

module "mssql_servers" {
  source                       = "./modules/MsSqlServer"
  for_each                     = var.mssql_servers
  name                         = each.key
  resource_group_name          = module.resource_groups[each.value.resource_group].name
  location                     = module.resource_groups[each.value.resource_group].location
  administrator_login          = each.value.administrator_login
  administrator_login_password = module.key_vault_secrets[each.value.admin_password_secret].value
}

module "mssql_databases" {
  source                      = "./modules/MsSqlDatabase"
  for_each                    = var.mssql_databases
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

module "azapi_resources" {
  source = "./modules/AzApi"
  for_each = var.azapi_resources
  type = each.value.type
  name = each.key
  parent_id = module.mssql_databases["phonebook_us"].id
  schema_validation_enabled = each.value.schema_validation_enabled
  body = {
    properties = {
      conflictResolutionPolicy = "HubWin"
      hubDatabasePassword = "Test1234."
      hubDatabaseUserName = "azureuser"
      interval = 60
      # schema = {
      #   masterSyncMemberName = "string"
      #   tables = [
      #     {
      #       columns = [
      #         {
      #           dataSize = "string"
      #           dataType = "string"
      #           quotedName = "string"
      #         }
      #       ]
      #       quotedName = "string"
      #     }
      #   ]
      # }
      syncDatabaseId = "${module.mssql_databases["phonebook_us"].id}"
      usePrivateLinkConnection = false
    }
    # sku = {
    #   capacity = int
    #   family = "string"
    #   name = "string"
    #   size = "string"
    #   tier = "string"
    # }
  }
}

module "arm_template_deployments" {
  source = "./modules/ARMTemplateDeployment"
  for_each = var.arm_template_deployments
  name = each.key
  resource_group_name = module.resource_groups[each.value.resource_group].name
  deployment_mode = each.value.deployment_mode
  template_content = <<TEMPLATE
  {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {},
    "resources": [
      {
        "type": "Microsoft.Sql/servers/databases/syncGroups/syncMembers",
        "apiVersion": "2022-05-01-preview",
        "name": "db-sync-group/db-sync-group-member-eu",
        "properties": {
          "databaseName": "phonebook",
          "databaseType": "AzureSqlDatabase",
          "userName": "azureuser",
          "password": "Test1234.",
          "serverName": "coyhub-db-eu",
          "syncDirection": "Bidirectional",
          "syncMemberAzureDatabaseResourceId": "${module.mssql_databases["phonebook_eu"].id}",
          "usePrivateLinkConnection": false
        }
      }
    ]
  }
  TEMPLATE
}