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
  count = var.use_private_networking ? 1 : 0

  name                 = "AzureBastionSubnet"
  virtual_network_name = provider::azurerm::parse_resource_id(local.virtual_network_id).resource_name
  resource_group_name  = provider::azurerm::parse_resource_id(local.virtual_network_id).resource_group_name

  depends_on = [module.virtual_network] # dynamically retrieves AzureBastionSubnet if created or using existing
}

data "azurerm_search_service" "this" {
  count = !var.azure_ai_search_create ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.azure_ai_search_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.azure_ai_search_id).resource_group_name
}

data "azurerm_key_vault" "this" {
  count = !var.key_vault_create ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.key_vault_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.key_vault_id).resource_group_name
}

data "azurerm_application_insights" "this" {
  count = !var.application_insights_create ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.application_insights_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.application_insights_id).resource_group_name
}

data "azurerm_cognitive_account" "this" {
  count = !var.azure_ai_services_create ? 1 : 0

  name                = provider::azurerm::parse_resource_id(var.azure_ai_services_id).resource_name
  resource_group_name = provider::azurerm::parse_resource_id(var.azure_ai_services_id).resource_group_name
}