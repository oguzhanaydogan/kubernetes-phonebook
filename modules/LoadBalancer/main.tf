data "azurerm_subnet" "example" {
  for_each = var.frontend_ip_configurations

  name                 = each.value.subnet.name
  virtual_network_name = each.value.subnet.virtual_network_name
  resource_group_name  = each.value.subnet.resource_group_name
}

resource "azurerm_lb" "example" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations

    content {
      name      = frontend_ip_configuration.value.name
      subnet_id = data.azurerm_subnet.example[frontend_ip_configurations.key].id
    }
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.example.id
  name            = var.lb_backend_address_pool_name
}

resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = var.lb_probe_name
  protocol        = var.lb_probe_protocol
  port            = var.lb_probe_port
}

resource "azurerm_lb_rule" "main" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.example.id
  probe_id                       = azurerm_lb_probe.example.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  protocol                       = var.lb_probe_protocol
  frontend_port                  = var.lb_probe_port
  backend_port                   = var.lb_probe_port
}