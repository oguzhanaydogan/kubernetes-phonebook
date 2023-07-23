variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "network_interface" {
  type = object({
    name = string
    ip_configurations = map(object({
      name = string
      subnet = object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      })
      private_ip_address_allocation = string
      public_ip_assigned            = bool
      public_ip_address = object({
        name                = string
        resource_group_name = string
      })
    }))
  })
}

variable "size" {
  type = string
}

variable "delete_os_disk_on_termination" {
  type = bool
}

variable "delete_data_disks_on_termination" {
  type = bool
}

variable "identity" {
  default = {
    enabled = false
    type = ""
  }
  type = object({
    enabled = bool
    type    = string
  })
}

variable "storage_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "storage_os_disk" {
  type = object({
    caching           = string
    create_option     = string
    managed_disk_type = string
  })
}

variable "os_profile" {
  type = object({
    admin_username = string
    custom_data    = string
  })
}

variable "os_profile_linux_config" {
  type = object({
    disable_password_authentication = bool
    ssh_key = object({
      name                = string
      resource_group_name = string
    })
  })
}

variable "network_security_group_association" {
  type = object({
    enabled                                    = bool
    network_security_group_name                = string
    network_security_group_resource_group_name = string
  })
}