variable "rg_project102_prod_global_001" {
  name     = "rg-project102-prod-global-001"
  location = "East US"
}

variable "rg_project102_prod_eastus_001" {
  name     = "rg-project102-prod-eastus-001"
  location = "East US"
}

variable "rg_project102_prod_westeurope_001" {
  name     = "rg-project102-prod-westeurope-001"
  location = "West Europe"
}

variable "vnet_project102_prod_eastus_001" { // app
  name                = "vnet-project102-prod-eastus-001"
  # resource_group_name is provided by the root 'main.tf'.
  location            = "East US"
  address_space       = ["10.1.0.0/16"]
}

variable "snet_project102_prod_eastus_001" { // aks
	name             = "snet-project102-prod-eastus-001"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.1.1.0/24"]
}

variable "snet_project102_prod_eastus_002" { // agw
	name             = "snet-project102-prod-eastus-002"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.1.2.0/24"]
}

variable "vnet_project102_prod_eastus_002" { // acr
  name                = "vnet-project102-prod-eastus-002"
  # resource_group_name is provided by the root 'main.tf'.
  location            = "East US"
  address_space       = ["10.2.0.0/16"]
}

variable "snet_project102_prod_eastus_003" { // acr
	name             = "snet-project102-prod-eastus-003"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.2.1.0/24"]
}

variable "vnet_project102_prod_eastus_003" { // sql-us
  name                = "vnet-project102-prod-eastus-003"
  # resource_group_name is provided by the root 'main.tf'.
  location            = "East US"
  address_space       = ["10.3.0.0/16"]
}

variable "snet_project102_prod_eastus_004" { // sql-us
	name             = "snet-project102-prod-eastus-004"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.3.1.0/24"]
}

variable "snet_project102_prod_eastus_005" { // sql-us-pep
	name             = "snet-project102-prod-eastus-005"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.3.2.0/24"]
}

variable "vnet_project102_prod_eastus_004" { // ci/cd agent
  name                = "vnet-project102-prod-eastus-004"
  # resource_group_name is provided by the root 'main.tf'.
  location            = "East US"
  address_space       = ["10.4.0.0/16"]
}

variable "snet_project102_prod_eastus_006" { // ci/cd agent
	name             = "snet-project102-prod-eastus-006"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.4.1.0/24"]
}

variable "vnet_project102_prod_westeurope_001" { // app
  name                = "vnet-project102-prod-westeurope-001"
  # resource_group_name is provided by the root 'main.tf'.
  location            = "West Europe"
  address_space       = ["10.11.0.0/16"]
}

variable "snet_project102_prod_westeurope_001" { // app
	name             = "snet-project102-prod-westeurope-001"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.11.1.0/24"]
}

variable "snet_project102_prod_westeurope_002" { // lb
	name             = "snet-project102-prod-westeurope-002"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.11.2.0/24"]
}

variable "snet_project102_prod_westeurope_003" { // lb-pls
	name                                          = "snet-project102-prod-westeurope-003"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes                              = ["10.11.3.0/24"]
	private_link_service_network_policies_enabled = false
}

variable "snet_project102_prod_westeurope_004" { // lb-pls-pep
	name             = "snet-project102-prod-westeurope-004"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.11.4.0/24"]
}

variable "snet_project102_prod_westeurope_005" { // bastion
	name             = "AzureBastionSubnet"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.11.5.0/24"]
}

variable "vnet_project102_prod_westeurope_002" { // sql-eu
  name                = "vnet-project102-prod-westeurope-002"
  # resource_group_name is provided by the root 'main.tf'.
  location            = "West Europe"
  address_space       = ["10.12.0.0/16"]
}

variable "snet_project102_prod_westeurope_006" { // sql-eu
	name             = "snet-project102-prod-westeurope-006"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.12.1.0/24"]
}

variable "snet_project102_prod_westeurope_007" { // sql-eu-pep
	name             = "snet-project102-prod-westeurope-007"
  # resource_group_name is provided by the root 'main.tf'.
  # virtual_network_name is provided by the root 'main.tf'.
	address_prefixes = ["10.12.2.0/24"]
}

variable "afd_project102_prod_global_001" {}

variable "aks_project102_prod_eastus_001" {}

variable "bas_project102_prod_westeurope_001" {}

variable "fwp_project102_prod_eastus_001" {}

variable "kvap_project102_prod_global_001" {}

variable "kvs_project102_prod_global_001" {}

variable "lb_project102_prod_westeurope_001" {}

variable "nm_project102_prod_westeurope_001" {}

variable "nsg_project102_prod_eastus_001" {}

variable "nsg_project102_prod_westeurope_001" {}

variable "peer_project102_prod_global_001" {}

variable "peer_project102_prod_global_002" {}

variable "pep_project102_prod_eastus_001" {}

variable "pep_project102_prod_westeurope_001" {}

variable "pip_project102_prod_eastus_001" {}

variable "pip_project102_prod_westeurope_001" {}

variable "privatelink_database_windows_net_project102_prod_global_001" {}

variable "sql_project102_prod_eastus_001" {}

variable "sql_project102_prod_westeurope_001" {}

variable "vm_project102_prod_eastus_001" {}

variable "vmss_project102_prod_westeurope_001" {}

variable "vwan_project102_prod_eastus_001" {}