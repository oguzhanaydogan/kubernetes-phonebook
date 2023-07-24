output "test" {
  value = data.azuread_user.user
}

output "test2" {
  value = azurerm_key_vault_access_policy.key_vault_access_policy.object_id
}