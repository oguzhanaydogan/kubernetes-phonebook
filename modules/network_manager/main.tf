data "azurerm_subscription" "current_subscription" {
  count = var.scope.current_subscription_enabled ? 1 : 0
}

locals {
  network_group_policies_flattened = flatten([
    for key, group in var.network_groups : [
      for k, policy in group.policies : merge(policy, { network_group = key })
    ]
  ])

  network_group_policies = {
    for policy in local.network_group_policies_flattened : "${policy.network_group}_${policy.name}" => policy
  }

  connectivity_configurations_flattened = flatten([
    for key, group in var.network_groups : [
      for k, config in group.connectivity_configurations : merge(config, { network_group = key })
    ]
  ])

  connectivity_configurations = {
    for config in local.connectivity_configurations_flattened : "${config.network_group}_${config.name}" => config
  }
}

resource "azurerm_network_manager" "network_manager" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  scope_accesses      = var.scope_accesses

  scope {
    subscription_ids = concat(try([data.azurerm_subscription.current_subscription[0].id], []), var.scope.other_subscription_ids)
  }
}

resource "azurerm_network_manager_network_group" "network_groups" {
  for_each = var.network_groups

  name               = each.value.name
  network_manager_id = azurerm_network_manager.network_manager.id
}

resource "azurerm_policy_definition" "custom_policies" {
  for_each = local.network_group_policies

  name         = each.value.name
  policy_type  = "Custom"
  mode         = "Microsoft.Network.Data"
  display_name = "Policy Definition for Network Group ${each.value.name}"

  metadata = <<METADATA
    {
      "category": "Azure Virtual Network Manager"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks"
          },
          ${each.value.rule.conditions}
        ]
      },
      "then": {
        "effect": "${each.value.rule.effect}",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.network_groups[each.value.network_group].id}"
        }
      }
    }
  POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "azure_policy_assignments" {
  for_each = local.network_group_policies

  name                 = "${each.value.name}-policy-assignment"
  policy_definition_id = azurerm_policy_definition.custom_policies[each.key].id
  subscription_id      = coalesce(
    each.value.subscription.is_current ? data.azurerm_subscription.current_subscription.id : "",
    each.value.subscription.id
  )
}

resource "azurerm_network_manager_connectivity_configuration" "connectivity_configurations" {
  for_each = local.connectivity_configurations

  name                  = each.value.name
  network_manager_id    = azurerm_network_manager.network_manager.id
  connectivity_topology = each.value.connectivity_topology

  applies_to_group {
    group_connectivity = each.value.applies_to_group.group_connectivity
    network_group_id   = azurerm_network_manager_network_group.network_groups[each.value.network_group].id
  }
}

resource "azurerm_network_manager_deployment" "network_manager_deployments" {
  for_each = local.connectivity_configurations

  network_manager_id = azurerm_network_manager.network_manager.id
  location           = each.value.deployment.location
  scope_access       = each.value.deployment.scope_access
  configuration_ids  = [azurerm_network_manager_connectivity_configuration.connectivity_configurations[each.key].id]
}