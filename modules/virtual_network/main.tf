resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

module "subnets" {
  source   = "../subnet"
  for_each = var.subnets

  name = each.value.name
  virtual_network = {
    name                = azurerm_virtual_network.virtual_network.name
    resource_group_name = azurerm_virtual_network.virtual_network.resource_group_name
  }
  address_prefixes                              = each.value.address_prefixes
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, null)
  delegation                                    = try(each.value.delegation, null)
}