terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
  
  # backend "azurerm" {
  #   resource_group_name  = "coy-backend"
  #   storage_account_name = "coystorage"
  #   container_name       = "terraformstate"
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true
}

module "resource_groups" {
    source = "./modules/ResourceGroup"
    for_each = var.resource_groups
    name = each.key
    location = each.value
}

module "virtual_networks" {
    source = "./modules/VirtualNetwork"
    for_each = var.virtual_networks
    name = each.key
    resource_group_name = module.resource_groups[each.value.resource_group].name
    location = module.resource_groups[each.value.resource_group].location
    address_space = each.value.address_space
}
