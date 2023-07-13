data "azurerm_ssh_public_key" "ssh_public_key" {
  resource_group_name = var.ssh_key_rg
  name                = var.ssh_key_name
}

data "azurerm_shared_image" "example" {
  name                = var.shared_image_name
  gallery_name        = var.shared_image_gallery_name
  resource_group_name = var.shared_image_resource_group_name
}

resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  instances           = var.instances
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = data.azurerm_ssh_public_key.ssh_public_key.public_key
    path = "/home/${var.admin_username}/.ssh/authorized_keys"
  }

  source_image_reference {
    id = data.azurerm_shared_image.example.id
  }

  os_disk {
    storage_account_type = var.os_disk_storage_account_type
    caching              = var.os_disk_caching
  }

  network_interface {
    name    = var.network_interface_name
    primary = var.network_interface_primary

    ip_configuration {
      name      = var.ip_configuration_name
      primary   = var.ip_configuration_primary
      subnet_id = var.ip_configuration_subnet_id
      load_balancer_backend_address_pool_ids = var.ip_configuration_load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids    = var.ip_configuration_load_balancer_inbound_nat_pool_ids
    }
  }
  rolling_upgrade_policy {
    max_batch_instance_percent              = 21
    max_unhealthy_instance_percent          = 22
    max_unhealthy_upgraded_instance_percent = 23
    pause_time_between_batches              = "PT30S"
  }
}