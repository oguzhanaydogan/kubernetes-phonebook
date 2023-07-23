variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet" {
  type = object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
  })
}

variable "attached_resource" {
  type = object({
    name          = string
    type          = string
    required_tags = map(string)
  })
}

variable "private_service_connection" {
  type = object({
    name                 = string
    is_manual_connection = bool
    subresource_names    = list(string)
  })
}

variable "private_dns_zone_group" {
  type = object({
    name = string
    private_dns_zones = list(object({
      name                = string
      resource_group_name = string
    }))
  })
}