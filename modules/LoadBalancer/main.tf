resource "azurerm_lb" "example" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = var.frontend_ip_configuration_public_ip_address_id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = var.lb_backend_address_pool_loadbalancer_id
  name            = var.lb_backend_address_pool_name
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = var.resource_group_name
  name                           = var.lb_nat_pool_name
  loadbalancer_id                = var.lb_nat_pool_loadbalancer_id
  protocol                       = var.lb_nat_pool_protocol
  frontend_port_start            = var.lb_nat_pool_rontend_port_start
  frontend_port_end              = var.lb_nat_pool_frontend_port_end
  backend_port                   = var.lb_nat_pool_backend_port
  frontend_ip_configuration_name = var.lb_nat_pool_frontend_ip_configuration_name
}

resource "azurerm_lb_probe" "example" {
  loadbalancer_id = var.lb_probe_loadbalancer_id
  name            = var.lb_probe_name
  protocol        = var.lb_probe_protocol
  request_path    = var.lb_probe_request_path
  port            = var.lb_probe_port
}