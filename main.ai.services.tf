module "private_dns_zone_ai_services" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.cognitiveservices.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "ai-services"
      vnetid       = local.virtual_network_id
    }
  }

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "ai_services" {
  count = var.azure_ai_services_create ? 1 : 0

  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.7.0"

  kind                          = "AIServices"
  name                          = local.resource_names.azure_ai_services_name
  location                      = var.location
  resource_group_name           = local.resource_group_name
  sku_name                      = var.ai_services_sku
  public_network_access_enabled = !var.use_private_networking
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry

  private_endpoints = var.use_private_networking ? {
    primary = {
      name                          = local.resource_names.azure_ai_services_private_endpoint_name
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_ai_services[0].resource_id] : [] # What if users want to reuse private dns zones?
      subnet_resource_id            = module.virtual_network[0].subnets["01_ai"].resource_id
      subresource_name              = "account"
      tags                          = var.tags
    }
  } : null

  # TODO: Deployments?
}

resource "azurerm_key_vault_secret" "ai_services_key" {
  for_each = toset(["formRecKey", "speechKey"])

  key_vault_id = local.key_vault_id
  name         = each.value
  value        = local.ai_services_primary_key
}