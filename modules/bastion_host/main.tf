# If existing 'subnet', retrieve its data
data "azurerm_subnet" "existing_subnet" {
  count = var.ip_configuration.subnet.existing != null ? 1 : 0

  name                 = var.ip_configuration.existing_subnet.name
  virtual_network_name = var.ip_configuration.existing_subnet.virtual_network_name
  resource_group_name  = var.ip_configuration.existing_subnet.resource_group_name
}

# If new 'subnet', create it
module "new_subnet" {
  source = "../subnet"
  count  = var.ip_configuration.subnet.new != null ? 1 : 0

  name             = "AzureBastionSubnet"
  virtual_network  = var.ip_configuration.subnet.new.virtual_network
  address_prefixes = var.ip_configuration.subnet.new.address_prefixes
}

# If existing 'public IP address', retrieve its data
data "azurerm_public_ip" "existing_public_ip" {
  count = var.ip_configuration.public_ip_address.existing != null ? 1 : 0

  name                = var.ip_configuration.existing_public_ip_address.name
  resource_group_name = var.ip_configuration.existing_public_ip_address.resource_group_name
}

# If new 'public IP address', create it
module "new_public_ip_address" {
  source = "../public_ip_address"
  count  = var.ip_configuration.public_ip_address.new != null ? 1 : 0

  name                = var.ip_configuration.public_ip_address.new.name
  location            = var.ip_configuration.public_ip_address.new.location
  resource_group_name = var.ip_configuration.public_ip_address.new.resource_group_name
  allocation_method   = var.ip_configuration.public_ip_address.new.allocation_method
  sku                 = var.ip_configuration.public_ip_address.new.sku
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = var.ip_configuration.name
    subnet_id = coalesce(
      try(data.azurerm_subnet.existing_subnet.id, ""),
      module.new_subnet.id
    )
    public_ip_address_id = coalesce(
      data.azurerm_public_ip.existing_public_ip.id,
      module.new_public_ip_address.id
    )
  }
}