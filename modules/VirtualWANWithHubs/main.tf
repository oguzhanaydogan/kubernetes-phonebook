resource "azurerm_virtual_wan" "virtual_wan" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_virtual_hub" "virtual_hubs" {
  for_each = var.virtual_hubs

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.virtual_wan.id
  address_prefix      = each.value.address_prefix
}

data "azurerm_virtual_network" "example" {
  for_each = var.virtual_hubs.virtual_hub_connection

  name                = each.value.virtual_network.name
  resource_group_name = each.value.virtual_network.resource_group_name
}

resource "azurerm_virtual_hub_connection" "virtual_hub_connection" {
  for_each = var.virtual_hubs.virtual_hub_connection

  name                      = each.value.name
  virtual_hub_id            = azurerm_virtual_hub.virtual_hubs.id
  remote_virtual_network_id = data.azurerm_virtual_network.example[each.key].id
}

resource "azurerm_virtual_hub_route_table" "example" {
  for_each = var.virtual_hubs.route_tables
  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.virtual_hubs.id

  dynamic "route" {
    for_each = each.value.routes

    content {
        name              = route.value.name
        destinations_type = route.value.destinations_type
        destinations      = route.value.destinations 
        next_hop_type     = route.value.next_hop_type
        next_hop          = route.value.next_hop
    }
  }
}

resource "azurerm_virtual_hub_route_table_route" "example" {
  route_table_id = azurerm_virtual_hub_route_table.example.id

  name              = "example-route"
  destinations_type = "CIDR"
  destinations      = ["10.0.0.0/16"]
  next_hop_type     = "ResourceId"
  next_hop          = azurerm_virtual_hub_connection.example.id
}