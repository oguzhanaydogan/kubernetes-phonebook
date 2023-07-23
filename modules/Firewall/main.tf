# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group

data "azurerm_subnet" "subnet_firewall" {
  name                 = var.ip_configuration.subnet.name
  virtual_network_name = var.ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.ip_configuration.subnet.resource_group_name
}

data "azurerm_subnet" "subnet_firewall_management" {
  name                 = "AzureFirewallManagementSubnet"
  virtual_network_name = var.management_ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.management_ip_configuration.subnet.resource_group_name
}

data "azurerm_virtual_hub" "virtual_hub" {
  name                = var.virtual_hub.name
  resource_group_name = var.virtual_hub.resource_group_name
}

data "azurerm_public_ip" "public_ip_firewall_management" {
  name                = var.management_ip_configuration.public_ip_address.name
  resource_group_name = var.management_ip_configuration.public_ip_address.resource_group_name
}

resource "azurerm_firewall" "firewall" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  virtual_hub {
    virtual_hub_id = data.azurerm_virtual_hub.virtual_hub.id
  }

  ip_configuration {
    name      = var.ip_configuration.name
    subnet_id = data.azurerm_subnet.subnet_firewall.id
  }

  dynamic "management_ip_configuration" {
    for_each = var.management_ip_configuration.enabled ? [1] : []

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