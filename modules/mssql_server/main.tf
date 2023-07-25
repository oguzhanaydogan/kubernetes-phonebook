data "azurerm_key_vault" "key_vault_admin_user" {
  count = var.administrator_login.username.source == "key_vault" ? 1 : 0

  name                = var.administrator_login.username.key_vault.name
  resource_group_name = var.administrator_login.username.key_vault.resource_group_name
}

data "azurerm_key_vault_secret" "key_vault_secret_admin_user" {
  count = var.administrator_login.username.source == "key_vault" ? 1 : 0

  name         = var.administrator_login.username.key_vault.secret_name
  key_vault_id = data.azurerm_key_vault.key_vault_admin_user[0].id
}

data "azurerm_key_vault" "key_vault_admin_password" {
  count = var.administrator_login.password.source == "key_vault" ? 1 : 0

  name                = var.administrator_login.password.key_vault.name
  resource_group_name = var.administrator_login.password.key_vault.resource_group_name
}

data "azurerm_key_vault_secret" "key_vault_secret_admin_password" {
  count = var.administrator_login.password.source == "key_vault" ? 1 : 0

  name         = var.administrator_login.password.key_vault.secret_name
  key_vault_id = data.azurerm_key_vault.key_vault_admin_password[0].id
}

locals {
  administrator_login = coalesce(
    data.azurerm_key_vault_secret.key_vault_secret_admin_user[0].value,
    var.administrator_login.username.literal,
    "Coalesce could not find any input for admin user"
  )
  administrator_login_password = coalesce(
    data.azurerm_key_vault_secret.key_vault_secret_admin_password[0].value,
    var.administrator_login.password.literal,
    "Coalesce could not find any input for admin password"
  )
  sync_groups_flattened = flatten([
    for k, database in var.mssql_databases : [
      for key, sync_group in database.sync_groups : merge({database = k}, sync_group)
    ]
  ])
  sync_groups = {
    for sync_group in sync_groups_flattened : "${sync_group.database}_${sync_group.name}" => sync_group
  }

  sync_group_memberships_servers = {
    for k, v in var.mssql_databases: k => {
      for key, value in v.sync_group_memberships : key => value.sync_group.server
    }
  }
  sync_group_memberships_servers_flattened = flatten([
    for k, v in var.mssql_databases : [
      for x, y in v.sync_group_memberships : y.sync_group.server
    ]
  ])
  sync_group_membership_servers = {
    for v in toset(local.sync_group_memberships_servers_flattened) : v.name => v
  }
  sync_group_memberships_databases_flattened = flatten([
    for k, v in var.mssql_databases : [
      for x, y in v.sync_group_memberships : merge(y.sync_group.database, {server_name = y.sync_group.server.name})
    ]
  ])
  sync_group_membership_databases = {
    for v in toset(local.sync_group_memberships_databases_flattened) : v.name => v
  }
  sync_group_membership_sync_groups_flattened= {

  }
  sync_group_memberships_flattened = flatten([
    for k, database in var.mssql_databases : [
      for key, sync_group_membership in database.sync_group_memberships : merge({database = k}, sync_group_membership)
    ]
  ])
  sync_group_memberships = {
    for sync_group_membership in sync_group_memberships_flattened : "${sync_group_membership.database}_${sync_group_membership.name}" => sync_group_membership
  }
}

resource "azurerm_mssql_server" "mssql_server" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = var.msqql_version
  administrator_login = local.administrator_login
  administrator_login_password = local.administrator_login_password
  tags = var.tags
}

resource "azurerm_mssql_database" "mssql_database" {
  for_each = var.mssql_databases

  name                        = each.value.name
  server_id                   = azurerm_mssql_server.mssql_server.id
  collation                   = each.value.collation
  max_size_gb                 = each.value.max_size_gb
  sku_name                    = each.value.sku_name
  min_capacity                = each.value.min_capacity
  auto_pause_delay_in_minutes = each.value.auto_pause_delay_in_minutes
  read_replica_count          = each.value.read_replica_count
  read_scale                  = each.value.read_scale
  zone_redundant              = each.value.zone_redundant
}

resource "azapi_resource" "sync_groups" {
  for_each = local.sync_groups

  name      = each.value.name
  type      = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
  parent_id = azurerm_mssql_database.mssql_database[each.value.database].id
  body      = jsonencode({
    properties = {
      conflictResolutionPolicy = "${each.value.conflictResolutionPolicy}"
      hubDatabasePassword      = "${local.administrator_login_password}"
      hubDatabaseUserName      = "${local.administrator_login}"
      interval                 = each.value.interval
      syncDatabaseId           = "${azurerm_mssql_database.mssql_database[each.value.database].id}"
      usePrivateLinkConnection = each.value.usePrivateLinkConnection
    }
  })
}

data "azurerm_mssql_server" "example" {
  for_each = local.sync_group_memberships_servers
  
  name                = "existingMsSqlServer"
  resource_group_name = "existingResGroup"
}

data "azurerm_sql_database" "example" {
  for_each = local.sync_group_membership_databases

  name                = "example_db"
  server_name         = "example_db_server"
  resource_group_name = "example-resources"
}

data "azapi_resource" "membership_sync_groups" {
  for_each = local.membership_sync_groups
  
  type = "Microsoft.Network/loadBalancers/probes@2023-02-01"
  name = "string"
  parent_id = "string"
}

resource "azapi_resource" "sync_group_memberships" {
  for_each = local.sync_group_memberships

  type = "Microsoft.Sql/servers/databases/syncGroups/syncMembers@2022-05-01-preview"
  name = each.value.name
  parent_id = data.azapi_resources.sync_group.id
  body = jsonencode({
    properties = {
      databaseName = "string"
      databaseType = "string"
      password = "string"
      serverName = "string"
      sqlServerDatabaseId = "string"
      syncAgentId = "string"
      syncDirection = "string"
      syncMemberAzureDatabaseResourceId = "string"
      usePrivateLinkConnection = bool
      userName = "string"
    }
  })
}