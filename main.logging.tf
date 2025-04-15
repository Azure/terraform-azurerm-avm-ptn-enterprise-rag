module "private_dns_zone_log_analytics" {
  count = var.use_private_networking && var.virtual_network_create ? 1 : 0

  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.3.2"

  resource_group_name = local.resource_group_name
  domain_name         = "privatelink.monitor.azure.net"

  virtual_network_links = {
    primary = {
      vnetlinkname = "azure-monitor"
      vnetid       = local.virtual_network_id
    }
  }

  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "application_insights" {
  count = var.application_insights_create ? 1 : 0

  source  = "Azure/avm-res-insights-component/azurerm"
  version = "0.1.5"

  name                          = local.resource_names.application_insights_name
  location                      = var.location
  resource_group_name           = local.resource_group_name
  workspace_id                  = local.log_analytics_workspace_id
  application_type              = var.application_insights_type
  local_authentication_disabled = true
  internet_ingestion_enabled    = !var.use_private_networking
  internet_query_enabled        = !var.use_private_networking
  tags                          = var.tags
  enable_telemetry              = var.enable_telemetry
}

module "log_analytics_workspace" {
  count   = var.log_analytics_workspace_create ? 1 : 0
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.2"

  name                                      = local.resource_names.log_analytics_workspace_name
  location                                  = var.location
  resource_group_name                       = local.resource_group_name
  log_analytics_workspace_sku               = var.log_analytics_workspace_sku
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  tags                                      = var.tags
  enable_telemetry                          = var.enable_telemetry
}

# TODO: Private Monitor Link Scope Creation
