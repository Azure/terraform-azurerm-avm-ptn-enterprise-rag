locals {
  subnets = { for key, value in var.virtual_network_subnets : key => {
    name             = key
    address_prefixes = [module.subnet_address_prefixes.address_prefixes[key]]
    }
  }
}