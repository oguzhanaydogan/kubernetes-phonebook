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
  source_image_id = data.azurerm_shared_image.example.id
  upgrade_mode = "Rolling"
  health_probe_id = var.health_probe_id
  admin_ssh_key {
    username   = var.admin_username
    public_key = data.azurerm_ssh_public_key.ssh_public_key.public_key
    # path = "/home/${var.admin_username}/.ssh/authorized_keys"
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
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }
}

# resource "azurerm_virtual_machine_scale_set" "example" {
#   name                = var.name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   upgrade_policy_mode  = "Rolling"
#   health_probe_id = var.health_probe_id
  
#   rolling_upgrade_policy {
#     max_batch_instance_percent              = 20
#     max_unhealthy_instance_percent          = 20
#     max_unhealthy_upgraded_instance_percent = 5
#     pause_time_between_batches              = "PT0S"
#   }

#   # required when using rolling upgrade policy
#   sku {
#     name     = "Standard_B1S"
#     tier     = "Standard"
#     capacity = 2
#   }

#   storage_profile_image_reference {
#     id = var.source_image_id
#   }

#   storage_profile_os_disk {
#     name              = ""
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   storage_profile_data_disk {
#     lun           = 0
#     caching       = "ReadWrite"
#     create_option = "Empty"
#     disk_size_gb  = 10
#   }

#   os_profile {
#     computer_name_prefix = "testvm"
#     admin_username       = "azureuser"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = true

#     ssh_keys {
#       path     = "/home/myadmin/.ssh/authorized_keys"
#       key_data = file("~/.ssh/demo_key.pub")
#     }
#   }

#   network_profile {
#     name    = "terraformnetworkprofile"
#     primary = true

#     ip_configuration {
#       name                                   = "TestIPConfiguration"
#       primary                                = true
#       subnet_id                              = azurerm_subnet.example.id
#       load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
#       load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
#     }
#   }
# }