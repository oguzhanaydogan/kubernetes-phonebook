variable "name" {
}

variable "resource_group_name" {
}
variable "virtual_network_name" {
}

variable "address_prefixes" {
}

variable "delegation" {
}

variable "delegation_name" {
  default  = null
  nullable = true
}

variable "private_link_service_network_policies_enabled" {
}