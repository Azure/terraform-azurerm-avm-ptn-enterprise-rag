locals {
  subnets = { for key, value in var.virtual_network_subnets : key => {
    name             = value.name
    address_prefixes = [module.subnet_address_prefixes.address_prefixes[key]]
    }
  }
}

module "subnet_address_prefixes" {
  source  = "Azure/avm-utl-network-ip-addresses/azurerm"
  version = "0.1.0"

  address_space    = var.virtual_network_address_space[0]
  address_prefixes = { for key, value in var.virtual_network_subnets : key => value.prefix_size }
  enable_telemetry = var.enable_telemetry
}

module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.8.1"

  name                = module.naming.virtual_network.name_unique
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.virtual_network_address_space
  subnets             = local.subnets
  enable_telemetry    = var.enable_telemetry
}

