data "azurerm_subnet" "subnet_firewall" {
	name = var.ip_configuration.subnet.name
	virtual_network_name = var.ip_configuration.subnet.virtual_network_name
	resource_group_name = var.ip_configuration.subnet.resource_group_name
}

data "azurerm_subnet" "subnet_firewall_management" {
	name = "AzureFirewallManagementSubnet"
	virtual_network_name = var.management_ip_configuration.subnet.virtual_network_name
	resource_group_name = var.management_ip_configuration.subnet.resource_group_name
}

data "azurerm_public_ip" "public_ip_firewall_management" {
	name = var.management_ip_configuration.public_ip_address.name
	resource_group_name = var.management_ip_configuration.public_ip_address.resource_group_name
}

resource "azurerm_firewall" "hub_firewall" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier

  ip_configuration {
    name                 = "${var.name}-ip-configuration"
    subnet_id            = data.azurerm_subnet.subnet_firewall.id
  }

  dynamic "management_ip_configuration" {
	for_each = var.management_ip_configuration.enabled ? [1] : []

	content {
		name = "${var.name}-management-ip-configuration"
		subnet_id = data.azurerm_subnet.subnet_firewall_management.id
		public_ip_address_id = data.azurerm_public_ip.public_ip_firewall_management.id
	}
  }
}