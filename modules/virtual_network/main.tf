resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                                          = each.value.name
  resource_group_name                           = azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.virtual_network.name
  address_prefixes                              = each.value.address_prefixes
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [1] : []

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}