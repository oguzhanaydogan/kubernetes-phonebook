variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type = string
}

variable "instances" {
  type = number
}

variable "admin_username" {
  type = string
}

variable "shared_image" {
  type = object({
    name                = string
    gallery_name        = string
    resource_group_name = string
  })
}

variable "upgrade_mode" {
  type = string
}

variable "load_balancer" {
  default = {
    name = ""
    resource_group_name = ""
  }
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "health_probe_name" {
  type = string
}

variable "admin_ssh_key" {
  type = object({
    resource_group_name = string
    name                = string
  })
}

variable "os_disk" {
  type = object({
    storage_account_type = string
    caching              = string
  })
}

variable "network_interface" {
  type = object({
    name    = string
    primary = bool
    network_security_group = object({
      name                = string
      resource_group_name = string
    })
    ip_configurations = map(object({
      name    = string
      primary = bool
      subnet = object({
        name                 = string
        virtual_network_name = string
        resource_group_name  = string
      })
      load_balancer_backend_address_pool_names = list(string)
    }))
  })
}

variable "rolling_upgrade_policy" {
  default = {
    max_batch_instance_percent              = 0
    max_unhealthy_instance_percent          = 0
    max_unhealthy_upgraded_instance_percent = 0
    pause_time_between_batches              = ""
  }
  type = object({
    max_batch_instance_percent              = number
    max_unhealthy_instance_percent          = number
    max_unhealthy_upgraded_instance_percent = number
    pause_time_between_batches              = string
  })
}