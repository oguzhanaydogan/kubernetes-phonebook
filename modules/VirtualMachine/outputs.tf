output "principal_id" {
  value = azurerm_virtual_machine.vm.identity[0].principal_id

}