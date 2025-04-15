# Calculate resource names
locals {
  name_replacements = {
    workload       = var.resource_name_workload
    environment    = var.resource_name_environment
    location       = var.location
    location_short = coalesce(var.resource_name_location_short, substr(var.location, 0, 3))
    uniqueness     = random_string.unique_name.id
    sequence       = format("%03d", var.resource_name_sequence_start)
  }

  resource_names = { for key, value in var.resource_name_templates : key => templatestring(value, local.name_replacements) }
}

# Resources
locals {
  resource_group_name                    = var.resource_group_create ? module.resource_group[0].name : var.resource_group_name
  virtual_network_id                     = var.virtual_network_create ? module.virtual_network[0].resource_id : var.virtual_network_id
  app_service_plan_id                    = var.app_service_plan_create ? module.app_service_plan[0].resource_id : var.app_service_plan_id
  app_service_id                         = var.app_service_create ? module.web_app_frontend[0].resource_id : var.app_service_id
  application_insights_id                = var.application_insights_create ? module.application_insights[0].resource_id : var.application_insights_id
  application_insights_key               = var.application_insights_create ? module.application_insights[0].instrumentation_key : data.azurerm_application_insights.this[0].instrumentation_key
  application_insights_connection_string = var.application_insights_create ? module.application_insights[0].connection_string : data.azurerm_application_insights.this[0].connection_string
  ai_search_id                           = var.azure_ai_search_create ? module.ai_search[0].resource_id : var.azure_ai_search_id
  ai_search_primary_key                  = var.azure_ai_search_create ? module.ai_search[0].resource.primary_key : data.azurerm_search_service.this[0].primary_key
  ai_services_id                         = var.azure_ai_services_create ? module.ai_services[0].resource_id : var.azure_ai_services_id
  ai_services_name                       = var.azure_ai_services_create ? module.ai_services[0].name : provider::azurerm::parse_resource_id(var.azure_ai_services_id).resource_name
  ai_services_primary_key                = var.azure_ai_services_create ? module.ai_services[0].primary_key : data.azurerm_cognitive_account.this[0].primary_key
  azure_open_ai_id                       = var.azure_open_ai_create ? module.azure_open_ai[0].resource_id : var.azure_open_ai_id
  log_analytics_workspace_id             = var.log_analytics_workspace_create ? module.log_analytics_workspace[0].resource_id : var.log_analytics_workspace_resource_id
  cosmos_db_account_id                   = var.cosmos_db_create ? module.cosmos_db[0].resource_id : var.cosmos_db_account_id
  orchestrator_function_app_id           = module.orchestrator_function_app[0].resource_id
  data_ingestion_function_app_id         = module.data_ingestion_function_app[0].resource_id
  bastion_host_id                        = var.bastion_host_create ? module.bastion_host[0].resource_id : null
  key_vault_id                           = var.key_vault_create ? module.key_vault[0].resource_id : var.key_vault_id
  key_vault_endpoint                     = var.key_vault_create ? module.key_vault[0].vault_uri : data.azurerm_key_vault.key_vault.vault_uri
  kay_vault_bastion_id                   = var.key_vault_bastion_create ? module.key_vault_bastion[0].resource_id : var.key_vault_bastion_id
  storage_account_id                     = var.storage_account_create ? module.storage_account[0].resource_id : var.storage_account_id
  storage_account_name                   = var.storage_account_create ? module.storage_account[0].name : provider::azurerm::parse_resource_id(var.storage_account_id).resource_name
}

locals {
  diagnostic_settings = {}
}

# My IP address
locals {
  my_ip_address_split = split(".", data.http.ip.response_body)
  my_cidr_slash_24    = "${join(".", slice(local.my_ip_address_split, 0, 3))}.0/24"
}
