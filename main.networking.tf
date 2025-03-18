module "subnet_address_prefixes" {
  count = var.use_private_networking ? 1 : 0

  source  = "Azure/avm-utl-network-ip-addresses/azurerm"
  version = "0.1.0"

  address_space    = var.virtual_network_address_space[0]
  address_prefixes = { for key, value in var.virtual_network_subnets : key => value.prefix_size }
  enable_telemetry = var.enable_telemetry
}

module "virtual_network" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.8.1"

  name                = local.resource_names.virtual_network_name
  location            = var.location
  resource_group_name = local.resource_group_name
  address_space       = var.virtual_network_address_space
  subnets             = local.subnets
  tags                = var.tags
  enable_telemetry    = var.enable_telemetry
}
