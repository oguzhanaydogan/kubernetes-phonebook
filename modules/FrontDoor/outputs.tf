output "endpoint_urls" {
  value = azurerm_cdn_frontdoor_endpoint.example[*].host_name
}

output "name" {
  value = azurerm_cdn_frontdoor_profile.example.name
}