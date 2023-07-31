output "subnet_id" {
  description = "Dedicated subnet id for the Bastion."
  value       = azurerm_bastion_host.bastion_host.ip_configuration.subnet_id
}

output "public_ip_address_id" {
  description = "Azure Bastion public IP."
  value       = azurerm_bastion_host.bastion_host.ip_configuration.public_ip_address_id
}

output "id" {
  description = "Azure Bastion id."
  value       = azurerm_bastion_host.bastion_host.id
}

output "name" {
  description = "Azure Bastion name."
  value       = azurerm_bastion_host.bastion_host.name
}

output "dns_name" {
  description = "Azure Bastion FQDN / generated DNS name."
  value       = azurerm_bastion_host.bastion_host.dns_name
}