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
  administrator_login_username = coalesce(
    data.azurerm_key_vault_secret.key_vault_secret_admin_user[0].value,
    var.administrator_login.username.literal,
    "Coalesce could not find any input for admin user"
  )
  administrator_login_password = coalesce(
    data.azurerm_key_vault_secret.key_vault_secret_admin_password[0].value,
    var.administrator_login.password.literal,
    "Coalesce could not find any input for admin password"
  )
  # Since we don't have the calling database (the one above) name anymore, we need to inject it into the object.
  owned_sync_groups_flattened = flatten([
    for key, database in var.mssql_databases : [
      for k, group in database.sync_groups : merge({ "database" = key }, group)
    ]
  ])
  # Two databases can have syhnc groups with the same names. To distinguish between these, we can use interpolation.
  owned_sync_groups = {
    for group in local.owned_sync_groups_flattened : "${group.database}_${group.name}" => group
  }
  sync_group_memberships_servers_flattened = flatten([
    for key, database in var.mssql_databases : [
      for k, group in database.sync_group_memberships : group.sync_group.server
    ]
  ])
  # For above list can contain duplicates, we need to use toset function.
  sync_group_memberships_servers = {
    for server in toset(local.sync_group_memberships_servers_flattened) : server.name => server
  }
  # Since we don't have the calling server (the one above) name anymore, we need to inject it into the object.
  sync_group_memberships_databases_flattened = flatten([
    for key, database in var.mssql_databases : [
      for k, membership in database.sync_group_memberships : merge(membership.sync_group.database, { server_name = membership.sync_group.server.name })
    ]
  ])
  # For above list can contain duplicates, we need to use toset function.
  sync_group_memberships_databases = {
    for database in toset(local.sync_group_memberships_databases_flattened) : "${database.server_name}_${database.name}" => database
  }
  # Since we don't have the calling database and server (the ones above) names anymore, we need to inject them into the object.
  sync_group_memberships_sync_groups_flattened = flatten([
    for key, database in var.mssql_databases : [
      for k, membership in database.sync_group_memberships : merge(membership.sync_group, { server_name = membership.sync_group.server.name, database_name = membership.sync_group.database.name })
    ]
  ])
  # For above list can contain duplicates, we need to use toset function.
  sync_group_memberships_sync_groups = {
    for group in toset(local.sync_group_memberships_sync_groups_flattened) : "${group.server_name}_${group.database_name}_${group.name}" => group
  }
  # Since we don't have the calling database (the one above) name anymore, we need to inject it into the object.
  sync_group_memberships_memberships_flattened = flatten([
    for key, database in var.mssql_databases : [
      for k, membership in database.sync_group_memberships : merge({ "database" = key }, membership)
    ]
  ])
  # Two databases can have memberships with the same names. To distinguish between these, we can use interpolation.
  sync_group_memberships_memberships = {
    for membership in local.sync_group_memberships_memberships_flattened : "${membership.database}_${membership.name}" => membership
  }
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.msqql_version
  administrator_login          = local.administrator_login_username
  administrator_login_password = local.administrator_login_password
  tags                         = var.tags
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

resource "azapi_resource" "owned_sync_groups" {
  for_each = local.owned_sync_groups

  name      = each.value.name
  type      = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
  parent_id = azurerm_mssql_database.mssql_database[each.value.database].id
  body = jsonencode({
    properties = {
      conflictResolutionPolicy = "${each.value.conflictResolutionPolicy}"
      hubDatabasePassword      = "${local.administrator_login_password}"
      hubDatabaseUserName      = "${local.administrator_login_username}"
      interval                 = each.value.interval
      syncDatabaseId           = "${azurerm_mssql_database.mssql_database[each.value.database].id}"
      usePrivateLinkConnection = each.value.usePrivateLinkConnection
    }
  })
}

data "azurerm_mssql_server" "sync_group_memberships_servers" {
  for_each = local.sync_group_memberships_servers

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_mssql_database" "sync_group_memberships_databases" {
  for_each = local.sync_group_memberships_databases

  name                = each.value.name
  server_id           = data.azurerm_mssql_server.sync_group_memberships_servers[each.value.server_name].id
}

data "azapi_resource" "sync_group_memberships_sync_groups" {
  for_each = local.sync_group_memberships_sync_groups

  type      = "Microsoft.Sql/servers/databases/syncGroups@2022-05-01-preview"
  name      = each.value.name
  parent_id = data.azurerm_mssql_database.sync_group_memberships_databases["${each.value.server.name}_${each.value.database.name}"].id
}

resource "azapi_resource" "sync_group_memberships_memberships" {
  for_each = local.sync_group_memberships_memberships

  type      = "Microsoft.Sql/servers/databases/syncGroups/syncMembers@2022-05-01-preview"
  name      = each.value.name
  parent_id = data.azapi_resource.sync_group_memberships_sync_groups["${each.value.sync_group.server.name}_${each.value.sync_group.database.name}_${each.value.sync_group.name}"].id
  body = jsonencode({
    properties = {
      # Member info
      databaseName                      = azurerm_mssql_database.mssql_database[join("_", split("-", each.value.database))].name
      databaseType                      = each.value.own_database_type
      userName                          = local.administrator_login_username
      password                          = local.administrator_login_password
      syncMemberAzureDatabaseResourceId = azurerm_mssql_database.mssql_database[join("_", split("-", each.value.database))].id
      usePrivateLinkConnection          = each.value.usePrivateLinkConnection
      serverName          = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
      sqlServerDatabaseId = data.azurerm_mssql_database.sync_group_memberships_databases["${each.value.sync_group.server.name}_${each.value.sync_group.database.name}"].id
      # Hub info
      syncAgentId         = data.azurerm_mssql_database.sync_group_memberships_databases["${each.value.sync_group.server.name}_${each.value.sync_group.database.name}"].id
      syncDirection       = "Bidirectional"
    }
  })
}