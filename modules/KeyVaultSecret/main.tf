data "azurerm_key_vault" "example" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "secret" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.example.id
}
