module "application_insights" {
  count = var.application_insights_create ? 1 : 0

  source  = "Azure/avm-res-insights-component/azurerm"
  version = "0.1.5"

  name                                  = local.resource_names.application_insights_name
  location                              = var.location
  resource_group_name                   = local.resource_group_name
  workspace_id                          = local.log_analytics_workspace_id
  application_type                      = try(var.application_insights.application_type, "web")
  daily_data_cap_in_gb                  = try(var.application_insights.daily_data_cap_in_gb, null)
  daily_data_cap_notifications_disabled = try(var.application_insights.daily_data_cap_notifications_disabled, null)
  disable_ip_masking                    = try(var.application_insights.disable_ip_masking, null)
  local_authentication_disabled         = try(var.application_insights.local_authentication_disabled, null)
  internet_ingestion_enabled            = !var.use_private_networking
  internet_query_enabled                = !var.use_private_networking
  lock                                  = try(var.application_insights.lock, null)
  managed_identities                    = try(var.application_insights.managed_identities, null)
  retention_in_days                     = try(var.application_insights.retention_in_days, null)
  sampling_percentage                   = try(var.application_insights.sampling_percentage, null)
  tags                                  = merge(var.tags, try(var.application_insights.tags, null))
  enable_telemetry                      = var.enable_telemetry
}

module "log_analytics_workspace" {
  count   = var.log_analytics_workspace_create ? 1 : 0
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.2"

  name                                                       = local.resource_names.log_analytics_workspace_name
  location                                                   = var.location
  resource_group_name                                        = local.resource_group_name
  customer_managed_key                                       = try(var.log_analytics_workspace.customer_managed_key, null)
  diagnostic_settings                                        = try(var.log_analytics_workspace.diagnostic_settings, null)
  lock                                                       = try(var.log_analytics_workspace.lock, null)
  log_analytics_workspace_allow_resource_only_permissions    = try(var.log_analytics_workspace.log_analytics_workspace_allow_resource_only_permissions, null)
  log_analytics_workspace_cmk_for_query_forced               = try(var.log_analytics_workspace.log_analytics_workspace_cmk_for_query_forced, null)
  log_analytics_workspace_daily_quota_gb                     = try(var.log_analytics_workspace.log_analytics_workspace_daily_quota_gb, null)
  log_analytics_workspace_identity                           = try(var.log_analytics_workspace.log_analytics_workspace_identity, null)
  log_analytics_workspace_internet_ingestion_enabled         = !var.use_private_networking
  log_analytics_workspace_internet_query_enabled             = !var.use_private_networking
  log_analytics_workspace_local_authentication_disabled      = try(var.log_analytics_workspace.log_analytics_workspace_local_authentication_disabled, null)
  log_analytics_workspace_reservation_capacity_in_gb_per_day = try(var.log_analytics_workspace.log_analytics_workspace_reservation_capacity_in_gb_per_day, null)
  log_analytics_workspace_timeouts                           = try(var.log_analytics_workspace.log_analytics_workspace_timeouts, null)
  log_analytics_workspace_sku                                = try(var.log_analytics_workspace.log_analytics_workspace_sku, null)
  log_analytics_workspace_retention_in_days                  = try(var.log_analytics_workspace.log_analytics_workspace_retention_in_days, null)
  private_endpoints                                          = var.use_private_networking ? try(var.log_analytics_workspace.private_endpoints, null) : null
  private_endpoints_manage_dns_zone_group                    = try(var.log_analytics_workspace.private_endpoints_manage_dns_zone_group, null)
  role_assignments                                           = try(var.log_analytics_workspace.role_assignments, null)
  tags                                                       = merge(var.tags, try(var.log_analytics_workspace.tags, null))
  enable_telemetry                                           = var.enable_telemetry
}