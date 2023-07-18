output "endpoint_urls" {
  value = azurerm_cdn_frontdoor_endpoint.cdn_frontdoor_endpoints[*].host_name
}

output "name" {
  value = azurerm_cdn_frontdoor_profile.cdn_frontdoor_profile.name
}