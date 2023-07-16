variable "resource_groups" {
  type = map(string)
}

variable "virtual_networks" {
  # type = map
}

variable "subnets" {
}

variable "vnet_peerings" {
}

variable "route_tables" {
}

# variable "acrs" {
# }

variable "public_ip_addresses" {
}

variable "network_security_groups" {
}

variable "linux_virtual_machines" {
}

variable "key_vault_access_policies" {
  description = "This is for Terraform"
}
variable "key_vault_secrets" {
}

variable "mssql_servers" {
}

variable "mssql_databases" {
}

variable "load_balancers" {
}

variable "private_link_services" {
}

variable "linux_virtual_machine_scale_sets" {
}

variable "bastion_hosts" {
}

variable "private_dns_zones" {
}

variable "private_endpoints" {
}

variable "front_doors" {
}