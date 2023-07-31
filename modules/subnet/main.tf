resource "azurerm_subnet" "subnet" {
  name                                          = var.name
  resource_group_name                           = var.virtual_network.resource_group_name
  virtual_network_name                          = var.virtual_network.name
  address_prefixes                              = var.address_prefixes
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled

  dynamic "delegation" {
    for_each = var.delegation != null ? [1] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}