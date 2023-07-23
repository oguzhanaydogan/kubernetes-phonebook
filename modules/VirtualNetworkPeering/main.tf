data "azurerm_virtual_network" "remote_virtual_network" {
  name                = var.remote_virtual_network.name
  resource_group_name = var.remote_virtual_network.resource_group_name
}

resource "azurerm_virtual_network_peering" "vnet_peering" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  remote_virtual_network_id = data.azurerm_virtual_network.remote_virtual_network.id
  allow_forwarded_traffic   = var.allow_forwarded_traffic
}