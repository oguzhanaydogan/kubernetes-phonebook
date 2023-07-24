data "azurerm_subnet" "subnet_firewall" {
  count = var.ip_configuration != null ? 1 : 0

  name                 = var.ip_configuration.subnet.name
  virtual_network_name = var.ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.ip_configuration.subnet.resource_group_name
}

data "azurerm_subnet" "subnet_firewall_management" {
  count = var.management_ip_configuration != null ? 1 : 0

  name                 = "AzureFirewallManagementSubnet"
  virtual_network_name = var.management_ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.management_ip_configuration.subnet.resource_group_name
}

data "azurerm_virtual_hub" "virtual_hub" {
  count = var.virtual_hub != null ? 1 : 0

  name                = var.virtual_hub.name
  resource_group_name = var.virtual_hub.resource_group_name
}

data "azurerm_public_ip" "public_ip_firewall_management" {
  count = var.management_ip_configuration != null ? 1 : 0

  name                = var.management_ip_configuration.public_ip_address.name
  resource_group_name = var.management_ip_configuration.public_ip_address.resource_group_name
}

data "azurerm_firewall_policy" "firewall_policy" {
  count = var.firewall_policy != null ? 1 : 0

  name = var.firewall_policy.name
  resource_group_name = var.firewall_policy.resource_group_name
}

resource "azurerm_firewall" "firewall" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id = try(data.azurerm_firewall_policy.firewall_policy.id, null)

  dynamic "virtual_hub" {
    count = var.virtual_hub != null ? 1 : 0

    content {
     virtual_hub_id = data.azurerm_virtual_hub.virtual_hub.id
    }
  }

  dynamic "ip_configuration" {
    count = var.ip_configuration != null ? 1 : 0

    content {
      name      = var.ip_configuration.name
      subnet_id = data.azurerm_subnet.subnet_firewall.id
    }
  }

  dynamic "management_ip_configuration" {
    count = var.management_ip_configuration != null ? 1 : 0

    content {
      name                 = var.management_ip_configuration.name
      subnet_id            = data.azurerm_subnet.subnet_firewall_management.id
      public_ip_address_id = data.azurerm_public_ip.public_ip_firewall_management.id
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "firewall_network_rule_collection" {
  for_each = var.firewall_network_rule_collections

  name                = each.value.name
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group_name
  priority            = each.value.priority
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.firewall_network_rules

    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }
}