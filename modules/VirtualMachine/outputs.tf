output "principal_id" {
  value = azurerm_virtual_machine.virtual_machine.identity[0].principal_id

}