module "bastion_host_public_ip" {
  count = var.use_private_networking && var.bastion_host_use ? 1 : 0

  source  = "Azure/avm-res-network-publicipaddress/azurerm"
  version = "0.2.0"

  name                = local.resource_names.bastion_host_public_ip_name
  location            = var.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  #diagnostic_settings = local.diagnostic_settings
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "bastion_host" {
  count = var.use_private_networking && var.bastion_host_use ? 1 : 0

  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.4.0"

  name                   = local.resource_names.bastion_host_name
  location               = var.location
  resource_group_name    = local.resource_group_name
  copy_paste_enabled     = true
  file_copy_enabled      = false
  sku                    = "Standard"
  ip_connect_enabled     = true
  scale_units            = 2
  shareable_link_enabled = true
  tunneling_enabled      = true

  ip_configuration = {
    name                 = "ipconfig"
    subnet_id            = module.virtual_network[0].subnets["02_bastion"].resource_id
    public_ip_address_id = module.bastion_host_public_ip[0].public_ip_id
  }

  #diagnostic_settings = local.diagnostic_settings
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}