variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_links" {
  type = map(object({
    name = string
    virtual_network = object({
      name                = string
      resource_group_name = string
    })
  }))
}
