resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.name
  resource_group_name = var.resource_group_name
}

data "azurerm_virtual_network" "virtual_networks" {
  for_each = var.virtual_network_links

  name                = each.value.virtual_network.name
  resource_group_name = each.value.virtual_network.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_virtual_network_link" {
  for_each = var.virtual_network_links

  name                  = each.value.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = data.azurerm_virtual_network.virtual_networks[each.key].id
}