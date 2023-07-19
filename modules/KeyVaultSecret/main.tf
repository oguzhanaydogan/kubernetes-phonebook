data "azurerm_key_vault" "key_vault" {
  name                = var.name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}
