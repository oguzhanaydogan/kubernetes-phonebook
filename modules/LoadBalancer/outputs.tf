output "backend_address_pool_ids" {
  value = azurerm_lb_backend_address_pool.bpepool.id
}

output "frontend_ip_configuration_id" {
  value = azurerm_lb.example.frontend_ip_configuration.0.id
}

output "health_probe_id" {
  value = azurerm_lb_probe.example.id
}