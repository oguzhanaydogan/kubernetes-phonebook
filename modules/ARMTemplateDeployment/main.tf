resource "azurerm_resource_group_template_deployment" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
  deployment_mode     = var.deployment_mode
  template_content = var.template_content
}