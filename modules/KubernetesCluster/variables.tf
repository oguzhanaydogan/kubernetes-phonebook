variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "public_network_access_enabled" {
  type = bool
}

variable "private_cluster_enabled" {
  type = bool
}

variable "subnet_aks" {
  type = object({
    name                 = string
    virtual_network_name = string
    resource_group_name  = string
  })
}

variable "default_node_pool" {
  type = object({
    name       = string
    node_count = number
    vm_size    = string
  })
}

variable "identity" {
  type = object({
    type = string
  })
}

variable "subnet_agw" {
  type = object({
    name                 = string
    virtual_network_name = string
    resource_group_name  = string
  })
}

variable "ingress_application_gateway" {
  type = object({
    enabled = bool
    name    = string
  })
}

variable "network_profile" {
  type = object({
    network_plugin     = string
    network_policy     = string
    service_cidr       = string
    dns_service_ip     = string
    docker_bridge_cidr = string
    outbound_type      = string
  })
}