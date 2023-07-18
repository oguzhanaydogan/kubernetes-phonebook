data "azurerm_resources" "resources" {
  type          = var.attached_resource.type
  required_tags = var.attached_resource.required_tags
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.attached_resource.name}-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id


  private_service_connection {
    name                           = "${var.attached_resource.name}-service-connection"
    private_connection_resource_id = data.azurerm_resources.resources.resources.0.id
    is_manual_connection           = var.private_service_connection.is_manual_connection
    subresource_names              = var.private_service_connection.subresource_names != [] ? var.private_service_connection.subresource_names : null
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_ids != [] ? [1] : []

    content {
      name                 = "${var.attached_resource.name}-private-dns-zone-group"
      private_dns_zone_ids = var.private_dns_zone_ids
    }
  }
}