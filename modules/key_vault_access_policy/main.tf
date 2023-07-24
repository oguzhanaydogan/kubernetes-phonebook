data "azurerm_client_config" "current" {}

data "azuread_user" "user" {
  count = var.object.type == "user" ? 1 : 0

  user_principal_name = var.object.name
}

data "azuread_service_principal" "service_principal" {
  count = var.object.type == "service-principal" ? 1 : 0

  display_name = var.object.name
}

data "azuread_group" "group" {
  count = var.object.type == "security-group" ? 1 : 0

  display_name     = var.object.name
  security_enabled = true
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault.name
  resource_group_name = var.key_vault.resource_group_name
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id = coalesce(
    try(data.azuread_service_principal.service_principal[0].object_id, ""),
    try(data.azuread_group.group[0].object_id, ""),
    try(data.azuread_user.user[0].object_id, ""),
    "coalesce could not find any valid object_id"
  )
  key_permissions    = var.key_permissions
  secret_permissions = var.secret_permissions
}