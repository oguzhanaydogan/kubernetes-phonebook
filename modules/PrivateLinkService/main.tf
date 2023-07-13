resource "azurerm_private_link_service" "example" {
  name                = var.link_name
  resource_group_name = var.resource_group_name
  location            = var.location

  auto_approval_subscription_ids              = var.auto_approval_subscription_ids
  visibility_subscription_ids = var.visibility_subscription_ids
  load_balancer_frontend_ip_configuration_ids = var.load_balancer_frontend_ip_configuration_ids 

  dynamic "nat_ip_configuration" {
    for_each = var.nat_ip_configurations
    content {
        name                       = nat_ip_configuration.value.name
        subnet_id                  = nat_ip_configuration.value.subnet_id
        primary                    = nat_ip_configuration.value.primary
    }
  }
}