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
  # Collect all load balancer backend address pool names from all ip configurations
  # Apply toset to cancel the duplicates
  lb_backend_address_pool_names_from_all_ip_configurations = toset(flatten([
    for k, ip_configuration in var.network_interface.ip_configurations : ip_configuration.load_balancer_backend_address_pool_names
  ]))
}

data "azurerm_lb" "lb" {
  name                = var.load_balancer.name
  resource_group_name = var.load_balancer.resource_group_name
}

data "azapi_resource" "health_probe" {
  type      = "Microsoft.Network/loadBalancers/probes@2023-02-01"
  name      = var.health_probe_name
  parent_id = data.azurerm_lb.lb.id
}

data "azurerm_lb_backend_address_pool" "lb_backend_address_pools" {
  for_each = local.lb_backend_address_pool_names_from_all_ip_configurations

  name            = each.value
  loadbalancer_id = data.azurerm_lb.lb.id
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
  health_probe_id     = data.azapi_resource.health_probe.id

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
          for pool_name in ip_configuration.value.load_balancer_backend_address_pool_names : data.azurerm_lb_backend_address_pool.lb_backend_address_pools[pool_name].id
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