module "private_dns_zone_web_sites" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.azurewebsites.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "aazure-websites"
      vnetid       = local.virtual_network_id
    }
  }

  enable_telemetry = var.enable_telemetry
  tags             = var.tags
}

module "app_service_plan" {
  count = var.app_service_plan_create ? 1 : 0

  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "0.4.0"

  name                = local.resource_names.app_service_plan_name
  resource_group_name = local.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku_name
  worker_count        = var.app_service_plan_capacity
  tags                = var.tags
  enable_telemetry    = var.enable_telemetry
}

# TODO: App Service Environment

module "web_app_frontend" {
  count   = var.app_service_create ? 1 : 0
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                        = local.resource_names.app_service_name
  resource_group_name         = local.resource_group_name
  location                    = var.location
  service_plan_resource_id    = local.app_service_plan_id
  kind                        = "webapp"
  os_type                     = "Linux"
  enable_application_insights = false
  virtual_network_subnet_id   = module.virtual_network[0].subnets["04_app_service"].resource_id
  tags                        = var.tags
  enable_telemetry            = var.enable_telemetry

  private_endpoints = var.use_private_networking ? {
    primary = {
      private_dns_zone_resource_ids = var.use_private_networking && var.virtual_network_create ? [module.private_dns_zone_web_sites[0].resource_id] : []
      subnet_resource_id            = module.virtual_network[0].subnets["04_app_service"].resource_id
      subresource_name              = "sites"
      tags                          = var.tags
    }
  } : null
}

# TODO: Create App Insights

