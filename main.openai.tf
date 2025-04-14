module "private_dns_zone_open_ai" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.openai.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "open-ai"
      vnetid       = local.virtual_network_id
    }
  }

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "azure_open_ai" {
  count = var.azure_open_ai_create ? 1 : 0

  source  = "Azure/avm-res-cognitiveservices-account/azurerm"
  version = "0.7.0"

  kind                          = "OpenAI"
  name                          = local.resource_names.azure_open_ai_name
  location                      = var.location
  resource_group_name           = local.resource_group_name
  sku_name                      = var.azure_open_ai_sku
  public_network_access_enabled = !var.use_private_networking
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry

  private_endpoints = var.use_private_networking ? {
    primary = {
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_ai_services[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["01_ai"].resource_id
      subresource_name              = "account"
      tags                          = var.tags
    }
  } : null
}

# TODO: Deployments
# TODO: Secrets
