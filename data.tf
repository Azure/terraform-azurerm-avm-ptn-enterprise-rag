data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://api.ipify.org/"
  retry {
    attempts     = 5
    max_delay_ms = 1000
    min_delay_ms = 500
  }
}

data "azurerm_subnet" "bastion" {
  count = var.use_private_networking && var.bastion_host_create ? 1 : 0

  name                 = "AzureBastionSubnet"
  virtual_network_name = provider::azurerm::parse_resource_id(local.virtual_network_id).resource_name
  resource_group_name  = provider::azurerm::parse_resource_id(local.virtual_network_id).resource_group_name

  depends_on = [module.virtual_network]
}