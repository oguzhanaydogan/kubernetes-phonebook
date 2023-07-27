output "x" {
  value = jsonencode(
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks"
          },
          "${var.network_groups["nmng_project102_prod_westeurope_001"].policies["nmngp_project102_prod_westeurope_001"].rule.conditions}"
        ]
      },
      "then": {
        "effect": "${var.network_groups["nmng_project102_prod_westeurope_001"].policies["nmngp_project102_prod_westeurope_001"].rule.effect}",
        "details": {
          "networkGroupId": "${azurerm_network_manager_network_group.network_groups["nmng_project102_prod_westeurope_001"].id}"
        }
      }
    }
  )
}