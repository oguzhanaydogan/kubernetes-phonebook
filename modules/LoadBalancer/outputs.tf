output "frontend_ip_configuration_id" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].id
}

output "health_probes" {
  value = azurerm_lb_probe.lb_probes
}