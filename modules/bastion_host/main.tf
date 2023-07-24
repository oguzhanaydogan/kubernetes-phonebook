data "azurerm_subnet" "subnet" {
  name                 = var.ip_configuration.subnet.name
  virtual_network_name = var.ip_configuration.subnet.virtual_network_name
  resource_group_name  = var.ip_configuration.subnet.resource_group_name
}

data "azurerm_public_ip" "public_ip" {
  name                = var.ip_configuration.public_ip_address.name
  resource_group_name = var.ip_configuration.public_ip_address.resource_group_name
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = var.ip_configuration.name
    subnet_id            = data.azurerm_subnet.subnet.id
    public_ip_address_id = data.azurerm_public_ip.public_ip.id
  }
}