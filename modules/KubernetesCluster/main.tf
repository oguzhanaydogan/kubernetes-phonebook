data "azurerm_subnet" "subnet_aks" {
  name                 = var.subnet_aks.name
  virtual_network_name = var.subnet_aks.virtual_network_name
  resource_group_name  = var.subnet_aks.resource_group_name
}

data "azurerm_subnet" "subnet_appgw" {
  name                 = var.subnet_appgw.name
  virtual_network_name = var.subnet_appgw.virtual_network_name
  resource_group_name  = var.subnet_appgw.resource_group_name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  dns_prefix              = "${var.name}-dns"
  node_resource_group     = "${var.name}-node-rg"
  private_cluster_enabled = var.private_cluster_enabled

  default_node_pool {
    name           = var.default_node_pool.name
    node_count     = var.default_node_pool.node_count
    vm_size        = var.default_node_pool.vm_size
    vnet_subnet_id = data.azurerm_subnet.subnet_aks.id
  }

  identity {
    type = var.identity.type
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway.enabled == true ? [1] : []

    content {
      gateway_name = var.ingress_application_gateway.gateway_name
      subnet_id    = data.azurerm_subnet.subnet_appgw.id
    }
  }

  network_profile {
    network_plugin = var.network_profile.network_plugin
    outbound_type  = var.network_profile.outbound_type
  }
}