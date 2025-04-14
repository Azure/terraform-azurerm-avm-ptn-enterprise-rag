module "orchestrator_function_app" {
  count   = var.orchestrator_function_app_create ? 1 : 0
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                        = local.resource_names.orchestrator_function_app_name
  resource_group_name         = local.resource_group_name
  location                    = var.location
  service_plan_resource_id    = local.app_service_plan_id
  storage_account_name        = module.orchestrator_storage_account[0].name
  kind                        = "functionapp"
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

module "data_ingestion_function_app" {
  count   = var.data_ingestion_function_app_create ? 1 : 0
  source  = "Azure/avm-res-web-site/azurerm"
  version = "0.15.1"

  name                        = local.resource_names.data_ingestion_function_app_name
  resource_group_name         = local.resource_group_name
  location                    = var.location
  service_plan_resource_id    = local.app_service_plan_id
  storage_account_name        = module.data_ingestion_storage_account[0].name
  kind                        = "functionapp"
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

# TODO: Identities