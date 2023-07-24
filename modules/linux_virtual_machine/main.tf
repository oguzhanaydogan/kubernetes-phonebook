data "azurerm_ssh_public_key" "ssh_public_key" {
  resource_group_name = var.os_profile_linux_config.ssh_key.resource_group_name
  name                = var.os_profile_linux_config.ssh_key.name
}

data "azurerm_subnet" "subnets" {
  for_each = var.network_interface.ip_configurations

  name                 = each.value.subnet.name
  virtual_network_name = each.value.subnet.virtual_network_name
  resource_group_name  = each.value.subnet.resource_group_name
}

data "azurerm_public_ip" "public_ip_addresses" {
  for_each = var.network_interface.ip_configurations

  name                = each.value.public_ip_address.name
  resource_group_name = each.value.public_ip_address.resource_group_name
}

resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "ip_configuration" {
    for_each = var.network_interface.ip_configurations

    content {
      name                          = ip_configuration.value.name
      subnet_id                     = data.azurerm_subnet.subnets[ip_configuration.key].id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      public_ip_address_id          = ip_configuration.value.public_ip_assigned ? data.azurerm_public_ip.public_ip_addresses[ip_configuration.key].id : ""
    }
  }
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                             = var.name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  network_interface_ids            = [azurerm_network_interface.network_interface.id]
  vm_size                          = var.size
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type = var.identity.type
    }
  }

  storage_image_reference {
    publisher = var.storage_image_reference.publisher
    offer     = var.storage_image_reference.offer
    sku       = var.storage_image_reference.sku
    version   = var.storage_image_reference.version
  }

  storage_os_disk {
    name              = "${var.name}-disk"
    caching           = var.storage_os_disk.caching
    create_option     = var.storage_os_disk.create_option
    managed_disk_type = var.storage_os_disk.managed_disk_type
  }

  os_profile {
    computer_name  = var.name
    admin_username = var.os_profile.admin_username
    custom_data    = file(var.os_profile.custom_data)
  }

  os_profile_linux_config {
    disable_password_authentication = var.os_profile_linux_config.disable_password_authentication

    ssh_keys {
      path     = "/home/${var.os_profile.admin_username}/.ssh/authorized_keys"
      key_data = data.azurerm_ssh_public_key.ssh_public_key.public_key
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics != null ? [1] : []

    content {
      storage_uri = var.boot_diagnostics.storage_uri
      enabled     = true
    }
  }
}

data "azurerm_network_security_group" "network_security_group" {
  name                = var.network_security_group_association.network_security_group_name
  resource_group_name = var.network_security_group_association.network_security_group_resource_group_name
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  count = var.network_security_group_association != null ? 1 : 0

  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = data.azurerm_network_security_group.network_security_group.id
}