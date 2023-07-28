locals {
  # Gather 'firewall_policy's from all the 'virtual_hub's
  virtual_hub_firewall_policies = {
    for key, virtual_hub in var.virtual_hubs :
    key => virtual_hub.firewall.policy
  }

  # Gather 'firewall's from all the 'virtual_hub's
  virtual_hub_firewalls = {
    for key, virtual_hub in var.virtual_hubs :
    key => virtual_hub.firewall
  }

  # We will lose the hierarchical info after flattening,
  # in this case 'virtual_hub' and 'reference_name' of the 'connection'.
  # Inject these into the 'connection' before flattening
  virtual_hub_connections_flattened = flatten(
    [
      for key, virtual_hub in var.virtual_hubs :
      [
        for k, connection in virtual_hub.virtual_hub_connections :
        merge(connection, { reference_name = k, virtual_hub = key })
      ]
    ]
  )

  # Add 'virtual_hub' to the key since different virtual hubs can have connections with the same name
  virtual_hub_connections = {
    for connection in local.virtual_hub_connections_flattened :
    "${connection.virtual_hub}_${connection.reference_name}" => connection
  }

  # Gather all the 'remote_virtual_network' onjects mentioned in the connections
  virtual_networks = {
    for key, connection in local.virtual_hub_connections :
    key => connection.remote_virtual_network
  }

  # We will lose the hierarchical info after flattening,
  # in this case 'virtual_hub' and 'reference_name' of the 'route_table.
  # Inject these into the 'connection' before flattening
  route_tables_flattened = flatten(
    [
      for key, virtual_hub in var.virtual_hubs :
      [
        for k, route_table in virtual_hub.route_tables :
        merge(route_table, { reference_name = k, virtual_hub = key })
      ]
    ]
  )

  # Add 'virtual_hub' to the key since different virtual hubs can have connections with the same name
  route_tables = {
    for route_table in local.route_tables_flattened :
    "${route_table.virtual_hub}_${route_table.reference_name}" => route_table
  }

  # We will lose the hierarchical info after flattening,
  # in this case 'virtual_hub' and 'reference_name' of the 'route_table_route'.
  # Inject these into the 'connection' before flattening
  route_table_routes_flattened = flatten(
    [
      for key, virtual_hub in var.virtual_hubs :
      [
        for k, route in virtual_hub.route_table_routes :
        merge(route, { reference_name = k, virtual_hub = key })
      ]
    ]
  )

  # Add 'virtual_hub' to the key since different virtual hubs can have routes with the same name
  route_table_routes = {
    for route in local.route_table_routes_flattened :
    "${route.virtual_hub}_${route.reference_name}" => route
  }

  # Since same firewall can be referred by different routes, there may be duplicates
  # Use 'for loop' grouping
  route_table_route_firewalls = {
    for key, route in local.route_table_routes :
    key => route.next_hop.firewall...
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

data "azurerm_firewall_policy" "virtual_hub_firewall_policies" {
  for_each = local.virtual_hub_firewall_policies

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

module "virtual_hub_firewalls" {
  source   = "../firewall"
  for_each = local.virtual_hub_firewalls

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  firewall_policy     = data.azurerm_firewall_policy.virtual_hub_firewall_policies[each.key]
  virtual_hub = {
    name                = azurerm_virtual_hub.virtual_hubs[each.key].name
    resource_group_name = azurerm_virtual_hub.virtual_hubs[each.key].resource_group_name
  }
}

data "azurerm_virtual_network" "virtual_networks" {
  for_each = local.virtual_networks

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_virtual_hub_connection" "virtual_hub_connections" {
  for_each = local.virtual_hub_connections

  name                      = each.value.name
  virtual_hub_id            = azurerm_virtual_hub.virtual_hubs[each.value.virtual_hub].id
  remote_virtual_network_id = data.azurerm_virtual_network.virtual_networks[each.key].id

  routing {
    associated_route_table_id = (
      each.value.routing.associated_route_table == "Default" ?
      azurerm_virtual_hub.virtual_hubs[each.value.virtual_hub].default_route_table_id :
      (
        each.value.routing.associated_route_table == "None" ?
        replace(azurerm_virtual_hub.virtual_hubs[each.value.virtual_hub].default_route_table_id, "defaultRouteTable", "noneRouteTable") :
        azurerm_virtual_hub_route_table.virtual_hub_route_tables["${each.value.virtual_hub}_${each.value.reference_name}"].id
      )
    )
    propagated_route_table {
      route_table_ids = concat(
        [
          for route_table in each.value.routing.propagated_route_tables :
          azurerm_virtual_hub.virtual_hubs[route_table.virtual_hub].default_route_table_id
          if route_table.name == "Default"
        ],
        [
          for route_table in each.value.routing.propagated_route_tables :
          replace(azurerm_virtual_hub.virtual_hubs[route_table.virtual_hub].default_route_table_id, "defaultRouteTable", "noneRouteTable")
          if route_table.name == "None"
        ],
        [
          for route_table in each.value.routing.propagated_route_tables :
          azurerm_virtual_hub_route_table.virtual_hub_route_tables["${route_table.virtual_hub}_${route_table.reference_name}"].id
          if route_table.name != "Default" && route_table.name != "None"
        ]
      )
    }
  }
}

# Below firewall is not used to attach to the hub.
# It is done in the firewall resource module via a 'virtual_hub_ block.
data "azurerm_firewall" "route_table_route_firewalls" {
  for_each = local.route_table_route_firewalls

  # Since we used grouping, the value is a list of the same object multiple times
  # Therefore, we can use the very first one
  name                = each.value[0].name
  resource_group_name = each.value[0].resource_group_name

  depends_on = [ module.virtual_hub_firewalls ]
}

# CYCLE ALERT! Letting the route tables create their own routes causes a cycle because
# the routes can refer to the connections and connections already refer to the route tables.
# Hence the 'rooute_table_routes' are created in the next block along with the 'Default table' routes.
resource "azurerm_virtual_hub_route_table" "virtual_hub_route_tables" {
  for_each = local.route_tables

  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.virtual_hubs[each.value.virtual_hub].id
}

# Used for creating 'Default route table' routes as well
resource "azurerm_virtual_hub_route_table_route" "route_table_routes" {
  for_each = local.route_table_routes

  route_table_id = azurerm_virtual_hub.virtual_hubs[each.value.virtual_hub].default_route_table_id

  name              = each.value.name
  destinations_type = each.value.destinations_type
  destinations      = each.value.destinations
  next_hop_type     = each.value.next_hop_type
  # We need the connection's reference name rather than its name
  next_hop = (
    each.value.next_hop.firewall != {} ?
    data.azurerm_firewall.route_table_route_firewalls[each.key].id :
    azurerm_virtual_hub_connection.virtual_hub_connections["${each.value.virtual_hub}_${replace(each.value.next_hop.connection_name, "-", "_")}"].id
  )
}