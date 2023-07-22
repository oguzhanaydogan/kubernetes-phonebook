data "azurerm_subnet" "subnet" {
  name = var.subnet.name
  resource_group_name = var.subnet.resource_group_name
  virtual_network_name = var.subnet.virtual_network_name
}

data "azurerm_resources" "resources" {
  type          = var.attached_resource.type
  required_tags = var.attached_resource.required_tags
}

data "azurerm_private_dns_zone" "private_dns_zones" {
  for_each = {
    for zone in var.private_dns_zone_group.private_dns_zones :
      zone.name => {
        name = zone.name
        resource_group_name = zone.resource_group_name
      }
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = var.private_service_connection.name
    private_connection_resource_id = data.azurerm_resources.resources.resources.0.id
    is_manual_connection           = var.private_service_connection.is_manual_connection
    subresource_names              = var.private_service_connection.subresource_names
  }

  private_dns_zone_group {
    name                 = var.private_dns_zone_group.name
    private_dns_zone_ids = data.azurerm_subnet.subnet[*].id
  }
}