locals {
  subnets = var.use_private_networking ? { for key, value in var.virtual_network_subnets : key => {
    name             = value.name
    address_prefixes = [module.subnet_address_prefixes[0].address_prefixes[key]]
    }
  } : {}
}