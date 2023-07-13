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

variable "route_table_associations" {
}

variable "acrs" {
}

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