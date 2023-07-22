data "azurerm_ssh_public_key" "ssh_public_key" {
  resource_group_name = var.admin_ssh_key.resource_group_name
  name                = var.admin_ssh_key.name
}

data "azurerm_shared_image" "shared_image" {
  name                = var.shared_image.name
  gallery_name        = var.shared_image.gallery_name
  resource_group_name = var.shared_image.resource_group_name
}

data "azurerm_subnet" "subnets" {
  for_each = var.network_interface.ip_configurations

  name                 = each.value.subnet.name
  virtual_network_name = each.value.subnet.virtual_network_name
  resource_group_name  = each.value.subnet.resource_group_name
}

data "azurerm_network_security_group" "network_security_group" {
  name                = var.network_interface.network_security_group.name
  resource_group_name = var.network_interface.network_security_group.resource_group_name
}

locals {
  lb_backend_address_pools_flattened_info = flatten([
    for k, v in var.network_interface.ip_configurations : [
      for key, pool in v.load_balancer_backend_address_pools : {
        lb_backend_address_pool_name      = pool.load_balancer_name
        load_balancer_name                = pool.load_balancer_name
        load_balancer_resource_group_name = pool.load_balancer_resource_group_name
      }
    ]
  ])

  load_balancers = {
    for info in local.lb_backend_address_pools_flattened_info : info.load_balancer_name => {
      name                = info.load_balancer_name
      resource_group_name = info.load_balancer_resource_group_name
    }...
  }

  lb_backend_address_pools = {
    for info in local.lb_backend_address_pools_flattened_info : info.lb_backend_address_pool_name => {
      name               = info.lb_backend_address_pool_name
      load_balancer_name = info.load_balancer_name
    }
  }
}

data "azurerm_lb" "lb" {
  for_each = local.load_balancers

  name                = each.value[0].name
  resource_group_name = each.value[0].resource_group_name
}

data "azurerm_lb_backend_address_pool" "lb_backend_address_pools" {
  for_each = local.lb_backend_address_pools

  name            = each.value.name
  loadbalancer_id = data.azurerm_lb.lb[each.value.load_balancer_name].id
}

resource "azurerm_linux_virtual_machine_scale_set" "linux_virtual_machine_scale_set" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  instances           = var.instances
  admin_username      = var.admin_username
  source_image_id     = data.azurerm_shared_image.shared_image.id
  upgrade_mode        = var.upgrade_mode
  health_probe_id     = var.health_probe_id

  admin_ssh_key {
    username   = var.admin_username
    public_key = data.azurerm_ssh_public_key.ssh_public_key.public_key
  }

  os_disk {
    storage_account_type = var.os_disk.storage_account_type
    caching              = var.os_disk.caching
  }

  network_interface {
    name                      = var.network_interface.name
    primary                   = var.network_interface.primary
    network_security_group_id = data.azurerm_network_security_group.network_security_group.id

    dynamic "ip_configuration" {
      for_each = var.network_interface.ip_configurations

      content {
        name      = ip_configuration.value.name
        primary   = ip_configuration.value.primary
        subnet_id = data.azurerm_subnet.subnets[ip_configuration.key].id
        load_balancer_backend_address_pool_ids = [
          for k, v in ip_configuration.value.load_balancer_backend_address_pools : data.azurerm_lb_backend_address_pool.lb_backend_address_pools[v.load_balancer_name].id
        ]
      }
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.upgrade_mode == "Rolling" ? [1] : []

    content {
      max_batch_instance_percent              = var.rolling_upgrade_policy.max_batch_instance_percent
      max_unhealthy_instance_percent          = var.rolling_upgrade_policy.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = var.rolling_upgrade_policy.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = var.rolling_upgrade_policy.pause_time_between_batches
    }
  }
}