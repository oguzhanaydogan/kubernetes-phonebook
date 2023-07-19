data "azurerm_client_config" "client_config" {}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id       = data.azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.client_config.tenant_id
  object_id          = var.object_id
  key_permissions    = var.key_permissions
  secret_permissions = var.secret_permissions
}
