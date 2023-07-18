data "azurerm_subnet" "subnets" {
  for_each = var.frontend_ip_configurations

  name                 = each.value.subnet.name
  virtual_network_name = each.value.subnet.virtual_network_name
  resource_group_name  = each.value.subnet.resource_group_name
}

resource "azurerm_lb" "lb" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations

    content {
      name      = frontend_ip_configuration.value.name
      subnet_id = data.azurerm_subnet.subnets[frontend_ip_configuration.key].id
    }
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_address_pools" {
  for_each = var.lb_backend_address_pools

  loadbalancer_id = azurerm_lb.lb.id
  name            = each.value.name
}

resource "azurerm_lb_probe" "lb_probes" {
  for_each = var.lb_probes

  loadbalancer_id = azurerm_lb.lb.id
  name            = each.value.name
  protocol        = each.value.protocol
  port            = each.value.port
}

resource "azurerm_lb_rule" "lb_rules" {
  for_each = var.lb_rules

  name                           = each.value.name
  loadbalancer_id                = azurerm_lb.lb.id
  probe_id                       = azurerm_lb_probe.lb_probes[each.value.probe].id
  backend_address_pool_ids       = [
    for pool in each.value.backend_address_pools : azurerm_lb_backend_address_pool.lb_backend_address_pools[pool].id
  ]
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port

  depends_on = [
    azurerm_lb_backend_address_pool.lb_backend_address_pools
  ]
}