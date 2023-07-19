output "id" {
  value = data.azurerm_key_vault_secret.key_vault_secret.id
}

output "value" {
  value = data.azurerm_key_vault_secret.key_vault_secret.value
}



