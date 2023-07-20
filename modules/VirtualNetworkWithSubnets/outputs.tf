output "name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "subnets" {
  value = azurerm_subnet.subnets
}