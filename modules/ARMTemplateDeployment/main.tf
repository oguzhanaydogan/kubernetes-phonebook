resource "azurerm_resource_group_template_deployment" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
  deployment_mode     = var.deployment_mode
  parameters_content = jsonencode(var.parameters_content)
  template_content = <<TEMPLATE
${var.template_content}
TEMPLATE
}