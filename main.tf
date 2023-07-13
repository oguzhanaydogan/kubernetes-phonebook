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

module "azapi_create_phonebook_sync_group" {
  source = "./modules/AzApi"
  name = "phonebook-sync-group"
  type = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
  parent_id = module.mssql_databases["phonebook_us"].id
  body = {
    properties = {
      conflictResolutionPolicy = "HubWin"
      hubDatabasePassword = "Test1234."
      hubDatabaseUserName = "azureuser"
      interval = 60
      syncDatabaseId = "${module.mssql_databases["phonebook_us"].id}"
      usePrivateLinkConnection = false
    }
  }
}

module "arm_template_deployment_create_phonebook_sync_group_member_phonebook_eu" {
  source = "./modules/ARMTemplateDeployment"
  name = "create-phonebook-sync-group-member-phonebook-eu"
  resource_group_name = module.resource_groups["rg-eastus"].name
  deployment_mode = "Incremental"
  depends_on = [ module.azapi_create_phonebook_sync_group ]
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

module "azapi_update_phonebook_sync_group" {
  source = "./modules/AzApiUpdate"
  type = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
  resource_id = "/subscriptions/14528ad0-4c9e-48a9-8ed0-111c1034b033/resourceGroups/rg-eastus/providers/Microsoft.Sql/servers/coyhub-db-us/databases/phonebook/syncGroups/phonebook-sync-group"
  depends_on = [
    module.azapi_create_phonebook_sync_group,
    module.arm_template_deployment_create_phonebook_sync_group_member_phonebook_eu
  ]
  body = {
    properties = {
      schema = {
        masterSyncMemberName = "phonebook"
        tables = [
          {
            quotedName = "dbo.phonebook"
            columns = [
              {
                dataSize = "100"
                dataType = "varchar"
                quotedName = "name"
              },
              {
                dataSize = "100"
                dataType = "varchar"
                quotedName = "number"
              }
            ]
          }
        ]
      }
    }
  }
}

module "load_balancers" {
  source = "./modules/LoadBalancer"
  for_each = var.load_balancers
  name = each.key
  location = module.resource_groups[each.value.resource_group].location
  resource_group_name = module.resource_groups[each.value.resource_group].name
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  frontend_ip_configuration_subnet_id = module.subnets[each.value.frontend_ip_configuration_subnet].id
  lb_backend_address_pool_name = each.value.lb_backend_address_pool_name
  lb_nat_pool_name = each.value.lb_nat_pool_name
  lb_nat_pool_protocol = each.value.lb_nat_pool_protocol
  lb_nat_pool_frontend_port_start = each.value.lb_nat_pool_rontend_port_start
  lb_nat_pool_frontend_port_end = each.value.lb_nat_pool_frontend_port_end
  lb_nat_pool_backend_port = each.value.lb_nat_pool_backend_port
  lb_probe_name = each.value.lb_probe_name
  lb_probe_protocol = each.value.lb_probe_protocol
  lb_probe_port = each.value.lb_probe_port
}

data "azurerm_client_config" "current" { 
}

module "private_link_services" {
  source = "./modules/PrivateLinkService"
  for_each = var.private_link_services
  link_name = each.key
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location = module.resource_groups[each.value.resource_group].location
  auto_approval_subscription_ids = [data.azurerm_client_config.current.subscription_id]
  load_balancer_frontend_ip_configuration_ids = [module.load_balancers[each.value.load_balancer].frontend_ip_configuration.0.id]
  nat_ip_configurations = {
    for nat_ip_config in each.value.nat_ip_configurations : nat_ip_config.name => {
        name = nat_ip_config.name
        primary = nat_ip_config.primary
        subnet_id = module.subnets[nat_ip_config.subnet].id
    }
  }
}

module "linux_virtual_machine_scale_sets" {
  source = "./modules/VirtualMachineScaleSet"
  for_each = var.linux_virtual_machine_scale_sets
  ssh_key_rg = each.value.ssh_key_rg
  ssh_key_name = each.value.ssh_key_name
  shared_image_name = each.value.shared_image_name
  shared_image_gallery_name = each.value.shared_image_gallery_name
  shared_image_resource_group_name = each.value.shared_image_resource_group_name
  depends_on = [ module.load_balancers.* ]
  name = each.key
  resource_group_name = module.resource_groups[each.value.resource_group].name
  location = module.resource_groups[each.value.resource_group].location
  sku = each.value.sku
  instances = each.value.instances
  admin_username = each.value.admin_username
  os_disk_caching = each.value.os_disk_caching
  network_interface_name = each.value.network_interface_name
  network_interface_primary = each.value.network_interface_primary
  ip_configuration_name = each.value.ip_configuration_name
  ip_configuration_primary = each.value.ip_configuration_primary
  ip_configuration_subnet_id = module.subnets[each.value.ip_configuration_subnet].id
  ip_configuration_load_balancer_backend_address_pool_ids = [module.load_balancers[each.value.ip_configuration_load_balancer].backend_address_pool_ids]
  ip_configuration_load_balancer_inbound_nat_pool_ids = [module.load_balancers[each.value.ip_configuration_load_balancer].inbound_nat_pool_ids]
}
