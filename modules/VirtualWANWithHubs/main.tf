# Routelarin next hopunu halletmemiz lazim!

locals {
  virtual_hub_connections_flattened = flatten([
      for k, hub in var.virtual_hubs : [
          for key, connection in hub.virtual_hub_connections : {
              name = connection.name
              hub = k
              remote_virtual_network = {
                  name = connection.remote_virtual_network.name
                  resource_group_name = connection.remote_virtual_network.resource_group_name
              }
              routing = connection.routing
          }
      ]
  ])
  virtual_hub_connections = {
    for connection in local.virtual_hub_connections_flattened :
      "${connection.hub}_${connection.name}" => connection
  }
  virtual_networks = {
    for k, hub in local.virtual_hub_connections : k => hub.remote_virtual_network
  }
  route_tables_flattened = flatten([
    for k, hub in var.virtual_hubs : [
      for key, route_table in hub.route_tables : {
        name = route_table.name
        hub = k
        routes = route_table.routes
      }
    ]
  ])
  route_tables = {
    for route_table in local.route_tables_flattened :
      "${route_table.hub}_${route_table.name}" => route_table
  }
  route_table_routes_flattened = flatten([
    for k, hub in var.virtual_hubs : [
      for key, route in hub.route_table_routes : {
        hub = k
        name = route.name
        destination_type = route.destination_type
        destinations = route.destinations
        next_hop_type = route.next_hop_type
        next_hop = route.next_hop
      }
    ]
  ])
  route_table_routes = {
    for route in local.route_table_routes_flattened :
      "${route.hub}_${route.name}" => route
  }
}

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

data "azurerm_virtual_network" "virtual_networks" {
  for_each = local.virtual_networks

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_virtual_hub_connection" "virtual_hub_connections" {
  for_each = local.virtual_hub_connections

  name                      = each.value.name
  virtual_hub_id            = azurerm_virtual_hub.virtual_hubs[each.value.hub].id
  remote_virtual_network_id = data.azurerm_virtual_network.virtual_networks[each.key].id

  routing {
    associated_route_table_id = each.value.routing.associated_route_table == "Default" ? azurerm_virtual_hub.virtual_hubs[each.value.hub].default_route_table_id : azurerm_virtual_hub_route_table.virtual_hub_route_tables["${each.value.hub}_${each.value.routing.associated_route_table}"].id

    propagated_route_table {
      route_table_ids = concat([
        for route_table in each.value.routing.propagated_route_tables :
          azurerm_virtual_hub.virtual_hubs[route_table.hub].default_route_table_id
          if route_table.name == "Default"
      ], [
        for route_table in each.value.routing.propagated_route_tables :
          azurerm_virtual_hub_route_table.virtual_hub_route_tables["${route_table.hub}_${route_table.name}"].id
          if route_table.name != "Default"
      ])
    }
  }
}

resource "azurerm_virtual_hub_route_table" "virtual_hub_route_tables" {
  for_each = local.route_tables

  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.virtual_hubs[each.value.hub].id

  # dynamic "route" {
  #   for_each = each.value.routes

  #   content {
  #       name              = route.value.name
  #       destinations_type = route.value.destinations_type
  #       destinations      = route.value.destinations
  #       next_hop_type     = route.value.next_hop_type
  #       next_hop          = azurerm_virtual_hub_connection.virtual_hub_connections["${each.value.hub}_${each.value.next_hop_connection}"].id
  #   }
  # }
}

# resource "azurerm_virtual_hub_route_table_route" "virtual_hub_route_table_routes" {
#   for_each = local.route_table_routes

#   route_table_id = azurerm_virtual_hub.virtual_hubs[each.value.hub].route_table_id

#   name              = each.value.name
#   destinations_type = each.value.destinations_type
#   destinations      = each.value.destinations
#   next_hop_type     = each.value.next_hop_type
#   next_hop          = azurerm_virtual_hub_connection.virtual_hub_connections["${each.value.hub}_${each.value.next_hop_connection}"].id
# }