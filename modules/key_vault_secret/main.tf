data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault.name
  resource_group_name = var.key_vault.resource_group_name
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}