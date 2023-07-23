variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "routes" {
  default = {}
  type = map(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
}

variable "subnet_associations" {
  default = {}
  type = map(object({
    subnet_name          = string
    resource_group_name  = string
    virtual_network_name = string
  }))
}