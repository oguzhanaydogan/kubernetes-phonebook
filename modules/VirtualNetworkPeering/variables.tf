variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "remote_virtual_network" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "allow_forwarded_traffic" {
  type = bool
}