data "azurerm_subnet" "akssubnet" {
  name                 = var.subnet_aks.name
  virtual_network_name = var.subnet_aks.virtual_network_name
  resource_group_name  = var.subnet_aks.resource_group_name
}
 
data "azurerm_subnet" "appgwsubnet" {
  name                 = var.subnet_appgw.name
  virtual_network_name = var.subnet_appgw.virtual_network_name
  resource_group_name  = var.subnet_appgw.resource_group_name
}
 
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}dns"
  kubernetes_version  = var.kubernetes_version
 
  node_resource_group = "${var.name}-node-rg"
 
  default_node_pool {
    name                 = var.default_node_pool.name
    node_count           = var.default_node_pool.node_count
    vm_size              = var.default_node_pool.vm_size
    vnet_subnet_id       = data.azurerm_subnet.akssubnet.id
    type                 = var.default_node_pool.type
    orchestrator_version = var.default_node_pool.orchestrator_version
  }
 
  identity {
    type = var.identity.type
  }

  ingress_application_gateway {
    enabled = var.ingress_application_gateway.enabled
    gateway_name = var.ingress_application_gateway.gateway_name
    subnet_cidr = var.ingress_application_gateway.subnet_cidr
    subnet_id = var.ingress_application_gateway.subnet_id
  }
}