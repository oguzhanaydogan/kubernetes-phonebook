resource "azurerm_route_table" "route_table" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "route" {
    for_each = var.routes

    content {
      name                   = route.key
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}

data "azurerm_subnet" "subnets" {
  for_each = var.subnet_associations

  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_subnet_route_table_association" "example" {
  for_each = var.subnet_associations

  route_table_id = azurerm_route_table.route_table.id
  subnet_id      = data.azurerm_subnet.subnets[each.key].id
}