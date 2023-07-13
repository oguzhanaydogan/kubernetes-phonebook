output "backend_address_pool_ids" {
    value = azurerm_lb_backend_address_pool.bpepool.id
}

output "inbound_nat_pool_ids" {
    value = azurerm_lb_nat_pool.lbnatpool.id
}