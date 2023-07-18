data "azurerm_subnet" "subnets" {
  for_each = var.ip_configurations

  name                 = each.value.subnet.name
  virtual_network_name = each.value.subnet.virtual_network_name
  resource_group_name  = each.value.subnet.resource_group_name
}

data "azurerm_public_ip" "public_ips" {
  for_each = var.ip_configurations

  name                = each.value.public_ip_address.name
  resource_group_name = each.value.public_ip_address.resource_group_name
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "ip_configuration" {
    for_each = var.ip_configurations

    content {
      name                 = ip_configuration.value.name
      subnet_id            = data.azurerm_subnet.subnets[ip_configuration.key].id
      public_ip_address_id = data.azurerm_public_ip.public_ips[ip_configuration.key].id
    }
  }
}